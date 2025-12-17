/*
module com.itbs
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires jakarta.persistence;
    requires javafx.base;
    requires java.net.http;
    requires jakarta.validation;
    requires jakarta.mail;
    requires org.json;
    requires com.fasterxml.jackson.databind;
    requires com.fasterxml.jackson.core;
    // Use the jar name as automatic module name
    requires org.mindrot.jbcrypt;
    requires org.kordamp.ikonli.javafx;

    // Open all modules to allow reflection access
    opens com.itbso javafx.fxml;
    opens com.itbsontrollers to javafx.fxml;
    opens com.itbsodels to jakarta.persistence, javafx.base;
    opens com.itbstils;
    opens com.itbservices;

    exports com.itbs    exports com.itbsodels;
    exports com.itbsontrollers;
    exports com.itbservices;
    exports com.itbstils;
}

 */