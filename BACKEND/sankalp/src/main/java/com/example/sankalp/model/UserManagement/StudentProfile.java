package com.example.sankalp.model.UserManagement;

public class StudentProfile {

    private Users user;

    private String targetExam;

    private int currentXp;

    private int currentLevel;

    private int currentStreak;

    public StudentProfile(Users user, String targetExam, int currentXp, int currentLevel, int currentStreak) {
        this.user = user;
        this.targetExam = targetExam;
        this.currentXp = currentXp;
        this.currentLevel = currentLevel;
        this.currentStreak = currentStreak;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public String getTargetExam() {
        return targetExam;
    }

    public void setTargetExam(String targetExam) {
        this.targetExam = targetExam;
    }

    public int getCurrentXp() {
        return currentXp;
    }

    public void setCurrentXp(int currentXp) {
        this.currentXp = currentXp;
    }

    public int getCurrentLevel() {
        return currentLevel;
    }

    public void setCurrentLevel(int currentLevel) {
        this.currentLevel = currentLevel;
    }

    public int getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(int currentStreak) {
        this.currentStreak = currentStreak;
    }
}
