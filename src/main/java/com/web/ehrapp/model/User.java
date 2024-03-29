package com.web.ehrapp.model;

import java.security.Principal;
import java.util.Objects;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class User implements Principal {

    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber){
        this.phoneNumber = phoneNumber;
    }

    private String phoneNumber;
    private int id;
    private String name;
    private String role;
    private String email;
    private String password;

    private boolean disabled;

    public UserDAO getDao() {
        return dao;
    }

    private UserDAO dao;


    public User(int id, String name, String role, String email, String password, String phoneNumber, boolean disabled, UserDAO dao) {
        this.id = id;
        this.name = name;
        this.role = role;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.dao = dao;
        this.disabled = disabled;
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
    private String[] getUserRoles(){
        return this.getRole().split(", ");
    }

    public boolean isUserInRole(String role){
        for (String roleIteration: getUserRoles()) {
            // if admin
            if(roleIteration.equalsIgnoreCase("Admin")){
                //return true;
            }

            if(roleIteration.equalsIgnoreCase(role)){
                System.out.println("role " +  role + " true");
                return true;
            }
        }
        // Returnere false hvis man ikke er admin.... Så Admin har adgang til alt.
        System.out.println("role " +  role + " false");
        return false;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isDisabled() {
        return disabled;
    }

    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isPhoneNumberRegistered(){
        return phoneNumber != null || !Objects.equals(phoneNumber, "");
    }
}
