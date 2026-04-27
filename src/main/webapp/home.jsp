<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.habit.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Home - Habit Tracker</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
  <h2>Welcome, <%= user.getUsername() %>!</h2>
  <a href="<%= request.getContextPath() %>/dashboard">Go to Dashboard</a>
  <a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>
</body>
</html>