<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.habit.model.*, java.util.*" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

  @SuppressWarnings("unchecked")
  List<Habit> habits = (List<Habit>) request.getAttribute("habits");
  if (habits == null) habits = new ArrayList<Habit>();

  int total = habits.size();
  int completed = 0;
  for (Habit h : habits) if (h.isCompletedToday()) completed++;
  int pct = total > 0 ? (completed * 100 / total) : 0;
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Habits - HabitFlow</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="layout">

  <%@ include file="sidebar.jsp" %>

  <main class="main">

    <div class="page-head">
      <div class="page-head-left">
        <h1>My Habits</h1>
        <p><%= completed %>/<%= total %> completed today</p>
      </div>
      <div class="page-head-right">
        <button class="btn btn-primary" onclick="toggleAddForm()">+ New Habit</button>
      </div>
    </div>

    <!-- Add Habit Form -->
    <div class="card" id="addForm" style="margin-bottom:24px;display:none">
      <div class="card-head">
        <span class="card-title">Add New Habit</span>
        <button class="btn btn-ghost btn-sm" onclick="toggleAddForm()">Cancel</button>
      </div>
      <div class="card-body">
        <form method="post" action="<%= request.getContextPath() %>/habits">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="emoji" id="selEmoji" value="target">

          <div class="form-group">
            <label class="form-label">Choose Icon</label>
            <div class="emoji-grid" id="emojiGrid">
              <button type="button" class="e-btn sel" data-e="target">&#127919;</button>
              <button type="button" class="e-btn" data-e="muscle">&#128170;</button>
              <button type="button" class="e-btn" data-e="brain">&#129504;</button>
              <button type="button" class="e-btn" data-e="book">&#128218;</button>
              <button type="button" class="e-btn" data-e="water">&#128167;</button>
              <button type="button" class="e-btn" data-e="salad">&#129367;</button>
              <button type="button" class="e-btn" data-e="yoga">&#129496;</button>
              <button type="button" class="e-btn" data-e="sleep">&#128564;</button>
              <button type="button" class="e-btn" data-e="write">&#9997;</button>
              <button type="button" class="e-btn" data-e="run">&#127939;</button>
              <button type="button" class="e-btn" data-e="bike">&#128692;</button>
              <button type="button" class="e-btn" data-e="music">&#127925;</button>
              <button type="button" class="e-btn" data-e="leaf">&#127807;</button>
              <button type="button" class="e-btn" data-e="coffee">&#9749;</button>
              <button type="button" class="e-btn" data-e="pill">&#128138;</button>
              <button type="button" class="e-btn" data-e="clean">&#129529;</button>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Habit Name *</label>
              <input type="text" name="name" class="input"
                     placeholder="e.g. Drink 2L water" required>
            </div>
            <div class="form-group">
              <label class="form-label">Category</label>
              <select name="category" class="select" id="catSel">
                <option value="health">Health</option>
                <option value="fitness">Fitness</option>
                <option value="mind">Mind</option>
                <option value="work">Work</option>
                <option value="other">Other</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Frequency</label>
              <select name="frequency" class="select">
                <option value="daily">Daily</option>
                <option value="weekdays">Weekdays only</option>
                <option value="weekly">Weekly</option>
                <option value="3x-week">3x per week</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Reminder Time</label>
              <input type="time" name="reminder" class="input" value="08:00">
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">Notes (optional)</label>
            <textarea name="description" class="textarea"
              placeholder="Why is this habit important to you?"></textarea>
          </div>

          <div style="display:flex;gap:10px">
            <button type="submit" class="btn btn-primary">Save Habit</button>
            <button type="button" class="btn btn-ghost"
                    onclick="toggleAddForm()">Cancel</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Filter Tabs -->
    <div style="display:flex;gap:8px;margin-bottom:20px;flex-wrap:wrap">
      <button class="btn btn-primary btn-sm filter-btn" data-filter="all">
        All (<%= total %>)
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="pending">
        Pending (<%= total - completed %>)
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="done">
        Done (<%= completed %>)
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="health">
        Health
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="fitness">
        Fitness
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="mind">
        Mind
      </button>
      <button class="btn btn-ghost btn-sm filter-btn" data-filter="work">
        Work
      </button>
    </div>

    <div class="grid-2-1">

      <!-- Habits List -->
      <div>
        <% if (habits.isEmpty()) { %>
        <div class="card">
          <div class="card-body">
            <div class="empty">
              <div class="empty-icon">&#127807;</div>
              <h3>No habits yet!</h3>
              <p>Click "+ New Habit" above to start your journey</p>
            </div>
          </div>
        </div>
        <% } else { %>
        <div class="habit-grid" id="habitGrid">
          <%
          for (Habit h : habits) {
            String raw = h.getDescription() != null ? h.getDescription() : "";
            String cat = "other", freq = "daily", remind = "", notes = "";
            if (raw.startsWith("[")) {
              int endBracket = raw.indexOf("]");
              if (endBracket > 0) {
                String meta = raw.substring(1, endBracket);
                String[] parts = meta.split("\\|");
                if (parts.length > 0) cat    = parts[0].trim();
                if (parts.length > 1) freq   = parts[1].trim();
                if (parts.length > 2) remind = parts[2].trim();
                notes = raw.substring(endBracket + 1).trim();
              }
            } else {
              notes = raw;
            }
            String icon = "&#127919;";
            if ("health".equals(cat))  icon = "&#129367;";
            if ("fitness".equals(cat)) icon = "&#128170;";
            if ("mind".equals(cat))    icon = "&#129504;";
            if ("work".equals(cat))    icon = "&#128188;";
          %>
          <div class="habit-card <%= h.isCompletedToday() ? "done" : "" %>"
               data-cat="<%= cat %>"
               data-status="<%= h.isCompletedToday() ? "done" : "pending" %>">

            <div class="h-icon"><%= icon %></div>

            <div class="h-info">
              <div class="h-name <%= h.isCompletedToday() ? "struck" : "" %>">
                <%= h.getName() %>
              </div>
              <div class="h-meta">
                <span class="badge b-<%= cat %>"><%= cat %></span>
                <span class="freq-tag"><%= freq %></span>
                <% if (!remind.isEmpty()) { %>
                  <span class="remind-tag">&#128276; <%= remind %></span>
                <% } %>
              </div>
              <% if (!notes.isEmpty()) { %>
              <div style="font-size:12px;color:var(--muted);margin-top:4px">
                <%= notes.length() > 60 ? notes.substring(0, 60) + "..." : notes %>
              </div>
              <% } %>
            </div>

            <div class="h-actions">
              <% if (!h.isCompletedToday()) { %>
              <form method="post"
                    action="<%= request.getContextPath() %>/habits">
                <input type="hidden" name="action" value="complete">
                <input type="hidden" name="habitId" value="<%= h.getId() %>">
                <button type="submit" class="chk"
                        title="Mark complete">&#10003;</button>
              </form>
              <% } else { %>
              <button class="chk checked" disabled>&#10003;</button>
              <% } %>

              <form method="post"
                    action="<%= request.getContextPath() %>/habits"
                    onsubmit="return confirm('Delete this habit permanently?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="habitId" value="<%= h.getId() %>">
                <button type="submit"
                        class="btn btn-sm btn-danger">Del</button>
              </form>
            </div>
          </div>
          <% } %>
        </div>
        <% } %>
      </div>

      <!-- Right Panel -->
      <div class="col">

        <!-- Progress Ring -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">Today's Score</span>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;
                        align-items:center;padding:8px 0">
              <canvas id="habitRing" width="140" height="140"></canvas>
              <div style="font-family:'Syne',sans-serif;font-size:22px;
                          font-weight:800;color:#fff;margin-top:10px">
                <%= pct %>%
              </div>
              <div style="font-size:12px;color:var(--muted)">
                <%= completed %> of <%= total %> done
              </div>
            </div>
            <div class="progress-bar-wrap" style="margin-top:14px">
              <div class="progress-track">
                <div class="progress-fill"
                     style="width:<%= pct %>%"></div>
              </div>
            </div>

            <!-- Mini XP + Rank -->
            <div style="display:grid;grid-template-columns:1fr 1fr;
                        gap:10px;margin-top:14px">
              <div style="text-align:center;padding:12px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div style="font-size:18px;margin-bottom:4px">&#11088;</div>
                <div style="font-family:'Syne',sans-serif;font-size:18px;
                            font-weight:800;color:#fff">
                  <%= completed * 10 %>
                </div>
                <div style="font-size:11px;color:var(--muted)">XP Today</div>
              </div>
              <div style="text-align:center;padding:12px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div style="font-size:18px;margin-bottom:4px">&#127942;</div>
                <div style="font-family:'Syne',sans-serif;font-size:18px;
                            font-weight:800;color:#fff">
                  <%= (completed >= total && total > 0) ? "S" :
                      pct >= 70 ? "A" : pct >= 40 ? "B" : "C" %>
                </div>
                <div style="font-size:11px;color:var(--muted)">Rank</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Upcoming Reminders -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">Reminders</span>
            <a href="<%= request.getContextPath() %>/reminders"
               class="btn btn-ghost btn-sm">Manage</a>
          </div>
          <div class="card-body">
            <% if (habits.isEmpty()) { %>
            <p style="color:var(--muted);font-size:13px;text-align:center;
                      padding:16px 0">No habits to remind yet</p>
            <% } else { %>
            <div style="display:flex;flex-direction:column;gap:8px">
              <%
              int rc = 0;
              for (Habit rh : habits) {
                if (rc++ >= 5) break;
                String raw2 = rh.getDescription() != null
                              ? rh.getDescription() : "";
                String remind2 = "";
                if (raw2.startsWith("[")) {
                  int end2 = raw2.indexOf("]");
                  if (end2 > 0) {
                    String[] p2 = raw2.substring(1, end2).split("\\|");
                    if (p2.length > 2) remind2 = p2[2].trim();
                  }
                }
              %>
              <div style="display:flex;align-items:center;gap:10px;
                          padding:10px;background:var(--bg3);
                          border-radius:10px;border:1px solid var(--border)">
                <span style="font-size:18px">
                  <%= rh.isCompletedToday() ? "&#9989;" : "&#128276;" %>
                </span>
                <div style="flex:1;min-width:0">
                  <div style="font-size:13px;font-weight:600;
                    color:<%= rh.isCompletedToday()
                              ? "var(--muted)" : "var(--text)" %>">
                    <%= rh.getName() %>
                  </div>
                  <div style="font-size:11px;color:var(--blue)">
                    <%= remind2.isEmpty() ? "No reminder set" : remind2 %>
                  </div>
                </div>
                <% if (!rh.isCompletedToday()) { %>
                <form method="post"
                      action="<%= request.getContextPath() %>/habits">
                  <input type="hidden" name="action" value="complete">
                  <input type="hidden" name="habitId"
                         value="<%= rh.getId() %>">
                  <button type="submit" class="chk"
                          title="Mark done">&#10003;</button>
                </form>
                <% } else { %>
                <button class="chk checked" disabled>&#10003;</button>
                <% } %>
              </div>
              <% } %>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Strict Mode -->
        <div class="strict-banner">
          <div class="sb-icon">&#128274;</div>
          <div class="sb-info">
            <div class="sb-title">Strict Mode</div>
            <div class="sb-desc">
              Miss a reminder = habit marked failed. No grace period.
            </div>
          </div>
          <label class="toggle">
            <input type="checkbox" id="strictToggle" checked
                   onchange="toggleStrict(this)">
            <span class="toggle-slider"></span>
          </label>
        </div>

      </div>
    </div>
  </main>
</div>

<div class="toast-wrap" id="toastWrap"></div>
<script src="<%= request.getContextPath() %>/js/script.js"></script>
<script>
// Canvas progress ring
(function() {
  var canvas = document.getElementById('habitRing');
  if (!canvas || !canvas.getContext) return;
  var ctx = canvas.getContext('2d');
  var pct = <%= pct %>;
  var cx = 70, cy = 70, r = 54, lw = 12;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, 2 * Math.PI);
  ctx.strokeStyle = 'rgba(255,255,255,0.05)';
  ctx.lineWidth = lw;
  ctx.stroke();
  if (pct > 0) {
    var grad = ctx.createLinearGradient(0, 0, 140, 140);
    grad.addColorStop(0, '#6366f1');
    grad.addColorStop(1, '#22d3a5');
    ctx.beginPath();
    ctx.arc(cx, cy, r, -Math.PI / 2,
            -Math.PI / 2 + (2 * Math.PI * pct / 100));
    ctx.strokeStyle = grad;
    ctx.lineWidth = lw;
    ctx.lineCap = 'round';
    ctx.stroke();
  }
})();

