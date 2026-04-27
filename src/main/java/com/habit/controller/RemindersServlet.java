package com.habit.controller;

import com.habit.dao.HabitDAO;
import com.habit.model.Habit;
import com.habit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reminders")
public class RemindersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final HabitDAO habitDAO = new HabitDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        List<Habit> habits = habitDAO.getHabitsByUser(user.getId());
        req.setAttribute("habits", habits);
        req.getRequestDispatcher("/reminders.jsp").forward(req, resp);
    }
}