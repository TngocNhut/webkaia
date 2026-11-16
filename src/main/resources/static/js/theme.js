(function () {
  const root = document.documentElement;
  try { root.dataset.theme = localStorage.getItem('kaia-theme') || 'light'; } catch (_) { root.dataset.theme = 'light'; }
  document.addEventListener('click', function (event) {
    const choice = event.target.closest('[data-theme-choice]');
    if (!choice) return;
    root.dataset.theme = choice.dataset.themeChoice;
    try { localStorage.setItem('kaia-theme', root.dataset.theme); } catch (_) {}
    document.querySelectorAll('[data-theme-choice]').forEach(button => button.setAttribute('aria-pressed', String(button.dataset.themeChoice === root.dataset.theme)));
    choice.closest('details').open = false;
  });
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-theme-choice]').forEach(button => button.setAttribute('aria-pressed', String(button.dataset.themeChoice === root.dataset.theme)));
  });
})();
