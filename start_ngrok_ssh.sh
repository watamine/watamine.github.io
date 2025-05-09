#!/bin/bash
# 古いngrokプロセスを止める（念のため）
pkill -f "ngrok tcp 22"

# 新しくngrok起動
ngrok tcp 22 > ~/ngrok.log &

# 少し待ってログ生成されるのを待つ
sleep 5

# ngrokログから接続情報を抽出
NGROK_URL=$(grep -o "tcp://[0-9a-z.]*:[0-9]*" ~/ngrok.log)
HOSTNAME=$(echo "$NGROK_URL" | cut -d/ -f3 | cut -d: -f1)
PORT=$(echo "$NGROK_URL" | cut -d: -f3)
USER_NAME=$(whoami)

cp ~/.ssh/config ~/.ssh/config.bak 2>/dev/null || true

# awkを使って特定のブロックを書き換え
awk -v hname="$HOSTNAME" -v port="$PORT" -v user="$USER_NAME" '
BEGIN { in_block = 0 }
/^Host[ \t]+myserver$/ { print; in_block = 1; next }
in_block && /^[ \t]*Host/ { in_block = 0 }
in_block { next }
{
  if (in_block == 0 && $0 ~ /^Host[ \t]+myserver$/) {
    print $0;
    print "    HostName " hname;
    print "    Port " port;
    print "    User " user;
    print "    IdentityFile ~/.ssh/id_ed25519";
    in_block = 1;
  } else {
    print $0;
  }
}' ~/.ssh/config.bak > ~/.ssh/config
echo "Host 'myserver' が最新の接続情報に更新されました。"
