function swatchColor(name) {
  const value = name.toLocaleLowerCase('vi');
  if (value.includes('switch') || value.includes('phiên bản') || value.includes('không áp dụng')) return null;
  if (value.includes('đen') || value.includes('than chì') || value.includes('navy') || value.includes('đêm')) return '#343842';
  if (value.includes('trắng')) return '#f5f5f2';
  if (value.includes('bạc') || value.includes('titan') || value.includes('xám')) return '#afb5ba';
  if (value.includes('hồng')) return '#e9b4bc';
  if (value.includes('tím')) return '#a69aca';
  if (value.includes('đỏ')) return '#ba3440';
  if (value.includes('cam')) return '#dc8d56';
  if (value.includes('nâu')) return '#96725e';
  if (value.includes('vàng') || value.includes('ánh sao') || value.includes('be')) return '#dbc693';
  if (value.includes('xanh lá') || value.includes('xanh lục') || value.includes('xô thơm')) return '#91bfa4';
  if (value.includes('xanh mòng két')) return '#69a9a8';
  if (value.includes('xanh')) return '#8cb5d2';
  return null;
}
document.querySelectorAll('[data-category-card]').forEach(card => {
  const variants = [...card.querySelectorAll('[data-card-variant]')];
  const colors = card.querySelector('[data-card-colors]');
  const image = card.querySelector('[data-card-image]');
  const price = card.querySelector('[data-card-price]');
  if (!variants.length) return;
  const distinct = [...new Set(variants.map(v => v.dataset.color?.trim()).filter(Boolean))];
  let selected = variants.find(v => v.getAttribute('aria-pressed') === 'true') || variants[0];
  function select(variant) {
    selected = variant;
    variants.forEach(v => { v.setAttribute('aria-pressed', String(v === variant)); v.hidden = distinct.length > 0 && v.dataset.color !== variant.dataset.color; });
    colors.querySelectorAll('button').forEach(b => b.setAttribute('aria-pressed', String(b.dataset.color === variant.dataset.color)));
    const colorLabel = colors.querySelector('[data-selected-color]');
    if (colorLabel) colorLabel.textContent = variant.dataset.color || '';
    const specs = [];
    if (+variant.dataset.ram > 0) specs.push(variant.dataset.ram + ' GB RAM');
    if (+variant.dataset.storage > 0) specs.push(variant.dataset.storage + ' GB');
    if (variant.dataset.cpu && variant.dataset.cpu !== 'Không áp dụng') specs.push(variant.dataset.cpu);
    card.querySelector('[data-card-spec]').textContent = specs.join(' · ');
    const amount = Number(variant.dataset.price);
    if (Number.isFinite(amount)) price.textContent = new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
    if (image && variant.dataset.image) image.src = variant.dataset.image;
    card.querySelectorAll('[data-card-link]').forEach(link => { link.href = variant.dataset.link; });
  }
  if (distinct.length > 1) {
    const label = document.createElement('span'); label.className = 'category-color-label'; label.dataset.selectedColor = ''; colors.append(label);
    distinct.forEach(color => {
      const button = document.createElement('button'); button.type = 'button'; button.dataset.color = color;
      button.setAttribute('aria-label', 'Chọn màu ' + color); button.title = color;
      const swatch = swatchColor(color);
      if (swatch) { button.className = 'category-color-swatch'; button.style.setProperty('--swatch-color', swatch); }
      else { button.className = 'category-color-text'; button.textContent = color; }
      button.addEventListener('click', () => select(variants.find(v => v.dataset.color?.trim() === color))); colors.append(button);
    });
  }
  variants.forEach(variant => variant.addEventListener('click', () => select(variant)));
  select(selected);
});
const categorySort = document.querySelector('#category-sort');
categorySort?.addEventListener('change', () => categorySort.form.requestSubmit());
const filterMenus = [...document.querySelectorAll('.filter-popover')];
filterMenus.forEach(menu => menu.addEventListener('toggle', () => {
  if (menu.open) filterMenus.forEach(other => { if (other !== menu) other.open = false; });
}));
document.addEventListener('click', event => {
  if (!event.target.closest('.filter-popover')) filterMenus.forEach(menu => { menu.open = false; });
});
const priceFilter = document.querySelector('[data-price-filter]');
if (priceFilter) {
  const minField = priceFilter.querySelector('[name="giaTu"]');
  const maxField = priceFilter.querySelector('[name="giaDen"]');
  const minSlider = priceFilter.querySelector('[data-range-min]');
  const maxSlider = priceFilter.querySelector('[data-range-max]');
  const upper = 50000000;
  const formatter = new Intl.NumberFormat('vi-VN');
  const money = amount => formatter.format(amount) + ' ₫';
  function makeDisplay(field) {
    const visible = field.cloneNode();
    visible.type = 'text';
    visible.removeAttribute('name');
    visible.removeAttribute('id');
    visible.inputMode = 'numeric';
    field.type = 'hidden';
    field.insertAdjacentElement('afterend', visible);
    return visible;
  }
  const minDisplay = makeDisplay(minField), maxDisplay = makeDisplay(maxField);
  function format(field, value) { field.value = value === '' ? '' : formatter.format(Number(value)); }
  function numeric(field) { return field.value === '' ? '' : field.value.replace(/\D/g, ''); }
  [minSlider, maxSlider].forEach(slider => { slider.min = '0'; slider.max = String(upper); slider.step = '1'; });
  function draw() {
    const lo = minField.value === '' ? 0 : Number(minField.value);
    const hi = maxField.value === '' ? upper : Number(maxField.value);
    minSlider.value = String(Math.min(upper, Math.max(0, lo)));
    maxSlider.value = String(Math.min(upper, Math.max(0, hi)));
    minDisplay.setCustomValidity(lo > upper ? 'Giá không được vượt quá 50.000.000 ₫.' : '');
    maxDisplay.setCustomValidity(hi > upper ? 'Giá không được vượt quá 50.000.000 ₫.' : minField.value !== '' && maxField.value !== '' && lo > hi ? 'Giá cao nhất phải lớn hơn hoặc bằng giá thấp nhất.' : '');
    minSlider.setAttribute('aria-valuetext', money(+minSlider.value));
    maxSlider.setAttribute('aria-valuetext', maxField.value === '' ? 'Không giới hạn' : money(+maxSlider.value));
    priceFilter.style.setProperty('--price-start', (+minSlider.value / upper * 100) + '%');
    priceFilter.style.setProperty('--price-end', (+maxSlider.value / upper * 100) + '%');
  }
  [[minDisplay,minField],[maxDisplay,maxField]].forEach(([visible,field]) => {
    format(visible,field.value);
    visible.addEventListener('input', () => {
      const digitsBefore = visible.value.slice(0, visible.selectionStart).replace(/\D/g, '').length;
      const digits = numeric(visible);
      field.value = digits === '' ? '' : String(Number(digits));
      format(visible,field.value);
      let position = 0, count = 0;
      while (position < visible.value.length && count < digitsBefore) { if (/\d/.test(visible.value[position])) count++; position++; }
      visible.setSelectionRange(position, position);
      draw();
    });
  });
  minSlider.addEventListener('input', () => {
    const value = Math.min(+minSlider.value, +maxSlider.value);
    minField.value = value ? String(value) : '';
    format(minDisplay,minField.value);
    draw();
  });
  maxSlider.addEventListener('input', () => {
    const value = Math.max(+maxSlider.value, +minSlider.value);
    maxField.value = value === upper ? '' : String(value);
    format(maxDisplay,maxField.value);
    draw();
  });
  priceFilter.querySelector('[data-price-track]').hidden = false;
  priceFilter.querySelector('[data-price-scale]').hidden = false;
  draw();
}
