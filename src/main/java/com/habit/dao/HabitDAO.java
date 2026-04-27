package com.habit.dao;

import com.habit.model.Habit;
import com.habit.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class HabitDAO {

    public boolean addHabit(Habit habit) {
        String sql = "INSERT INTO habits (user_id, name, description, created_at) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, habit.getUserId());
            ps.setString(2, habit.getName());
            ps.setString(3, habit.getDescription() != null ? habit.getDescription() : "");
            ps.setDate(4, Date.valueOf(
                habit.getCreatedAt() != null ? habit.getCreatedAt() : LocalDate.now()
            ));

            int rows = ps.executeUpdate();
            System.out.println("[HabitDAO] addHabit rows=" + rows + " name=" + habit.getName());
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[HabitDAO] addHabit ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Habit> getHabitsByUser(int userId) {
        List<Habit> habits = new ArrayList<Habit>();
        String sql =
            "SELECT h.id, h.user_id, h.name, h.description, h.created_at, " +
            "  CASE WHEN l.habit_id IS NOT NULL THEN 1 ELSE 0 END AS completed_today " +
            "FROM habits h " +
            "LEFT JOIN habit_logs l " +
            "  ON h.id = l.habit_id AND l.log_date = CURDATE() " +
            "WHERE h.user_id = ? " +
            "ORDER BY h.created_at DESC, h.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Habit h = new Habit();
                h.setId(rs.getInt("id"));
                h.setUserId(rs.getInt("user_id"));
                h.setName(rs.getString("name"));
                h.setDescription(rs.getString("description"));
                Date d = rs.getDate("created_at");
                h.setCreatedAt(d != null ? d.toLocalDate() : LocalDate.now());
                h.setCompletedToday(rs.getInt("completed_today") == 1);
                habits.add(h);
            }

            System.out.println("[HabitDAO] getHabitsByUser userId=" + userId +
                               " found=" + habits.size());

        } catch (SQLException e) {
            System.err.println("[HabitDAO] getHabitsByUser ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return habits;
    }

    public boolean deleteHabit(int habitId, int userId) {
        String sql = "DELETE FROM habits WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, habitId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] deleteHabit ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean markComplete(int habitId, int userId) {
        String sql =
            "INSERT IGNORE INTO habit_logs (habit_id, user_id, log_date) " +
            "VALUES (?, ?, CURDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, habitId);
            ps.setInt(2, userId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] markComplete ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}