// Toggle add form
function toggleAddForm() {
  var f = document.getElementById('addForm');
  f.style.display = (f.style.display === 'none') ? 'block' : 'none';
  if (f.style.display === 'block')
    f.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// Filter tabs
document.querySelectorAll('.filter-btn').forEach(function(btn) {
  btn.addEventListener('click', function() {
    document.querySelectorAll('.filter-btn').forEach(function(b) {
      b.classList.remove('btn-primary');
      b.classList.add('btn-ghost');
    });
    btn.classList.add('btn-primary');
    btn.classList.remove('btn-ghost');
    var f = btn.dataset.filter;
    document.querySelectorAll('.habit-card').forEach(function(card) {
      var show = f === 'all'
        || (f === 'done'    && card.dataset.status === 'done')
        || (f === 'pending' && card.dataset.status === 'pending')
        || card.dataset.cat === f;
      card.style.display = show ? 'flex' : 'none';
    });
  });
});

// Toasts from URL params
var p = new URLSearchParams(window.location.search);
if (p.get('msg') === 'added')   showToast('Habit added successfully!', 'ok');
if (p.get('msg') === 'deleted') showToast('Habit deleted.', 'err');
if (p.get('msg') === 'done')    showToast('Habit completed! Keep going!', 'ok');
if (p.get('msg') === 'empty')   showToast('Please enter a habit name.', 'err');
if (p.get('msg') === 'error')   showToast('Something went wrong. Try again.', 'err');
</script>
</body>
</html>