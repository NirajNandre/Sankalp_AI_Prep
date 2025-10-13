package com.example.sankalp.model.UserManagement;

public class Users {

    private int user_id;

    private String email;

    private String fullName;

    private String role;

    public Users(int user_id, String email, String fullName, String role) {
        this.user_id = user_id;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}