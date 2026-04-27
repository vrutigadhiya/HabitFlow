package com.habit.model;

import java.time.LocalDate;

public class Habit {
    private int id;
    private int userId;
    private String name;
    private String description;
    private LocalDate createdAt;
    private boolean completedToday;

    public Habit() {}

    public Habit(int id, int userId, String name, String description, LocalDate createdAt) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getUserId()                      { return userId; }
    public void setUserId(int userId)           { this.userId = userId; }

    public String getName()                     { return name; }
    public void setName(String name)            { this.name = name; }

    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }

    public LocalDate getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDate date)    { this.createdAt = date; }

    public boolean isCompletedToday()               { return completedToday; }
    public void setCompletedToday(boolean b)         { this.completedToday = b; }
}