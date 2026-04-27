<%@ page import="com.habit.model.User" %>
<%
  User sideUser = (User) session.getAttribute("user");
  String uri = request.getRequestURI();
  boolean onDash    = uri.contains("/dashboard");
  boolean onHabits  = uri.contains("/habits");
  boolean onRemind  = uri.contains("/reminders");
%>
<aside class="sidebar">
  <div class="brand">
    <div class="brand-icon">&#127807;</div>
    <div class="brand-name">HabitFlow</div>
  </div>

  <div class="nav-section">
    <div class="nav-title">Overview</div>
    <a class="nav-link <%= onDash ? "active" : "" %>"
       href="<%= request.getContextPath() %>/dashboard">
      <span class="icon">&#128202;</span>
      <span class="label">Dashboard</span>
    </a>
  </div>

  <div class="nav-section">
    <div class="nav-title">My Habits</div>
    <a class="nav-link <%= onHabits ? "active" : "" %>"
       href="<%= request.getContextPath() %>/habits">
      <span class="icon">&#9989;</span>
      <span class="label">All Habits</span>
    </a>
    <a class="nav-link <%= onRemind ? "active" : "" %>"
       href="<%= request.getContextPath() %>/reminders">
      <span class="icon">&#128276;</span>
      <span class="label">Reminders</span>
    </a>
  </div>

  <div class="nav-divider"></div>

  <div class="sidebar-bottom">
    <div class="user-card">
      <div class="avatar">
        <%= sideUser != null ? sideUser.getUsername().substring(0,1).toUpperCase() : "?" %>
      </div>
      <div class="user-meta">
        <div class="uname"><%= sideUser != null ? sideUser.getUsername() : "" %></div>
        <div class="uemail"><%= sideUser != null ? sideUser.getEmail() : "" %></div>
      </div>
    </div>
    <a class="logout-btn" href="<%= request.getContextPath() %>/logout">
      Sign Out
    </a>
  </div>
</aside>