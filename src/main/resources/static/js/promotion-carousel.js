(() => {
  const carousel = document.querySelector('[data-promotion-carousel]');
  if (!carousel) return;
  const slides = [...carousel.querySelectorAll('[data-promotion-slide]')];
  const tabs = [...carousel.querySelectorAll('[data-promotion-tab]')];
  if (slides.length < 2) return;
  const status = carousel.querySelector('[data-promotion-status]');
  let current = 0;
  function show(index) {
    current = (index + slides.length) % slides.length;
    slides.forEach((slide, i) => { slide.hidden = i !== current; });
    tabs.forEach((tab, i) => tab.setAttribute('aria-current', String(i === current)));
    status.textContent = `Chương trình ${current + 1} / ${slides.length}: ${tabs[current].textContent.trim()}`;
  }
  tabs.forEach((tab, i) => tab.addEventListener('click', () => show(i)));
  carousel.querySelector('[data-promotion-prev]').addEventListener('click', () => show(current - 1));
  carousel.querySelector('[data-promotion-next]').addEventListener('click', () => show(current + 1));
})();
