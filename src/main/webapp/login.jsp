<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login - HabitFlow</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">

    <div class="auth-logo">
      <div class="icon">&#127807;</div>
      <div class="name">HabitFlow</div>
    </div>

    <h2>Welcome back &#128075;</h2>
    <p class="sub">Sign in to continue your streak</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-err">&#9888; <%= request.getAttribute("error") %></div>
    <% } %>
    <% if ("true".equals(request.getParameter("registered"))) { %>
      <div class="alert alert-ok">&#10003; Account created! Sign in below.</div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/login">
      <div class="form-group">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="input" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="input" placeholder="Enter password" required>
      </div>
      <button type="submit" class="btn btn-primary btn-full" style="margin-top:8px">Sign In</button>
    </form>

    <div class="auth-footer">
      No account? <a href="<%= request.getContextPath() %>/register">Create one free</a>
    </div>

    <div style="margin-top:24px;padding-top:20px;border-top:1px solid var(--border)">
      <div style="display:flex;flex-direction:column;gap:10px">
        <div class="auth-feature">&#127919; Set daily habit goals</div>
        <div class="auth-feature">&#128293; Track streaks and momentum</div>
        <div class="auth-feature">&#128202; Visualize your progress</div>
        <div class="auth-feature">&#9989; Complete habits with one click</div>
      </div>
    </div>

  </div>
</div>
<script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>