package com.example.project;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class EditingController{

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    public AnchorPane MainPane;

    @FXML
    private Button addDiagramButton;

    @FXML
    private Button homeButton;

    private Stage stage;
    private Scene scene;
    private Parent root;

    //Switch windows.
    public void switchToMain(ActionEvent event) throws IOException {
        root = FXMLLoader.load(getClass().getResource("hello-view.fxml"));
        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);

        stage.setScene(scene);
        stage.show();
    }

    public void addDiagram(ActionEvent event){
        VBox vbox = new VBox();

        VBox attributes = new VBox();
        vbox.getChildren().add(attributes);

        //vbox.getChildren().add(new Separator());

        TextField nameTextField = new TextField();

        MainPane.getChildren().add(nameTextField);
        String username = nameTextField.getText();

        TitledPane titledPane = new TitledPane(username, vbox);
        titledPane.setLayoutX(10*5);
        titledPane.setLayoutY(10*5);
        titledPane.setCollapsible(false);

        moving(titledPane);

        MainPane.getChildren().add(titledPane);
    }

    public void createDiagramFromFile(String className, List<UMLAttribute> attributes, List<UMLOperation> operations)
    {
        VBox vbox = new VBox();
        TitledPane titledPane = new TitledPane("Class: " + className, vbox);

        //Handle list with attributes.
        for(UMLAttribute i:attributes){
            Text text = new Text(i.toString());
            vbox.getChildren().add(text);
        }

        // Line between attributes and operations.
        vbox.getChildren().add(new Separator());

        for(UMLOperation i:operations){
            Text text = new Text(i.toString());
            vbox.getChildren().add(text);
        }
        //Clear lists with attributes and operations.
        attributes.clear();
        operations.clear();


        //Change location of diagram.
        titledPane.setLayoutX(10*5);
        titledPane.setLayoutY(10*5);
        //Open list -
        titledPane.setCollapsible(false);

        //For moving diagrams.
        moving(titledPane);

        MainPane.getChildren().add(titledPane);
    }

    //For moving diagrams.
    double positionX, positionY;
    double dynamicX, dynamicY, newDynamicX, newDynamicY;
    double displacementX, displacementY;

    public void moving(TitledPane titledPane){
        //For select.
        titledPane.setOnMousePressed(new EventHandler<MouseEvent>() {
            public void handle(MouseEvent event) {
                positionX = event.getSceneX();
                positionY = event.getSceneY();
                dynamicX = ((TitledPane)(event.getSource())).getTranslateX();
                dynamicY = ((TitledPane)(event.getSource())).getTranslateY();
            }
        });

        //For moving.
        titledPane.setOnMouseDragged(new EventHandler <MouseEvent>()
        {
            public void handle(MouseEvent event) {
                displacementX = event.getSceneX() - positionX;
                displacementY = event.getSceneY() - positionY;
                newDynamicX = displacementX + dynamicX;
                newDynamicY = displacementY + dynamicY;
                ((TitledPane)(event.getSource())).setTranslateX(newDynamicX);
                ((TitledPane)(event.getSource())).setTranslateY(newDynamicY);
            }
        });
    }
}
