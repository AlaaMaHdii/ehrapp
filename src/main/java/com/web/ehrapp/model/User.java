package com.web.ehrapp.model;

import java.security.Principal;
import at.favre.lib.crypto.bcrypt.BCrypt;

public class User implements Principal {

    private int id;
    private String name;
    private String role;
    private String email;
    private String password;

    public UserDAO getDao() {
        return dao;
    }

    private UserDAO dao;

    public User(int id, String name, String role, String email, String password, UserDAO dao) {
        this.id = id;
        this.name = name;
        this.role = role;
        this.email = email;
        this.password = password;
        this.dao = dao;
    }

    public boolean checkPassword(String inputPassword){
        return BCrypt.verifyer().verify(inputPassword.toCharArray(), password).verified;
    }
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }
    public String getRole() {
        return role;
    }

    public String getPassword() {
        return password;
    }


    public String getEmail() {
        return email;
    }

    public boolean setName(String name) {
        String originalName = this.name;
        this.name = name;
        try {
            // Send de nye detajler til SQL databasen
            dao.updateUser(this);
        } catch (Exception e){
            // Hvis den fejler, så skifter vi tilbage.
            this.name = originalName;
            return false;
        }
        return true;
    }

    public boolean setRole(String role) {
        String originalRole = this.role;
        this.role = role;
        try {
            // Send de nye detajler til SQL databasen
            dao.updateUser(this);
        } catch (Exception e){
            // Hvis den fejler, så skifter vi tilbage.
            this.role = originalRole;
            return false;
        }
        return true;
    }


    public boolean setEmail(String newEmail) {
        String originalEmail = this.email;
        this.email = newEmail;
        try {
            // Send de nye detajler til SQL databasen
            dao.updateUser(this);
        } catch (Exception e){
            // Hvis den fejler, så skifter vi tilbage.
            this.email = originalEmail;
            return false;
        }
        return true;
    }


    public boolean setPassword(String password) {
        // Gem den originale kodeord
        String originalPassword = this.password;
        // Kryptere den nye kodeord
        this.password = dao.encryptPassword(password);
        try {
            // Send de nye detajler til SQL databasen
            dao.updateUser(this);
        } catch (Exception e){
            // Hvis den fejler, så skifter vi tilbage.
            this.password = originalPassword;
            return false;
        }
        return true;
    }
}
