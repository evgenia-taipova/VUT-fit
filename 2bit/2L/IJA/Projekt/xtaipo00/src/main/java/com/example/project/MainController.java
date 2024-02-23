/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class works with home and editing windows
 */
package com.example.project;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class MainController{

    // To change windows.
    private Stage stage;
    private Scene scene;
    private Parent root;

    // Loads the page for editing.
    FXMLLoader loader = new FXMLLoader(getClass().getResource("editing_page.fxml"));

    /**
     * Opens a text document and processes it.
     */
    public void OpenFileAction(ActionEvent event) throws IOException {

        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Select file");
        File selectedFile = fileChooser.showOpenDialog(new Stage());
        //If the document is not selected, then do nothing.
        if(selectedFile == null)
            return;

        // Opens the diagram editing window.
        switchToEditing(event);
        // Accesses other functions from the edit window.
        EditingController editingController = loader.getController();

        // Read lines and determines the diagram type.
        Scanner scanner = new Scanner(selectedFile);
        String line = "";
        while (scanner.hasNextLine()) {
            line = scanner.nextLine();
            // Skips blank lines.
            if (!line.equals(""))
                break;
        }

        if (line.equals("@startuml"))
            editingController.fileClass(scanner);
        else if (line.equals("@startsequml"))
            editingController.fileSeq(scanner);
        else
        {
            editingController.errorMessage.setText("Error: Incorrect file format.");
            editingController.errorMessage.setVisible(true);
        }
    }

    /**
     * Opens the diagram editing window.
     */
    public void switchToEditing(ActionEvent event) throws IOException {
        root = loader.load();
        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    /**
     * Opens a window with the creation of a sequence diagram
     */
    public void switchToCreateSeq(ActionEvent event) throws IOException {
        root = loader.load();

        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();

        EditingController editingController = loader.getController();
        editingController.createSequence();
    }

    /**
     * Opens help message.
     */
    @FXML public void showHelpWindow() {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader();
            fxmlLoader.setLocation(getClass().getResource("help.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            Stage stage = new Stage();
            stage.setScene(scene);
            stage.show();
        } catch (IOException e) {
            System.err.println("Error: Failed to create Help window." + e);
        }
    }
}
