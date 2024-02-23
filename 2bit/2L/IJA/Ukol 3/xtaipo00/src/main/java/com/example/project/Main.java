package com.example.project;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.io.IOException;

public class Main extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage stage) throws IOException {

        Parent root = FXMLLoader.load(getClass().getResource("hello-view.fxml"));
        stage.setScene(new Scene(root));
        stage.setTitle("Diagrams");
        Image icon = new Image("logo.png");
        stage.getIcons().add(icon);
        stage.setResizable(false);

        stage.show();
    }
}