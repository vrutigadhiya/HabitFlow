(function () {

  /* ── Toast System ── */
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
      grid.querySelectorAll('.e-btn').forEach(function (b) { b.classList.remove('sel'); });
      btn.classList.add('sel');
      if (hidden) hidden.value = btn.dataset.e;
    });
  }

  /* ── Category → emoji sync ── */
  var catSel = document.getElementById('catSel');
  var emojiMap = { health:'🥗', fitness:'💪', mind:'🧠', work:'💼', other:'🎯' };
  if (catSel && grid) {
    catSel.addEventListener('change', function () {
      var e = emojiMap[catSel.value] || '🎯';
      grid.querySelectorAll('.e-btn').forEach(function (b) {
        b.classList.toggle('sel', b.dataset.e === e);
      });
      if (hidden) hidden.value = e;
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
      var lbl = ['','Weak 😬','Fair 🙂','Good 👍','Strong 💪'][s] || '';
      var col = ['','var(--red)','var(--amber)','var(--blue)','var(--green)'][s] || 'var(--muted)';
      meter.textContent = v.length ? 'Password: ' + lbl : '';
      meter.style.color = col;
    });
  }

  /* ── Animate stat counters ── */
  window.animateCount = function (el, from, to, duration) {
    if (!el) return;
    var start = null;
    var suffix = el.dataset.suffix || '';
    function step(ts) {
      if (!start) start = ts;
      var prog = Math.min((ts - start) / duration, 1);
      var ease = 1 - Math.pow(1 - prog, 3);
      el.textContent = Math.round(from + (to - from) * ease) + suffix;
      if (prog < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  };

  document.querySelectorAll('.stat-val[data-target]').forEach(function (el) {
    var target = parseInt(el.dataset.target);
    var suffix = el.dataset.suffix || '';
    animateCount(el, 0, target, 900);
  });

  /* ── Activity Calendar ── */
  var cal = document.getElementById('calGrid');
  if (cal) {
    for (var i = 27; i >= 0; i--) {
      var d = document.createElement('div');
      d.className = 'cal-cell';
      var r = Math.random();
      if      (r > 0.8) d.classList.add('c4');
      else if (r > 0.6) d.classList.add('c3');
      else if (r > 0.4) d.classList.add('c2');
      else if (r > 0.25) d.classList.add('c1');
      if (i === 0) d.classList.add('today');
      cal.appendChild(d);
    }
  }

  /* ── Motivational Quotes ── */
  var quotes = [
    { text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.", author: "Aristotle" },
    { text: "Motivation gets you started. Habit keeps you going.", author: "Jim Ryun" },
    { text: "Small daily improvements over time lead to stunning results.", author: "Robin Sharma" },
    { text: "You do not rise to the level of your goals. You fall to the level of your systems.", author: "James Clear" },
    { text: "The secret of your future is hidden in your daily routine.", author: "Mike Murdock" },
    { text: "Discipline is choosing between what you want now and what you want most.", author: "Abraham Lincoln" },
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

  /* ── Strict Mode toggle ── */
  window.toggleStrict = function (el) {
    var on = el.checked;
    showToast(on ? '🔒 Strict mode ON — no excuses!' : '🔓 Strict mode OFF', on ? 'ok' : 'inf');
    localStorage.setItem('strictMode', on ? '1' : '0');
    document.querySelectorAll('[id^=strictToggle]').forEach(function (t) { t.checked = on; });
  };

  window.toggleStrictFromSidebar = function () {
    var current = localStorage.getItem('strictMode') !== '0';
    var next = !current;
    localStorage.setItem('strictMode', next ? '1' : '0');
    showToast(next ? '🔒 Strict mode ON' : '🔓 Strict mode OFF', next ? 'ok' : 'inf');
    document.querySelectorAll('[id^=strictToggle]').forEach(function (t) { t.checked = next; });
  };

  // Apply saved strict mode state
  var strict = localStorage.getItem('strictMode');
  if (strict !== null) {
    document.querySelectorAll('[id^=strictToggle]').forEach(function (t) { t.checked = strict === '1'; });
  }

  /* ── Browser notification scheduler ── */
  function scheduleReminder(habitName, timeStr) {
    if (!('Notification' in window) || Notification.permission !== 'granted') return;
    var parts = timeStr.split(':');
    if (parts.length < 2) return;
    var now = new Date();
    var remind = new Date();
    remind.setHours(parseInt(parts[0]), parseInt(parts[1]), 0, 0);
    var diff = remind - now;
    if (diff > 0 && diff < 3600000 * 12) {
      setTimeout(function () {
        new Notification('HabitFlow Reminder 🔔', {
          body: 'Time to: ' + habitName + '! Don\'t break your streak 🔥',
          icon: ''
        });
      }, diff);
    }
  }

  /* ── Page load toast ── */
  var params = new URLSearchParams(window.location.search);
  if (params.get('added')   === 'true') showToast('✅ Habit added!', 'ok');
  if (params.get('deleted') === 'true') showToast('🗑 Habit removed', 'err');
  if (params.get('done')    === 'true') showToast('🔥 Habit completed! Streak growing!', 'ok');

  /* ── Keyboard shortcut: N = new habit ── */
  document.addEventListener('keydown', function (e) {
    if (e.key === 'n' && !e.ctrlKey && !e.metaKey && document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
      var f = document.getElementById('addForm');
      if (f) { f.style.display = f.style.display === 'none' ? 'block' : 'none'; }
    }
  });

})();