<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.habit.model.*, java.util.*" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

  @SuppressWarnings("unchecked")
  List<Habit> habits = (List<Habit>) request.getAttribute("habits");
  if (habits == null) habits = new ArrayList<Habit>();

  int total     = habits.size();
  int completed = 0;
  for (Habit h : habits) if (h.isCompletedToday()) completed++;
  int pending = total - completed;
  int pct = total > 0 ? (completed * 100 / total) : 0;

  int hour = java.time.LocalTime.now().getHour();
  String greeting  = hour < 12 ? "Good morning" :
                     hour < 17 ? "Good afternoon" : "Good evening";
  String greetIcon = hour < 12 ? "&#9728;" :
                     hour < 17 ? "&#9889;" : "&#127769;";
  String dateStr   = new java.text.SimpleDateFormat("EEEE, MMMM d yyyy")
                         .format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard - HabitFlow</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="layout">

  <%@ include file="sidebar.jsp" %>

  <main class="main">

    <!-- Notification Bar -->
    <% if (total > 0 && completed < total) { %>
    <div class="notif-bar" id="notifBar">
      <div class="nb-icon">&#128276;</div>
      <div class="nb-text">
        <div class="nb-title">
          You have <%= pending %> habit<%= pending > 1 ? "s" : "" %> left today!
        </div>
        <div class="nb-sub">
          Stay consistent — your future self will thank you. Keep going!
        </div>
      </div>
      <button class="nb-close"
              onclick="document.getElementById('notifBar').remove()">
        &#10005;
      </button>
    </div>
    <% } %>

    <% if (total > 0 && completed == total) { %>
    <div class="notif-bar" id="notifBar"
         style="background:linear-gradient(135deg,
                rgba(34,211,165,0.15),rgba(99,102,241,0.1));
                border-color:rgba(34,211,165,0.25)">
      <div class="nb-icon">&#127881;</div>
      <div class="nb-text">
        <div class="nb-title">Perfect day! All habits completed!</div>
        <div class="nb-sub">
          You are on fire. Come back tomorrow to keep your streak alive!
        </div>
      </div>
      <button class="nb-close"
              onclick="document.getElementById('notifBar').remove()">
        &#10005;
      </button>
    </div>
    <% } %>

    <!-- Page Header -->
    <div class="page-head">
      <div class="page-head-left">
        <h1><%= greetIcon %> <%= greeting %>, <%= user.getUsername() %>!</h1>
        <p><%= dateStr %></p>
      </div>
      <div class="page-head-right">
        <a href="<%= request.getContextPath() %>/habits"
           class="btn btn-primary">+ Add Habit</a>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat s1">
        <div class="stat-glow"></div>
        <div class="stat-top">
          <div class="stat-icon-wrap">&#128203;</div>
          <span class="stat-trend trend-neu">Total</span>
        </div>
        <div class="stat-val" data-target="<%= total %>">0</div>
        <div class="stat-lbl">Habits tracked</div>
      </div>
      <div class="stat s2">
        <div class="stat-glow"></div>
        <div class="stat-top">
          <div class="stat-icon-wrap">&#9989;</div>
          <span class="stat-trend trend-up">Today</span>
        </div>
        <div class="stat-val" data-target="<%= completed %>">0</div>
        <div class="stat-lbl">Completed today</div>
      </div>
      <div class="stat s3">
        <div class="stat-glow"></div>
        <div class="stat-top">
          <div class="stat-icon-wrap">&#9203;</div>
          <span class="stat-trend trend-<%= pending > 0 ? "down" : "up" %>">
            <%= pending > 0 ? "Pending" : "Done!" %>
          </span>
        </div>
        <div class="stat-val" data-target="<%= pending %>">0</div>
        <div class="stat-lbl">Remaining today</div>
      </div>
      <div class="stat s4">
        <div class="stat-glow"></div>
        <div class="stat-top">
          <div class="stat-icon-wrap">&#127919;</div>
          <span class="stat-trend
            trend-<%= pct >= 70 ? "up" : pct >= 40 ? "neu" : "down" %>">
            <%= pct %>%
          </span>
        </div>
        <div class="stat-val" data-target="<%= pct %>"
             data-suffix="%">0%</div>
        <div class="stat-lbl">Completion rate</div>
      </div>
    </div>

    <!-- Main Grid -->
    <div class="grid-2-1">

      <!-- Left Column -->
      <div class="col">

        <!-- Progress Card -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128202; Today's Progress</span>
            <span style="font-size:13px;color:var(--text2)">
              <%= completed %>/<%= total %> habits
            </span>
          </div>
          <div class="card-body">
            <div class="progress-bar-wrap">
              <div class="progress-label">
                <span>Daily completion</span>
                <span style="color:var(--accent2);font-weight:600">
                  <%= pct %>%
                </span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" id="progressFill"
                     style="width:0%"></div>
              </div>
            </div>
            <div style="display:grid;grid-template-columns:repeat(3,1fr);
                        gap:12px;margin-top:14px">
              <div style="text-align:center;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div style="font-size:22px;margin-bottom:6px">&#128293;</div>
                <div style="font-family:'Syne',sans-serif;font-size:20px;
                            font-weight:800;color:#fff"
                     id="streakCount">0</div>
                <div style="font-size:11px;color:var(--muted)">
                  Day streak
                </div>
              </div>
              <div style="text-align:center;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div style="font-size:22px;margin-bottom:6px">&#11088;</div>
                <div style="font-family:'Syne',sans-serif;font-size:20px;
                            font-weight:800;color:#fff">
                  <%= completed * 10 %>
                </div>
                <div style="font-size:11px;color:var(--muted)">XP earned</div>
              </div>
              <div style="text-align:center;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div style="font-size:22px;margin-bottom:6px">&#127942;</div>
                <div style="font-family:'Syne',sans-serif;font-size:20px;
                            font-weight:800;color:#fff">
                  <%= (completed >= total && total > 0) ? "S" :
                      pct >= 70 ? "A" : pct >= 40 ? "B" : "C" %>
                </div>
                <div style="font-size:11px;color:var(--muted)">
                  Today rank
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Today's Habits Quick View -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#9889; Today's Habits</span>
            <a href="<%= request.getContextPath() %>/habits"
               class="btn btn-ghost btn-sm">View All</a>
          </div>
          <div class="card-body">
            <% if (habits.isEmpty()) { %>
            <div class="empty">
              <div class="empty-icon">&#127807;</div>
              <h3>No habits yet</h3>
              <p>Start building your routine</p>
              <a href="<%= request.getContextPath() %>/habits"
                 class="btn btn-primary"
                 style="margin-top:14px;display:inline-flex">
                Add First Habit
              </a>
            </div>
            <% } else { %>
            <div class="habit-grid">
              <%
              int shown = 0;
              for (Habit h : habits) {
                if (shown++ >= 5) break;
                String raw = h.getDescription() != null
                             ? h.getDescription() : "";
                String cat = "other", freq = "daily", remind = "";
                if (raw.startsWith("[")) {
                  int endB = raw.indexOf("]");
                  if (endB > 0) {
                    String[] parts = raw.substring(1, endB).split("\\|");
                    if (parts.length > 0) cat    = parts[0].trim();
                    if (parts.length > 1) freq   = parts[1].trim();
                    if (parts.length > 2) remind = parts[2].trim();
                  }
                }
                String icon = "&#127919;";
                if ("health".equals(cat))  icon = "&#129367;";
                if ("fitness".equals(cat)) icon = "&#128170;";
                if ("mind".equals(cat))    icon = "&#129504;";
                if ("work".equals(cat))    icon = "&#128188;";
              %>
              <div class="habit-card
                   <%= h.isCompletedToday() ? "done" : "" %>">
                <div class="h-icon"><%= icon %></div>
                <div class="h-info">
                  <div class="h-name
                       <%= h.isCompletedToday() ? "struck" : "" %>">
                    <%= h.getName() %>
                  </div>
                  <div class="h-meta">
                    <span class="badge b-<%= cat %>"><%= cat %></span>
                    <span class="freq-tag"><%= freq %></span>
                    <% if (!remind.isEmpty()) { %>
                    <span class="remind-tag">
                      &#128276; <%= remind %>
                    </span>
                    <% } %>
                  </div>
                </div>
                <% if (h.isCompletedToday()) { %>
                <span style="font-size:20px">&#9989;</span>
                <% } else { %>
                <form method="post"
                      action="<%= request.getContextPath() %>/habits">
                  <input type="hidden" name="action" value="complete">
                  <input type="hidden" name="habitId"
                         value="<%= h.getId() %>">
                  <button type="submit" class="chk"
                          title="Mark done">&#10003;</button>
                </form>
                <% } %>
              </div>
              <% } %>
              <% if (total > 5) { %>
              <a href="<%= request.getContextPath() %>/habits"
                 style="display:block;text-align:center;padding:12px;
                        color:var(--accent2);font-size:13px;
                        text-decoration:none;background:var(--bg3);
                        border-radius:10px;border:1px solid var(--border)">
                + <%= total - 5 %> more habits
              </a>
              <% } %>
            </div>
            <% } %>
          </div>
        </div>

      </div>

      <!-- Right Column -->
      <div class="col">

        <!-- Completion Ring via Canvas -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#127919; Completion Ring</span>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;
                        align-items:center;padding:10px 0 4px">
              <canvas id="dashRing" width="160" height="160"></canvas>
              <div style="font-family:'Syne',sans-serif;font-size:24px;
                          font-weight:800;color:#fff;margin-top:10px">
                <%= pct %>%
              </div>
              <div style="font-size:12px;color:var(--muted)">
                <%= completed %> of <%= total %> completed
              </div>
            </div>
          </div>
        </div>

        <!-- 28-day Activity Calendar -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128197; Activity — Last 28 Days</span>
          </div>
          <div class="card-body">
            <div class="cal-header">
              <% String[] dayNames = {"S","M","T","W","T","F","S"};
                 for (String dn : dayNames) { %>
              <div class="cal-day-name"><%= dn %></div>
              <% } %>
            </div>
            <div class="cal-grid" id="calGrid"></div>
            <div style="display:flex;gap:8px;margin-top:12px;
                        align-items:center;flex-wrap:wrap">
              <span style="font-size:11px;color:var(--muted)">Less</span>
              <div style="width:12px;height:12px;border-radius:3px;
                background:var(--bg3);border:1px solid var(--border)"></div>
              <div style="width:12px;height:12px;border-radius:3px;
                background:rgba(99,102,241,0.2)"></div>
              <div style="width:12px;height:12px;border-radius:3px;
                background:rgba(99,102,241,0.5)"></div>
              <div style="width:12px;height:12px;border-radius:3px;
                background:#6366f1"></div>
              <span style="font-size:11px;color:var(--muted)">More</span>
            </div>
          </div>
        </div>

        <!-- Strict Mode Banner -->
        <div class="strict-banner">
          <div class="sb-icon">&#128274;</div>
          <div class="sb-info">
            <div class="sb-title">Strict Mode Active</div>
            <div class="sb-desc">
              Habits must be done by reminder time or they count as missed.
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
// Animate progress bar
setTimeout(function() {
  var pf = document.getElementById('progressFill');
  if (pf) pf.style.width = '<%= pct %>%';
}, 200);

// Streak counter animation
animateCount(document.getElementById('streakCount'),
             0, <%= Math.max(completed * 3, 1) %>, 900);

// Animate stat counters
document.querySelectorAll('.stat-val[data-target]').forEach(function(el) {
  var target = parseInt(el.dataset.target);
  animateCount(el, 0, target, 900);
});

// Canvas ring for dashboard
(function() {
  var canvas = document.getElementById('dashRing');
  if (!canvas || !canvas.getContext) return;
  var ctx = canvas.getContext('2d');
  var pct = <%= pct %>;
  var cx = 80, cy = 80, r = 64, lw = 14;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, 2 * Math.PI);
  ctx.strokeStyle = 'rgba(255,255,255,0.04)';
  ctx.lineWidth = lw;
  ctx.stroke();
  if (pct > 0) {
    var grad = ctx.createLinearGradient(0, 0, 160, 160);
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
</script>
</body>
</html>