<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.habit.model.*, java.util.*" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

  @SuppressWarnings("unchecked")
  List<Habit> habits = (List<Habit>) request.getAttribute("habits");
  if (habits == null) habits = new ArrayList<Habit>();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reminders - HabitFlow</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="layout">

  <%@ include file="sidebar.jsp" %>

  <main class="main">

    <!-- Page Header -->
    <div class="page-head">
      <div class="page-head-left">
        <h1>&#128276; Reminders</h1>
        <p>Manage notification times and reminder types for your habits</p>
      </div>
    </div>

    <div class="grid-2">

      <!-- LEFT COLUMN -->
      <div class="col">

        <!-- Habit Reminder Schedule -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128197; Habit Reminder Schedule</span>
          </div>
          <div class="card-body">
            <% if (habits.isEmpty()) { %>
            <div class="empty">
              <div class="empty-icon">&#128276;</div>
              <h3>No habits yet</h3>
              <p>Add habits first to see reminders here</p>
              <a href="<%= request.getContextPath() %>/habits"
                 class="btn btn-primary"
                 style="margin-top:14px;display:inline-flex">
                Add Habits
              </a>
            </div>
            <% } else { %>
            <div style="display:flex;flex-direction:column;gap:10px">
              <%
              for (Habit h : habits) {
                String raw = h.getDescription() != null ? h.getDescription() : "";
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
              <div style="display:flex;align-items:center;gap:12px;
                          padding:14px;background:var(--bg3);
                          border-radius:12px;border:1px solid var(--border);
                          transition:border-color 0.2s"
                   onmouseover="this.style.borderColor='rgba(99,102,241,0.3)'"
                   onmouseout="this.style.borderColor='rgba(255,255,255,0.06)'">
                <div style="width:40px;height:40px;border-radius:10px;
                            background:var(--surface);display:flex;
                            align-items:center;justify-content:center;
                            font-size:20px;border:1px solid var(--border);
                            flex-shrink:0">
                  <%= icon %>
                </div>
                <div style="flex:1;min-width:0">
                  <div style="font-size:13px;font-weight:600;
                              color:var(--text)"><%= h.getName() %></div>
                  <div style="display:flex;gap:8px;margin-top:4px;
                              flex-wrap:wrap;align-items:center">
                    <span class="badge b-<%= cat %>"><%= cat %></span>
                    <span style="font-size:11px;color:var(--muted)">
                      <%= freq %>
                    </span>
                    <% if (!remind.isEmpty()) { %>
                    <span style="font-size:11px;color:var(--blue);
                                 display:inline-flex;align-items:center;
                                 gap:3px">
                      &#128276; <%= remind %>
                    </span>
                    <% } else { %>
                    <span style="font-size:11px;color:var(--muted)">
                      No reminder set
                    </span>
                    <% } %>
                  </div>
                </div>
                <div style="display:flex;align-items:center;gap:8px">
                  <span style="font-size:20px">
                    <%= h.isCompletedToday() ? "&#9989;" : "&#11093;" %>
                  </span>
                  <!-- Quick complete button -->
                  <% if (!h.isCompletedToday()) { %>
                  <form method="post"
                        action="<%= request.getContextPath() %>/habits">
                    <input type="hidden" name="action" value="complete">
                    <input type="hidden" name="habitId" value="<%= h.getId() %>">
                    <button type="submit" class="btn btn-sm btn-success"
                            title="Mark complete">Done</button>
                  </form>
                  <% } else { %>
                  <span class="btn btn-sm btn-ghost"
                        style="cursor:default;opacity:0.5">Done</span>
                  <% } %>
                </div>
              </div>
              <% } %>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Strict Mode Settings -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128274; Strict Mode Settings</span>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;gap:12px">

              <div style="display:flex;align-items:center;
                          justify-content:space-between;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div>
                  <div style="font-size:13px;font-weight:600;
                              color:var(--text)">Miss = Fail</div>
                  <div style="font-size:12px;color:var(--muted);margin-top:3px">
                    Incomplete habits auto-marked as failed at midnight
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast(this.checked
                      ? 'Miss = Fail ON' : 'Miss = Fail OFF',
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;
                          justify-content:space-between;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div>
                  <div style="font-size:13px;font-weight:600;
                              color:var(--text)">Break Streak on Miss</div>
                  <div style="font-size:12px;color:var(--muted);margin-top:3px">
                    Missing a day resets your streak to 0
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast(this.checked
                      ? 'Streak break ON' : 'Streak break OFF',
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;
                          justify-content:space-between;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div>
                  <div style="font-size:13px;font-weight:600;
                              color:var(--text)">No Backdating</div>
                  <div style="font-size:12px;color:var(--muted);margin-top:3px">
                    Cannot mark yesterday's habits as complete
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox"
                    onchange="showToast(this.checked
                      ? 'No backdating ON' : 'No backdating OFF',
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;
                          justify-content:space-between;padding:14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <div>
                  <div style="font-size:13px;font-weight:600;
                              color:var(--text)">30 Min Warning</div>
                  <div style="font-size:12px;color:var(--muted);margin-top:3px">
                    Get alerted 30 minutes before habit deadline
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast(this.checked
                      ? '30 min warning ON' : '30 min warning OFF',
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

            </div>
          </div>
        </div>

      </div>

      <!-- RIGHT COLUMN -->
      <div class="col">

        <!-- Reminder Types -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#9881; Reminder Types</span>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;gap:10px">

              <div style="display:flex;align-items:center;gap:12px;
                          padding:14px;background:var(--bg3);
                          border-radius:12px;border:1px solid var(--border)">
                <div style="width:40px;height:40px;border-radius:10px;
                            background:rgba(245,158,11,0.12);display:flex;
                            align-items:center;justify-content:center;
                            font-size:20px;flex-shrink:0">
                  &#9728;
                </div>
                <div style="flex:1">
                  <div style="font-size:13px;font-weight:600;color:var(--text)">
                    Morning Boost
                  </div>
                  <div style="font-size:12px;color:var(--muted);margin-top:2px">
                    Fires at 7:00 AM — starts your day right
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast('Morning reminder '
                      + (this.checked ? 'ON' : 'OFF'),
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;gap:12px;
                          padding:14px;background:var(--bg3);
                          border-radius:12px;border:1px solid var(--border)">
                <div style="width:40px;height:40px;border-radius:10px;
                            background:rgba(99,102,241,0.12);display:flex;
                            align-items:center;justify-content:center;
                            font-size:20px;flex-shrink:0">
                  &#127769;
                </div>
                <div style="flex:1">
                  <div style="font-size:13px;font-weight:600;color:var(--text)">
                    Evening Review
                  </div>
                  <div style="font-size:12px;color:var(--muted);margin-top:2px">
                    Fires at 9:00 PM — review incomplete habits
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast('Evening reminder '
                      + (this.checked ? 'ON' : 'OFF'),
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;gap:12px;
                          padding:14px;background:var(--bg3);
                          border-radius:12px;border:1px solid var(--border)">
                <div style="width:40px;height:40px;border-radius:10px;
                            background:rgba(34,211,165,0.12);display:flex;
                            align-items:center;justify-content:center;
                            font-size:20px;flex-shrink:0">
                  &#127919;
                </div>
                <div style="flex:1">
                  <div style="font-size:13px;font-weight:600;color:var(--text)">
                    Per-Habit Reminders
                  </div>
                  <div style="font-size:12px;color:var(--muted);margin-top:2px">
                    Custom time set per habit when creating it
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox" checked
                    onchange="showToast('Per-habit reminders '
                      + (this.checked ? 'ON' : 'OFF'),
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

              <div style="display:flex;align-items:center;gap:12px;
                          padding:14px;background:var(--bg3);
                          border-radius:12px;border:1px solid var(--border)">
                <div style="width:40px;height:40px;border-radius:10px;
                            background:rgba(244,63,94,0.12);display:flex;
                            align-items:center;justify-content:center;
                            font-size:20px;flex-shrink:0">
                  &#128274;
                </div>
                <div style="flex:1">
                  <div style="font-size:13px;font-weight:600;color:var(--text)">
                    Strict Deadline Alert
                  </div>
                  <div style="font-size:12px;color:var(--muted);margin-top:2px">
                    30 min warning before habit deadline
                  </div>
                </div>
                <label class="toggle">
                  <input type="checkbox"
                    onchange="showToast('Strict alerts '
                      + (this.checked ? 'ON' : 'OFF'),
                      this.checked ? 'ok' : 'inf')">
                  <span class="toggle-slider"></span>
                </label>
              </div>

            </div>
          </div>
        </div>

        <!-- Browser Notifications -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128421; Browser Notifications</span>
          </div>
          <div class="card-body">
            <p style="font-size:13px;color:var(--text2);margin-bottom:16px;
                      line-height:1.7">
              Enable browser notifications to get reminded even when
              this tab is in the background.
            </p>
            <button class="btn btn-primary btn-full"
                    onclick="requestNotifPermission()">
              &#128276; Enable Browser Notifications
            </button>
            <div id="notifStatus"
                 style="margin-top:12px;font-size:12px;
                        color:var(--muted);text-align:center"></div>
          </div>
        </div>

        <!-- Motivational Quote -->
        <div class="card"
             style="background:linear-gradient(135deg,
                    rgba(99,102,241,0.08),rgba(236,72,153,0.06));
                    border-color:rgba(99,102,241,0.2)">
          <div class="card-head">
            <span class="card-title">&#128172; Daily Motivation</span>
          </div>
          <div class="card-body">
            <p id="quoteText"
               style="font-size:14px;color:var(--text);
                      line-height:1.8;font-style:italic;min-height:60px">
            </p>
            <p id="quoteAuthor"
               style="font-size:12px;color:var(--muted);
                      margin-top:10px;text-align:right">
            </p>
            <button class="btn btn-ghost btn-sm"
                    style="margin-top:14px"
                    onclick="nextQuote()">
              Next quote
            </button>
          </div>
        </div>

        <!-- Today Summary -->
        <div class="card">
          <div class="card-head">
            <span class="card-title">&#128200; Today's Summary</span>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;gap:10px">
              <div style="display:flex;justify-content:space-between;
                          align-items:center;padding:10px 14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <span style="font-size:13px;color:var(--text2)">
                  Total habits
                </span>
                <span style="font-family:'Syne',sans-serif;font-size:16px;
                             font-weight:800;color:#fff">
                  <%= habits.size() %>
                </span>
              </div>
              <div style="display:flex;justify-content:space-between;
                          align-items:center;padding:10px 14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <span style="font-size:13px;color:var(--text2)">
                  Completed today
                </span>
                <%
                int doneCount = 0;
                for (Habit h : habits) if (h.isCompletedToday()) doneCount++;
                %>
                <span style="font-family:'Syne',sans-serif;font-size:16px;
                             font-weight:800;color:var(--green)">
                  <%= doneCount %>
                </span>
              </div>
              <div style="display:flex;justify-content:space-between;
                          align-items:center;padding:10px 14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <span style="font-size:13px;color:var(--text2)">
                  Remaining
                </span>
                <span style="font-family:'Syne',sans-serif;font-size:16px;
                             font-weight:800;color:var(--amber)">
                  <%= habits.size() - doneCount %>
                </span>
              </div>
              <div style="display:flex;justify-content:space-between;
                          align-items:center;padding:10px 14px;
                          background:var(--bg3);border-radius:10px;
                          border:1px solid var(--border)">
                <span style="font-size:13px;color:var(--text2)">
                  With reminders set
                </span>
                <%
                int withRemind = 0;
                for (Habit h : habits) {
                  String rd = h.getDescription() != null
                              ? h.getDescription() : "";
                  if (rd.startsWith("[")) {
                    int eb = rd.indexOf("]");
                    if (eb > 0) {
                      String[] pp = rd.substring(1, eb).split("\\|");
                      if (pp.length > 2 && !pp[2].trim().isEmpty())
                        withRemind++;
                    }
                  }
                }
                %>
                <span style="font-family:'Syne',sans-serif;font-size:16px;
                             font-weight:800;color:var(--accent2)">
                  <%= withRemind %>
                </span>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </main>
</div>

<div class="toast-wrap" id="toastWrap"></div>
<script src="<%= request.getContextPath() %>/js/script.js"></script>
<script>
// Browser notification permission
function requestNotifPermission() {
  var status = document.getElementById('notifStatus');
  if (!('Notification' in window)) {
    status.textContent = 'Browser does not support notifications';
    status.style.color = 'var(--red)';
    return;
  }
  Notification.requestPermission().then(function(perm) {
    if (perm === 'granted') {
      status.textContent = 'Notifications enabled!';
      status.style.color = 'var(--green)';
      showToast('Browser notifications enabled!', 'ok');
      new Notification('HabitFlow', {
        body: 'You will now receive habit reminders!'
      });
    } else {
      status.textContent = 'Permission denied. Enable in browser settings.';
      status.style.color = 'var(--red)';
      showToast('Notification permission denied', 'err');
    }
  });
}

// Check current notification permission on load
(function() {
  var status = document.getElementById('notifStatus');
  if (!('Notification' in window)) return;
  if (Notification.permission === 'granted') {
    status.textContent = 'Notifications are currently enabled';
    status.style.color = 'var(--green)';
  } else if (Notification.permission === 'denied') {
    status.textContent = 'Notifications are blocked in browser settings';
    status.style.color = 'var(--red)';
  }
})();
</script>
</body>
</html>