package com.habit.controller;

import com.habit.dao.HabitDAO;
import com.habit.model.Habit;
import com.habit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/habits")
public class HabitsServlet extends HttpServlet {
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
        req.getRequestDispatcher("/habits.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if (action == null) action = "";

        switch (action) {
            case "add": {
                String name = req.getParameter("name");
                if (name != null && !name.trim().isEmpty()) {
                    String cat    = req.getParameter("category");
                    String freq   = req.getParameter("frequency");
                    String remind = req.getParameter("reminder");
                    String notes  = req.getParameter("description");

                    if (cat    == null) cat    = "other";
                    if (freq   == null) freq   = "daily";
                    if (remind == null) remind = "";
                    if (notes  == null) notes  = "";

                    Habit h = new Habit();
                    h.setUserId(user.getId());
                    h.setName(name.trim());
                    h.setDescription("[" + cat + "|" + freq + "|" + remind + "] " + notes.trim());
                    h.setCreatedAt(java.time.LocalDate.now());

                    boolean ok = habitDAO.addHabit(h);
                    resp.sendRedirect(req.getContextPath() + "/habits?msg=" + (ok ? "added" : "error"));
                } else {
                    resp.sendRedirect(req.getContextPath() + "/habits?msg=empty");
                }
                break;
            }
            case "delete": {
                String idStr = req.getParameter("habitId");
                if (idStr != null) {
                    try {
                        int id = Integer.parseInt(idStr);
                        habitDAO.deleteHabit(id, user.getId());
                    } catch (NumberFormatException ignored) {}
                }
                resp.sendRedirect(req.getContextPath() + "/habits?msg=deleted");
                break;
            }
            case "complete": {
                String idStr = req.getParameter("habitId");
                if (idStr != null) {
                    try {
                        int id = Integer.parseInt(idStr);
                        habitDAO.markComplete(id, user.getId());
                    } catch (NumberFormatException ignored) {}
                }
                resp.sendRedirect(req.getContextPath() + "/habits?msg=done");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/habits");
        }
    }
}