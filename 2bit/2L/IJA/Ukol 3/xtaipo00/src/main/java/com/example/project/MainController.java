package com.example.project;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;
import java.util.Scanner;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class MainController {

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    private Button openFileButton;

    @FXML
    void initialize() {}

    FXMLLoader loader = new FXMLLoader(getClass().getResource("editing_page.fxml"));

    public void OpenFileAction(ActionEvent event) throws IOException {

        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Select file");
        File selectedFile = fileChooser.showOpenDialog(new Stage());

        Scanner scanner = new Scanner(selectedFile);
        //ClassDiagram classDiagram = new ClassDiagram();
        //UMLClass umlClass = null;


        UMLClass umlClass = new UMLClass(null);

        String line = scanner.nextLine();

        //ADD ----- if (line.equals(""))
        //SWITCH!!!
        if(line.equals("@startuml"))
        {
            switchToEditing(event);


            //Parse all file
            while (scanner.hasNextLine())
            {
                UMLAttribute umlAttribute = new UMLAttribute(null, null, null);
                UMLOperation umlOperation = new UMLOperation(null, null, null);

                line = scanner.nextLine();
                //пустые строки
                if (line.equals("")){
                    continue;
                }

                String[] parts = line.split(" ");

                if (parts[0].equals("class"))
                {
                    umlClass.name = parts[1];
                    System.out.println("ClassName : " + umlClass.name);

                    if (!parts[2].equals("{"))
                        System.err.println("No start brace \"{\"!");

                    continue;
                }

                if (parts[0].equals("}"))
                {
                    handleClassForFile(umlClass.name, umlClass.attributes, umlClass.operations);

                    continue;
                }

                else if(parts[0].equals("attribute"))
                {
                    if(parts[1].equals("+") || parts[1].equals("-") || parts[1].equals("#") || parts[1].equals("~"))
                    {
                        umlAttribute.visibility = parts[1];
                        System.out.println("Visibility of attribute : " + umlAttribute.visibility);
                    }
                    else
                        System.err.println("Wrong name of visibility.");

                    if (parts[2].equals("void") || parts[2].equals("string") || parts[2].equals("int") || parts[2].equals("bool"))
                    {
                        umlAttribute.name = parts[3];
                        umlAttribute.type = parts[2];
                        System.out.println("Type of attribute : " + umlAttribute.type + "\nName : " + umlAttribute.name);
                    }
                    else
                        System.err.println("Wrong declaration of attribute.");

                    umlClass.addAttribute(umlAttribute);
                    System.out.println(umlClass.attributes);
                    continue;
                }
                else if(parts[0].equals("operation"))
                {
                    System.out.println(parts[0] + parts[1] + parts[2] + parts[3]);

                    if(parts[1].equals("+") || parts[1].equals("-") || parts[1].equals("#") || parts[1].equals("~"))
                    {
                        umlOperation.visibility = parts[1];
                        System.out.println("Visibility of operations : " + umlOperation.visibility);
                    }
                    else
                        System.err.println("Wrong name of visibility.");

                    if (parts[2].equals("void") || parts[2].equals("string") || parts[2].equals("int") || parts[2].equals("bool"))
                    {
                        umlOperation.type = parts[2];
                        System.out.println("Type of operation : " + umlOperation.type);
                    }
                    else
                        System.err.println("Wrong type.");

                    if (parts[3].endsWith("()"))
                    {
                        umlOperation.name = parts[3];
                        System.out.println("Name of operation : " + umlOperation.name);
                    }
                    else
                        System.err.println("Wrong Operation declaration.");

                    umlClass.addOperation(umlOperation);
                    System.out.println(umlClass.operations);
                    continue;
                }


                if(line.equals("@enduml"))
                {
                    System.out.println("End");
                    break;
                }
                System.out.println(umlClass.getAttrPosition(umlAttribute));
            }

        }
    }



    private Stage stage;
    private Scene scene;
    private Parent root;

    public void switchToEditing(ActionEvent event) throws IOException {
        //FXMLLoader loader = new FXMLLoader(getClass().getResource("editing_page.fxml"));
        root = loader.load();

        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }


    public void handleClassForFile(String className, List<UMLAttribute> attributes, List<UMLOperation> operations){
        EditingController editingController = loader.getController();
        editingController.createDiagramFromFile(className, attributes, operations);
    }
}
