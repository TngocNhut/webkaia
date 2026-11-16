(() => {
  const button = document.querySelector('[data-voice-search]');
  const status = document.querySelector('[data-voice-status]');
  const input = document.querySelector('#search-q');
  const form = button?.closest('form');
  if (!button || !status || !input || !form) return;

  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  let localAvailable = false;
  if (typeof SpeechRecognition?.available === 'function') {
    SpeechRecognition.available({langs: ['vi-VN'], processLocally: true})
      .then(result => { localAvailable = result === 'available'; }).catch(() => {});
  }
  let recognition, active = false, messageTimer, idleTimer, limitTimer;
  function message(text, autoHide = true) {
    clearTimeout(messageTimer);
    status.textContent = text;
    status.hidden = !text;
    if (text && autoHide) messageTimer = setTimeout(() => { status.hidden = true; status.textContent = ''; }, 2000);
  }
  function resetTimers() { clearTimeout(idleTimer); clearTimeout(limitTimer); }
  button.addEventListener('click', () => {
    if (!SpeechRecognition) { message('Trình duyệt chưa hỗ trợ tìm kiếm bằng giọng nói. Bạn có thể nhập từ khóa.'); return; }
    if (active) { recognition.stop(); return; }

    recognition = new SpeechRecognition();
    recognition.lang = 'vi-VN';
    recognition.continuous = false;
    recognition.interimResults = true;
    recognition.maxAlternatives = 1;
    if (localAvailable && 'processLocally' in recognition) recognition.processLocally = true;
    let transcript = '', failed = false, submitted = false;
    const initialValue = input.value;
    const finish = () => {
      if (submitted || failed || !transcript) return;
      submitted = true;
      input.value = transcript.replace(/[.,!?。！？]+$/u, '').trim();
      if (!input.value) return;
      input.dispatchEvent(new Event('input', {bubbles: true}));
      message('Đã nhận giọng nói. Đang tìm kiếm…', false);
      form.requestSubmit();
    };
    recognition.onstart = () => {
      button.setAttribute('aria-pressed', 'true');
      message('Đang nghe… Hãy nói tên sản phẩm.', false);
      idleTimer = setTimeout(() => { message('Chưa nhận dạng được lời nói. Hãy kiểm tra micro và thử lại.'); recognition.stop(); }, 7000);
      limitTimer = setTimeout(() => recognition.stop(), 20000);
    };
    recognition.onaudiostart = () => message('Micro đã bật. Hãy nói tên sản phẩm.', false);
    recognition.onspeechstart = () => { clearTimeout(idleTimer); message('Đang nhận dạng lời nói…', false); };
    recognition.onspeechend = () => { clearTimeout(idleTimer); recognition.stop(); };
    recognition.onresult = event => {
      let final = false;
      transcript = Array.from(event.results, result => {
        if (result.isFinal) final = true;
        return result[0]?.transcript || '';
      }).join(' ').trim();
      if (!transcript) return;
      clearTimeout(idleTimer);
      input.value = transcript;
      input.dispatchEvent(new Event('input', {bubbles: true}));
      if (final) { recognition.stop(); finish(); }
    };
    recognition.onerror = event => {
      failed = true;
      resetTimers();
      const messages = {
        'not-allowed': 'Bạn cần cho phép sử dụng micro để tìm kiếm bằng giọng nói.',
        'service-not-allowed': 'Trình duyệt không cho phép dịch vụ nhận dạng giọng nói.',
        'language-not-supported': 'Thiết bị chưa hỗ trợ nhận dạng tiếng Việt. Hãy nhập từ khóa.',
        'no-speech': 'Chưa nhận dạng được lời nói. Hãy kiểm tra micro và thử lại.',
        'audio-capture': 'Không tìm thấy micro. Hãy kiểm tra thiết bị và thử lại.',
        'network': 'Dịch vụ giọng nói của trình duyệt không kết nối được. Hãy thử Chrome hoặc nhập từ khóa.'
      };
      if (event.error === 'language-not-supported') localAvailable = false;
      if (!transcript) input.value = initialValue;
      message(messages[event.error] || 'Chưa thể nhận dạng giọng nói. Vui lòng thử lại hoặc nhập từ khóa.');
    };
    recognition.onend = () => {
      resetTimers();
      active = false;
      button.setAttribute('aria-pressed', 'false');
      if (!failed && transcript) finish();
      else if (!failed && !status.hidden) message('Chưa nhận dạng được lời nói. Hãy kiểm tra micro và thử lại.');
    };
    try { active = true; recognition.start(); }
    catch (_) { active = false; resetTimers(); button.setAttribute('aria-pressed', 'false'); message('Chưa thể mở micro. Vui lòng thử lại.'); }
  });
})();
