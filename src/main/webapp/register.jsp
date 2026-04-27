<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register - HabitFlow</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">

    <div class="auth-logo">
      <div class="icon">&#127807;</div>
      <div class="name">HabitFlow</div>
    </div>

    <h2>Create account &#127807;</h2>
    <p class="sub">Start building better habits today</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-err">&#9888; <%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/register">
      <div class="form-group">
        <label class="form-label">Username</label>
        <input type="text" name="username" class="input" placeholder="Your name" required>
      </div>
      <div class="form-group">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="input" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="input" placeholder="Choose a strong password" required>
        <div id="pwdStrength" style="margin-top:6px;font-size:12px"></div>
      </div>
      <button type="submit" class="btn btn-primary btn-full">Create Account</button>
    </form>

    <div class="auth-footer">
      Already have one? <a href="<%= request.getContextPath() %>/login">Sign in</a>
    </div>

  </div>
</div>
<script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>