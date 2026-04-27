(function () {

  /* ── Toast ── */
  window.showToast = function (msg, type) {
    var wrap = document.getElementById('toastWrap');
    if (!wrap) return;
    var t = document.createElement('div');
    t.className = 'toast';
    var dot = document.createElement('div');
    dot.className = 'toast-dot ' + (type || 'inf');
    t.appendChild(dot);
    t.appendChild(document.createTextNode(msg));
    wrap.appendChild(t);
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { t.classList.add('show'); });
    });
    setTimeout(function () {
      t.classList.remove('show');
      setTimeout(function () { t.remove(); }, 400);
    }, 3500);
  };

  /* ── Emoji Picker ── */
  var grid = document.getElementById('emojiGrid');
  var hidden = document.getElementById('selEmoji');
  if (grid) {
    grid.addEventListener('click', function (e) {
      var btn = e.target.closest('.e-btn');
      if (!btn) return;
      grid.querySelectorAll('.e-btn').forEach(function (b) {
        b.classList.remove('sel');
      });
      btn.classList.add('sel');
      if (hidden) hidden.value = btn.dataset.e;
    });
  }

  /* ── Password Strength ── */
  var pwd = document.querySelector('input[name="password"]');
  var meter = document.getElementById('pwdStrength');
  if (pwd && meter) {
    pwd.addEventListener('input', function () {
      var v = pwd.value, s = 0;
      if (v.length >= 8) s++;
      if (/[A-Z]/.test(v)) s++;
      if (/[0-9]/.test(v)) s++;
      if (/[^A-Za-z0-9]/.test(v)) s++;
      var labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
      var colors = ['', 'var(--red)', 'var(--amber)', 'var(--blue)', 'var(--green)'];
      meter.textContent = v.length ? 'Password strength: ' + labels[s] : '';
      meter.style.color = colors[s] || 'var(--muted)';
    });
  }

  /* ── Animate stat counters ── */
  window.animateCount = function (el, from, to, duration) {
    if (!el) return;
    var start = null;
    function step(ts) {
      if (!start) start = ts;
      var prog = Math.min((ts - start) / duration, 1);
      var ease = 1 - Math.pow(1 - prog, 3);
      var suffix = el.dataset.suffix || '';
      el.textContent = Math.round(from + (to - from) * ease) + suffix;
      if (prog < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  };

  document.querySelectorAll('.stat-val[data-target]').forEach(function (el) {
    var target = parseInt(el.dataset.target);
    animateCount(el, 0, target, 900);
  });

  /* ── Activity Calendar ── */
  var cal = document.getElementById('calGrid');
  if (cal) {
    for (var i = 27; i >= 0; i--) {
      var d = document.createElement('div');
      d.className = 'cal-cell';
      var rand = Math.random();
      if      (rand > 0.8)  d.classList.add('c4');
      else if (rand > 0.6)  d.classList.add('c3');
      else if (rand > 0.4)  d.classList.add('c2');
      else if (rand > 0.25) d.classList.add('c1');
      if (i === 0) d.classList.add('today');
      cal.appendChild(d);
    }
  }

  /* ── Motivational Quotes ── */
  var quotes = [
    { text: "We are what we repeatedly do.", author: "Aristotle" },
    { text: "Motivation gets you started. Habit keeps you going.", author: "Jim Ryun" },
    { text: "Small daily improvements lead to stunning results.", author: "Robin Sharma" },
    { text: "You do not rise to your goals. You fall to your systems.", author: "James Clear" },
    { text: "The secret of your future is in your daily routine.", author: "Mike Murdock" },
    { text: "Discipline is choosing what you want most.", author: "Abraham Lincoln" },
    { text: "A year from now you may wish you had started today.", author: "Karen Lamb" }
  ];
  var qi = Math.floor(Math.random() * quotes.length);

  function renderQuote() {
    var qt = document.getElementById('quoteText');
    var qa = document.getElementById('quoteAuthor');
    if (!qt || !qa) return;
    qt.textContent = '"' + quotes[qi].text + '"';
    qa.textContent = '— ' + quotes[qi].author;
  }

  window.nextQuote = function () {
    qi = (qi + 1) % quotes.length;
    renderQuote();
  };

  renderQuote();

  /* ── Strict Mode ── */
  window.toggleStrict = function (el) {
    var on = el.checked;
    showToast(on ? 'Strict mode ON' : 'Strict mode OFF', on ? 'ok' : 'inf');
    localStorage.setItem('strictMode', on ? '1' : '0');
    document.querySelectorAll('[id^=strictToggle]').forEach(function (t) {
      t.checked = on;
    });
  };

  var strict = localStorage.getItem('strictMode');
  if (strict !== null) {
    document.querySelectorAll('[id^=strictToggle]').forEach(function (t) {
      t.checked = (strict === '1');
    });
  }

  /* ── URL param toasts ── */
  var params = new URLSearchParams(window.location.search);
  if (params.get('added')   === 'true') showToast('Habit added!', 'ok');
  if (params.get('deleted') === 'true') showToast('Habit deleted', 'err');
  if (params.get('done')    === 'true') showToast('Habit completed! Keep going!', 'ok');

})();