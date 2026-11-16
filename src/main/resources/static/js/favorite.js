'use strict';
const favoriteForm = document.querySelector('[data-favorite-form]');
const favoriteStatus = document.querySelector('[data-favorite-status]');
if (favoriteForm && favoriteStatus) {
  const button = favoriteForm.querySelector('button');
  let timer;
  function show(message) {
    favoriteStatus.textContent = message;
    favoriteStatus.hidden = false;
    clearTimeout(timer);
    timer = setTimeout(() => { favoriteStatus.hidden = true; }, 3500);
  }
  if (!favoriteStatus.hidden) timer = setTimeout(() => { favoriteStatus.hidden = true; }, 3500);
  favoriteForm.addEventListener('submit', async event => {
    event.preventDefault();
    button.disabled = true;
    try {
      const response = await fetch(favoriteForm.action, {
        method: 'POST', body: new URLSearchParams(new FormData(favoriteForm)),
        headers: { 'X-Requested-With': 'XMLHttpRequest', 'Accept': 'application/json' }
      });
      if (response.redirected && new URL(response.url).pathname === '/login') {
        window.location.assign(response.url); return;
      }
      const result = await response.json();
      if (!response.ok) throw new Error(result.message || 'Không thể cập nhật yêu thích.');
      button.setAttribute('aria-pressed', String(result.saved));
      const action = result.saved ? 'Bỏ khỏi yêu thích' : 'Thêm vào yêu thích';
      button.setAttribute('aria-label', action); button.title = action;
      show((result.saved ? 'Bạn đã thích sản phẩm ' : 'Đã bỏ yêu thích sản phẩm ') + favoriteForm.dataset.productName);
    } catch (error) {
      show(error.message || 'Không thể cập nhật yêu thích. Vui lòng thử lại.');
    } finally { button.disabled = false; }
  });
}
