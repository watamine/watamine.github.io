// メニューの開閉を制御するコード例
document.addEventListener('DOMContentLoaded', function () {
  const menuToggle = document.querySelector('.menu-toggle');
  const asideMenu = document.querySelector('aside');

  menuToggle.addEventListener('click', function () {
    asideMenu.classList.toggle('is-open');
  });
});
