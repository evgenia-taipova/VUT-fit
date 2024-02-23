/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 */

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
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.Polygon;
import javafx.scene.text.Font;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import javafx.scene.text.Text;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import javafx.scene.layout.AnchorPane;
import javafx.geometry.*;


public class EditingController{
    @FXML
    public Button undoButton;

    @FXML
    public AnchorPane MainClass;

    @FXML
    public AnchorPane MainSequence;

    @FXML
    private TextField className;

    @FXML
    private TextField typeOperationClass;

    @FXML
    public Label errorMessage;

    @FXML
    private TextField nameAttribute;

    @FXML
    private TextField typeAttributeClass;

    @FXML
    private TextField nameSeqOperation;

    @FXML
    private TextField nameOperation;

    @FXML
    private TextField renameClassField;

    @FXML
    private TabPane editClassTab;

    @FXML
    private Button addMainSeqButton;

    @FXML
    private ChoiceBox<String> visibilityChoiseAtr;

    @FXML
    private ChoiceBox<String> visibilityChoiseOper;

    @FXML
    public ChoiceBox<String> relationsChose;

    @FXML
    public ChoiceBox<String> choiceClassForRelation2;

    @FXML
    public ComboBox<String> choiceClass;

    @FXML
    public ComboBox<String> choiceOperationSeq;

    @FXML
    private TabPane tabDiagram;

    @FXML
    private Tab tabClass;

    @FXML
    private Tab tabSequence;

    @FXML
    private TextField participantName;

    @FXML
    private TabPane editSeqTab;

    @FXML
    private TextField renameSeqField;

    @FXML
    private ComboBox<String> choiceParticipant;

    @FXML
    private ComboBox<String> choiceSecondParticipant;

    @FXML
    private ChoiceBox<String> typeChoiceArrow;

    @FXML
    private ChoiceBox<Integer> choicePlaceSeq;

    @FXML
    private ChoiceBox<String> attributeClassChoice;

    @FXML
    private ChoiceBox<String> operationClassChoice;

    @FXML
    private ChoiceBox<String> operationSeqChoice;

    // To change windows.
    private Stage stage;
    private Scene scene;
    private Parent root;

    // To fill the choice boxes.
    private String[] visibility_arr = {"+", "-", "~", "#"};
    private String[] relations = {"association", "aggregation", "composition", "generalization"};
    private String[] operationsSeq = {"synchronous", "asynchronous", "return", "creation", "destruction"};

    @FXML
    void initialize() {
        // Fills the choice boxes.
        visibilityChoiseAtr.getItems().addAll(visibility_arr);
        visibilityChoiseAtr.setValue("+");
        visibilityChoiseOper.getItems().addAll(visibility_arr);
        visibilityChoiseOper.setValue("+");
        relationsChose.getItems().addAll(relations);
        relationsChose.setValue("association");
        typeChoiceArrow.getItems().addAll(operationsSeq);
        typeChoiceArrow.setValue("synchronous");

        errorMessage.setVisible(false);
        editClassTab.setDisable(true);
        editSeqTab.setDisable(true);
    }

    // For undo.
    UNDO undo = new UNDO();

    /**
     * To switch between diagram windows
     */
    public void createSequence(){
        tabDiagram.getSelectionModel().select(1);
    }

    /**
     * Switch windows.
     */
    public void switchToMain(ActionEvent event) throws IOException {
        root = FXMLLoader.load(getClass().getResource("home.fxml"));
        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);

        stage.setScene(scene);
        stage.show();
    }

    /**
     * File parser for diagram class.
     */
    public void fileClass(Scanner scanner){
        String line;
        String class_name = null;

        // Reads each line and categorizes each word.
        while (scanner.hasNextLine())
        {
            line = scanner.nextLine();
            // Skips blank lines.
            if (line.equals("")){
                continue;
            }

            String[] parts = line.split(" ");

            if (parts[0].equals("class"))
            {
                if (classDiagram.findClass(parts[1]) != null)
                {
                    errorMessage.setText("Error: A class with the same name already exists.");
                    errorMessage.setVisible(true);
                    return;
                }
                // Sets up the choice boxes.
                handleChoices(null, parts[1], true, true);

                // Creates a class.
                classDiagram.createClass(parts[1]);
                // Saves class name.
                class_name = parts[1];

                if (!parts[2].equals("{"))
                {
                    errorMessage.setText("Error: No start brace in " + class_name + " class.");
                    errorMessage.setVisible(true);
                    return;
                }
                continue;
            }

            switch (parts[0]) {
                // End of class.
                case "}":
                    UMLClass umlClass = classDiagram.findClass(class_name);
                    // Processes the class to display.
                    releaseClass(umlClass);
                    continue;

                //Handles the attribute.
                case "attribute":
                    UMLAttribute umlAttribute = new UMLAttribute(null, null, null);

                    if (parts[1].equals("+") || parts[1].equals("-") || parts[1].equals("#") || parts[1].equals("~"))
                        umlAttribute.visibility = parts[1];
                    else
                    {
                        errorMessage.setText("Error: Wrong name of visibility.");
                        errorMessage.setVisible(true);
                        return;
                    }

                    umlAttribute.name = parts[3];
                    umlAttribute.type = parts[2];

                    // Finds the class we need and write the attributes there.
                    UMLClass forAttributes = classDiagram.findClass(class_name);
                    forAttributes.addAttribute(umlAttribute);
                    continue;

                //Handles the operation.
                case "operation":
                    UMLOperation umlOperation = new UMLOperation(null, null, null);

                    if (parts[1].equals("+") || parts[1].equals("-") || parts[1].equals("#") || parts[1].equals("~"))
                        umlOperation.visibility = parts[1];
                    else
                    {
                        errorMessage.setText("Error: Wrong name of visibility.");
                        errorMessage.setVisible(true);
                        return;
                    }

                    if (!parts[2].equals("null"))
                        umlOperation.type = parts[2];
                    else
                        umlOperation.type = "";
                    if (parts[3].endsWith(")")) {
                        umlOperation.name = parts[3];
                        // Check if operation is entered correctly.
                        if (!umlOperation.name.matches("\\w*\\([^()]*\\)\\s*")) {
                            errorMessage.setText("Error: Invalid operation format.");
                            errorMessage.setVisible(true);
                            return;
                        }
                    }
                    else
                    {
                        errorMessage.setText("Error: Wrong Operation declaration.");
                        errorMessage.setVisible(true);
                        return;
                    }

                    // Finds the class we need and write the operation there.
                    UMLClass forOperation = classDiagram.findClass(class_name);
                    forOperation.addOperation(umlOperation);
                    continue;
            }

            //Handles the relation.
            if (parts[0].equals("relation"))
            {
                classDiagram.relations.add(parts[1] + " " + parts[2] + " " + parts[3]);
                addRelation(null);
                continue;
            }

            if(line.equals("@enduml"))
            {
                editClassTab.setDisable(false);
                errorMessage.setText("Successfully.");
                errorMessage.setTextFill(Color.FORESTGREEN);
                errorMessage.setVisible(true);
                break;
            }
        }
    }

    /**
     * File parser for sequence diagram.
     */
    public void fileSeq(Scanner scanner){
        errorMessage.setTextFill(Color.RED);
        String line;

        // Reads each line and categorizes each word.
        while (scanner.hasNextLine())
        {
            line = scanner.nextLine();
            // Skips blank lines.
            if (line.equals("")){
                continue;
            }

            String[] parts = line.split(" ");

            switch (parts[0]) {

                //Handles the participant.
                case "participant":
                    umlSequence.participants.add(parts[1]);
                    // Sets up the choice boxes.
                    handleChoices(null, parts[1], false, true);
                    continue;

                //Handles the operation.
                case "operation":
                    umlSequence.operations.add(parts[1]);

                    if (parts[2].equals(":"))
                    {
                        if (umlSequence.participants.contains(parts[3]) && parts[4].equals("to") &&
                                umlSequence.participants.contains(parts[5]))
                            umlSequence.from_to.add(parts[3] + " " + parts[5]);
                        else
                        {
                            errorMessage.setText("Error: Wrong Sequence format.");
                            errorMessage.setVisible(true);
                            return;
                        }

                        if (parts[6].equals("syn") || parts[6].equals("asyn") || parts[6].equals("back")
                                                   || parts[6].equals("make") || parts[6].equals("del"))
                            umlSequence.type_arrow.add(parts[6]);
                        else
                        {
                            errorMessage.setText("Error: Wrong Sequence format.");
                            errorMessage.setVisible(true);
                            return;
                        }
                    }
                    continue;
            }

            if(line.equals("@endsequml"))
            {
                editSeqTab.setDisable(false);
                releaseSequence();
                tabDiagram.getSelectionModel().select(1);
                errorMessage.setText("Successfully.");
                errorMessage.setTextFill(Color.FORESTGREEN);
                errorMessage.setVisible(true);
                break;
            }
        }
    }

    /**
     * Processes sequence diagram and displays it.
     */
    public void releaseSequence(){
        boolean wrongOperation = false;
        MainSequence.getChildren().clear();

        // Prepares the zone size for display.
        MainSequence.setMaxWidth(663 * (umlSequence.participants.size() / 4.5));
        MainSequence.setMinWidth(663 * (umlSequence.participants.size() / 4.5));
        MainSequence.setMaxHeight(637 * (umlSequence.operations.size() / 8.5));
        MainSequence.setMinHeight(637 * (umlSequence.operations.size() / 8.5));

        // Handles the make arrow.
        List<String> deleted_participants = new ArrayList<String>();
        if (umlSequence.type_arrow.contains("make")) {
            int index = umlSequence.type_arrow.indexOf("make");
            String str = umlSequence.from_to.get(index);
            String[] parts = str.split(" ");
            deleted_participants.add(parts[1]);
        }


        // Basis for Sequence Diagram.
        HBox hbox1 = new HBox(50);

        // Creates the top row of participants.
        for (int i = 0; i < umlSequence.participants.size(); i++)
        {
            TitledPane pane = new TitledPane();

            // Add an ID so that you can easily find this object later.
            pane.setId(i + "-hbox1");

            pane.setMinWidth(100);
            pane.setMaxWidth(100);

            pane.setText(umlSequence.participants.get(i));
            pane.setAlignment(Pos.CENTER);

            //No drop-down.
            pane.setCollapsible(false);

            hbox1.setLayoutX(10);
            hbox1.setLayoutY(10);
            hbox1.getChildren().add(pane);
        }

        // Creates the bottom row of participants.
        HBox hbox2 = new HBox(50);
        for (int i = 0; i < umlSequence.participants.size(); i++)
        {
            TitledPane pane = new TitledPane();
            // Add an ID so that you can easily find this object later.
            pane.setId(i + "-hbox2");

            pane.setMinWidth(100);
            pane.setMaxWidth(100);

            pane.setText(umlSequence.participants.get(i));
            pane.setAlignment(Pos.CENTER);
            // No drop-down.
            pane.setCollapsible(false);

            hbox2.setLayoutX(10);
            // Shifts down depending on the number of operations.
            hbox2.setLayoutY(65 * umlSequence.operations.size() + 60);
            hbox2.getChildren().add(pane);
        }

        // First pane.
        double start_x1 = hbox1.getLayoutX();
        double start_y1 = hbox1.getLayoutY() + 4;
        double start_x2 = hbox2.getLayoutX();
        double start_y2 = hbox2.getLayoutY() + 4;
        int between_obj = 50;
        int width_pane = 100;
        double end_x1;
        double end_x2;

        for (int i = 0; i < umlSequence.participants.size(); i++)
        {
            // Panel edge.
            end_x1 = start_x1 + width_pane;
            end_x2 = start_x2 + width_pane;

            // Line in the center of the panel.
            Line line = new Line((end_x1 + start_x1) / 2, start_y1, (end_x2 + start_x2) / 2, start_y2);
            line.setId(i+"-timeline");
            line.setStrokeWidth(2);
            line.getStrokeDashArray().addAll(5d);
            line.setStroke(Color.rgb(152,188,227));

            // Next panel.
            start_x1 = end_x1 + between_obj;
            start_x2 = end_x2 + between_obj;
            MainSequence.getChildren().add(line);
        }

        MainSequence.getChildren().add(hbox1);
        MainSequence.getChildren().add(hbox2);

        double between_operations = 50;
        double first_optionX = 60;
        double between_options = 150;
        double first_optionY = 85;
        double x1;
        double x2;
        double y;
        int index1;
        int index2;


        for (int i = 0; i < umlSequence.operations.size(); i++)
        {
            String str = umlSequence.from_to.get(i);
            // Takes each word and return its index in order.
            String[] parts = str.split(" ");
            index1 = umlSequence.participants.indexOf(parts[0]);
            index2 = umlSequence.participants.indexOf(parts[1]);

            // Settings line operation.
            x1 = first_optionX + index1 * between_options;
            y = first_optionY + between_operations * i;
            x2 = first_optionX + index2 * between_options;

            // Line without arrow.
            Line line = new Line(x1, y, x2, y);
            line.setStrokeWidth(2);
            line.setStroke(Color.rgb(0, 122, 195));

            // Place for the arrow.
            Text operationNum = new Text(Integer.toString(i + 1));
            operationNum.setLayoutX(10);
            operationNum.setLayoutY(y + 6);
            operationNum.setStroke(Color.rgb(208,208,208));
            operationNum.setFont(Font.font(14));

            // Place for text.
            Text operationName = new Text(umlSequence.operations.get(i));

            // Text layout.
            if (operationName.getText().length() < 10)
                operationName.setLayoutX((x2 + x1) / 2+2);
            else
                operationName.setLayoutX((x2 + x1) / 2 - 50);
            operationName.setLayoutY(y - 8);

            String arrowType = umlSequence.type_arrow.get(i);

            // If the object has not yet been created.
            if(arrowType.equals("make"))
                deleted_participants.remove(parts[1]);

            Line arrow1 = new Line(x2, y, 0.0, y - 8);
            Line arrow2 = new Line(x2, y, 0.0, y + 8);
            arrow1.setStrokeWidth(2);
            arrow2.setStrokeWidth(2);
            arrow1.setStroke(Color.rgb(0, 122, 195));
            arrow2.setStroke(Color.rgb(0, 122, 195));

            // If the object doesn't exist.
            if(deleted_participants.contains(parts[0]) || deleted_participants.contains(parts[1]))
            {
                line.setStroke(Color.RED);
                arrow1.setStroke(Color.RED);
                arrow2.setStroke(Color.RED);
                operationName.setStroke(Color.RED);
            }

            // Direction arrow.
            if (arrowType.equals("asyn"))
            {
                if (index1 < index2)
                {
                    arrow1.setEndX(x2 - 8);
                    arrow2.setEndX(x2 - 8);
                }
                else
                {
                    arrow1.setEndX(x2 + 8);
                    arrow2.setEndX(x2 + 8);
                }
            }
            else if (index1 > index2 && arrowType.equals("back"))
            {
                arrow1.setEndX(x2 + 8);
                arrow2.setEndX(x2 + 8);
                // Return message.
                line.getStrokeDashArray().addAll(5d);
                if(operationName.getText().equals("false"))
                {
                    operationName.setStroke(Color.RED);
                    arrow1.setStroke(Color.RED);
                    arrow2.setStroke(Color.RED);
                    line.setStroke(Color.RED);
                }
            }
            else if (arrowType.equals("syn")){
                double endX;
                if (index1 < index2)
                {
                    endX = x2 - 8;
                    arrow1.setEndX(endX);
                    arrow2.setEndX(endX);
                }
                else
                {
                    endX = x2 + 8;
                    arrow1.setEndX(endX);
                    arrow2.setEndX(endX);
                }
                Line arrow3 = new Line(endX, y - 8, endX, y + 8);
                arrow3.setStrokeWidth(2);
                if(deleted_participants.contains(parts[0]) || deleted_participants.contains(parts[1]))
                    arrow3.setStroke(Color.RED);
                else
                    arrow3.setStroke(Color.rgb(0, 122, 195));
                MainSequence.getChildren().add(arrow3);
            }
            else if (arrowType.equals("del")) {
                arrow1.setEndX(x2 - 20);
                arrow2.setEndX(x2 - 20);
                arrow1.setStartX(x2 - 12);
                arrow2.setStartX(x2 - 12);
                line.setEndX(x2 - 12);
                Line line1 = new Line(x2 - 10, y - 10,x2 + 10,y + 10);
                Line line2 = new Line(x2 + 10, y - 10,x2 - 10,y + 10);

                line1.setStrokeWidth(2);
                line1.setStroke(Color.RED);

                line2.setStrokeWidth(2);
                line2.setStroke(Color.RED);

                MainSequence.getChildren().add(line1);
                MainSequence.getChildren().add(line2);
                //"Removes".
                MainSequence.lookup("#"+index2+"-hbox2").setVisible(false);
                deleted_participants.add(parts[1]);
                // remove from lists?

                // Shifts the line.
                Line timeline = (Line) MainSequence.lookup("#"+index2+"-timeline");
                timeline.setEndY(y);
            }
            else if (index1 < index2 && arrowType.equals("make")) {
                // Changes what was originally created.
                arrow1.setEndX(x2 - 61);
                arrow2.setEndX(x2 - 61);
                arrow1.setStartX(x2 - 53);
                arrow2.setStartX(x2 - 53);
                line.setEndX(x2 - 53);
                Line timeline = (Line) MainSequence.lookup("#"+index2+"-timeline");
                timeline.setStartY(y);

                TitledPane pane = (TitledPane) MainSequence.lookup("#"+index2+"-hbox1");
                pane.setTranslateY(y-23);
                deleted_participants.remove(parts[1]);
            }

            // Checks if there is such an operation. If not, the arrow is red.
            if(arrowType.equals("syn") || arrowType.equals("asyn"))
            {
                wrongOperation = true;
                int index = operationName.getText().indexOf("(");
                for(int j = 0; j < classDiagram.classes.size(); j++)
                {
                    UMLClass umlClass = classDiagram.classes.get(j);
                    for(int g = 0; g < umlClass.operations.size(); g++)
                    {
                        UMLOperation umlOperation = umlClass.operations.get(g);
                        if(umlOperation.name.contains((operationName.getText().substring(0, index))))
                            //If such an operation is valid
                            wrongOperation = false;
                    }
                }
            }
            // If the operation is incorrect.
            if(wrongOperation && choiceClass.getItems().size() != 0)
            {
                operationName.setStroke(Color.RED);
                arrow1.setStroke(Color.RED);
                arrow2.setStroke(Color.RED);
                line.setStroke(Color.RED);

                // Automatic false
//                umlSequence.addArrow(parts[1], parts[0], "back", "false", (choicePlaceSeq.getValue() + 1));
                wrongOperation = false;
            }

            MainSequence.getChildren().add(arrow1);
            MainSequence.getChildren().add(arrow2);
            MainSequence.getChildren().add(line);
            MainSequence.getChildren().add(operationName);
            MainSequence.getChildren().add(operationNum);
        }


        // So that the choicebox with the choice of place works correctly.
        choicePlaceSeq.getItems().clear();
        int forChoicePlace = umlSequence.operations.size() + 1;
        for (int i = 1; i <= forChoicePlace; i++)
        {
            choicePlaceSeq.getItems().add(i);
        }
        choicePlaceSeq.setValue(forChoicePlace);
        updateOperationDelChoiceSeq(null);
    }

    // For moving diagrams.
    double positionX, positionY;
    double dynamicX, dynamicY, newDynamicX, newDynamicY;
    double displacementX, displacementY;

    /**
     * Moving diagrams.
     */
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


                //If the object to be moved has a relation.
                for (int i = 0; i < classDiagram.relations.size(); i++)
                {
                    if(classDiagram.relations.get(i).contains(titledPane.getText()))
                    {
                        // Finds the object to be moved and its coordinates.
                        String[] parts = classDiagram.relations.get(i).split(" ");

                        int id = classDiagram.getClassPosition(classDiagram.findClass(parts[0]));
                        int id2 = classDiagram.getClassPosition(classDiagram.findClass(parts[2]));

                        Bounds first = MainClass.lookup("#" + id + "-class").getBoundsInParent();
                        Bounds second = MainClass.lookup("#" + id2 + "-class").getBoundsInParent();

                        double x1 = first.getCenterX();
                        double y1 = first.getCenterY();
                        double h1 = first.getHeight() / 2;

                        double x2 = second.getCenterX();
                        double y2 = second.getCenterY();
                        double h2 = second.getHeight() / 2;

                        // Find lines that are attached to an object and that should move.
                        Line line1 = (Line) MainClass.lookup("#1-" + id + "-" + id2);
                        Line line2 = (Line) MainClass.lookup("#2-" + id + "-" + id2);
                        Line line3 = (Line) MainClass.lookup("#3-" + id + "-" + id2);
                        Line line4 = (Line) MainClass.lookup("#4-" + id + "-" + id2);
                        Line line5 = (Line) MainClass.lookup("#5-" + id + "-" + id2);
                        Line line6 = (Line) MainClass.lookup("#6-" + id + "-" + id2);
                        Line line7 = (Line) MainClass.lookup("#7-" + id + "-" + id2);
                        Polygon polygon = (Polygon) MainClass.lookup("#8-" + id + "-" + id2);

                        // Handles the correctness of moving lines.
                        handleArrows(parts[1], x1, y1, x2, y2, h1, h2, line1, line2, line3, line4, line5, line6, line7, polygon);
                    }
                }
            }
        });
    }

    public ClassDiagram classDiagram = new ClassDiagram("classDiagram");
    public UMLSequence umlSequence = new UMLSequence("umlSequence");

    /**
     * Creates a class for the class diagram.
     */
    @FXML
    public void createNewClass(ActionEvent event) {
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Gets the name of the class to be created.
        String class_name = className.getText();

        // Checks if something has been entered.
        if (class_name.equals(""))
        {
            errorMessage.setText("Error: A class cannot be without a name.");
            errorMessage.setVisible(true);
            return;
        }
        // Checks if the class already exists or not.
        else if (classDiagram.findClass(class_name) != null)
        {
            errorMessage.setText("Error: A class with the same name already exists.");
            errorMessage.setVisible(true);
            return;
        }

        // Sets up the choice boxes.
        handleChoices(null, class_name, true, true);

        // Creates a new class.
        UMLClass umlClass = classDiagram.createClass(class_name);

        // For undo.
        undo.saveAction(UNDO.createClass, class_name, null);

        // Processes the class to display.
        releaseClass(umlClass);

        // Shows the Edit class panel.
        editClassTab.setDisable(false);
    }

    /**
     * Processes the class to display.
     */
    public void releaseClass(UMLClass testUmlClass) {

        // Class basis.
        VBox classBox = new VBox();

        // Gets the index in the list of classes to find the TitledPane in the list with panels.
        // They are created together and must have the same index.
        int index = classDiagram.getClassPosition(testUmlClass);
        TitledPane classPane = classDiagram.findPane(index);

        // Attaches the panel to the box.
        classPane.setContent(classBox);
        // Adds name.
        classPane.setText(testUmlClass.getName());

        // Handle list with attributes.
        attributeClassChoice.getItems().clear();
        for (UMLAttribute i : testUmlClass.getAttributes())
            classBox.getChildren().add(new Text(i.toString()));

        // Handle list with operations.
        for (UMLOperation i : testUmlClass.getOperations()) {
            classBox.getChildren().add(new Text(i.toString()));
        }
        // Sets up the choice boxes.
        updateBoxesClass(null);

        // Prepares space size for classes
        int counterClass = classDiagram.classes.size();
        MainClass.setMinHeight((counterClass -1)  * 60);
        MainClass.setMaxHeight((counterClass -1) * 60);

        // Handles class layout.
        // * * *
        // * * *
        int j;
        if (counterClass <= 3)
            j = 1;
        else
        {
            int k = (counterClass-1)/ 3;
            j = 3 * k +1 ;
        }

        switch ((counterClass-1) % 3) {
            case 0:
                classPane.setLayoutX(50);
                classPane.setLayoutY(50 * j);
                break;
            case 1:
                classPane.setLayoutX(350);
                classPane.setLayoutY(50 * j);
                break;
            case 2:
                classPane.setLayoutX(650);
                classPane.setLayoutY(50 * j);
                break;
        }

        // No drop-down.
        classPane.setCollapsible(false);

        //For moving diagrams.
        moving(classPane);

        // Removes the old class.
        MainClass.getChildren().remove(classPane);

        // Adds a new class.
        MainClass.getChildren().add(classPane);

        // Removes the ability to create a participant by entering a name.
        participantName.setDisable(true);
    }

    /**
     * Removes the class and everything associated with it.
     */
    public void deleteClass(ActionEvent event)
    {
        // Gets the name of the class to be removed.
        String className = choiceClass.getValue();

        // Gets the class.
        UMLClass umlClass = classDiagram.findClass(className);

        // Gets its index in the list of classes.
        int index = classDiagram.getClassPosition(umlClass);

        // Gets a panel that displays the class.
        TitledPane pane = classDiagram.findPane(index);
        MainClass.getChildren().remove(pane);

        // Removes class and panel from lists and choice boxes.
        classDiagram.classes.remove(umlClass);
        classDiagram.panes.remove(pane);
        choiceClass.getItems().remove(className);
        choiceClassForRelation2.getItems().remove(className);

        //todo delete arrows
        //classDiagram.removeRelations(className, classDiagram, MainClass);
//
//        for(int x = 0; x < classDiagram.relations.size(); x++)
//        {
//            String[] parts = classDiagram.relations.get(x).split(" ");
//            if(parts[0].equals(className) || parts[2].equals(className)) {
//                int id = classDiagram.getClassPosition(classDiagram.findClass(parts[0]));
//                int id2 = classDiagram.getClassPosition(classDiagram.findClass(parts[2]));
//
////                Bounds first = MainClass.lookup("#" + id + "-class").getBoundsInParent();
////                Bounds second = MainClass.lookup("#" + id2 + "-class").getBoundsInParent();
//                if(parts[0].equals(className))
//                {
//                    Line line1 = (Line) MainClass.lookup("#1-" + id + "-" + id2);
//                    Line line2 = (Line) MainClass.lookup("#2-" + id + "-" + id2);
//                    Line line3 = (Line) MainClass.lookup("#3-" + id + "-" + id2);
//                    line1.setVisible(false);
//                    line2.setVisible(false);
//                    line3.setVisible(false);
//                }
//                else
//                {
//                    Line line1 = (Line) MainClass.lookup("#1-" + id2 + "-" + id);
//                    Line line2 = (Line) MainClass.lookup("#2-" + id2 + "-" + id);
//                    Line line3 = (Line) MainClass.lookup("#3-" + id2 + "-" + id);
//                    line1.setVisible(false);
//                    line2.setVisible(false);
//                    line3.setVisible(false);
//                }
//
//
//                classDiagram.relations.remove(x);
//            }
//        }


        // Hides the class editing panel.
        if (choiceClass.getItems().isEmpty())
            editClassTab.setDisable(true);
        else
        {
            choiceClass.setValue(classDiagram.classes.get(0).getName());
            choiceClassForRelation2.setValue(classDiagram.classes.get(0).getName());
        }

        // If there are no more classes left, then we create the ability to enter the participant manually.
        if (choiceClass.getItems().size() == 0)
            participantName.setDisable(false);
    }

    /**
     * Adds an attribute to a specific class.
     */
    @FXML
    public void addAttribute(ActionEvent event){

        UMLAttribute umlAttribute = new UMLAttribute(null, null, null);

        // Gets attribute.
        String className = choiceClass.getValue();
        umlAttribute.visibility = visibilityChoiseAtr.getValue();
        umlAttribute.type = typeAttributeClass.getText();
        umlAttribute.name = nameAttribute.getText();

        // For undo.
        undo.saveAction(UNDO.addAttributeClass, umlAttribute.getName(), className);

        // Gets the class to add attributes to.
        UMLClass forAttributes = classDiagram.findClass(className);

        // Adds to list with attributes.
        forAttributes.addAttribute(umlAttribute);
        //todo если уже есть аттрибуты. с одинаковым именем.

        // Processes the class to display.
        releaseClass(forAttributes);
    }

    /**
     * Removes an attribute from a specific class.
     */
    @FXML
    public void deleteClassAttribute(ActionEvent event){
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // If there is no attribute to remove.
        if(attributeClassChoice.getItems().size() == 0)
        {
            errorMessage.setText("Error: No attribute to delete.");
            errorMessage.setVisible(true);
            return;
        }

        // Gets an attribute and selects its name, then removes it.
        String[] attribute = attributeClassChoice.getValue().split(" ");
        String className = choiceClass.getValue();
        UMLClass umlClass = classDiagram.findClass(className);
        umlClass.removeAttribute(attribute[1]);

        // Processes the class to display.
        releaseClass(umlClass);
    }

    /**
     * Adds operation to a specific class.
     */
    @FXML
    public void addOperationClass(ActionEvent event){
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Creates an attribute to further fill it.
        UMLOperation umlOperation = new UMLOperation(null, null, null);

        // Gets operation.
        String className = choiceClass.getValue();
        umlOperation.visibility = visibilityChoiseOper.getValue();
        umlOperation.type = typeOperationClass.getText();
        umlOperation.name = nameOperation.getText();

        // For undo.
        undo.saveAction(UNDO.addOperationClass, umlOperation.getName(), className);

        // Checks if operation is entered correctly.
        if(!umlOperation.name.matches("\\w*\\([^()]*\\)\\s*")){
            errorMessage.setText("Error: Invalid operation format.");
            errorMessage.setVisible(true);
            return;
        }

        // Gets the class to add the attribute to.
        UMLClass forOperation = classDiagram.findClass(className);

        // Add to list with attributes.
        forOperation.addOperation(umlOperation);

        // Processes the class to display.
        releaseClass(forOperation);
    }

    /**
     * Removes operation from a specific class.
     */
    public void deleteClassOperation(ActionEvent event)
    {
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Checks if an attribute exists.
        if(operationClassChoice.getItems().size() == 0)
        {
            errorMessage.setText("Error: No operation to delete.");
            errorMessage.setVisible(true);
            return;
        }

        // Gets operation and selects its name, then removes it.
        String[] operation = operationClassChoice.getValue().split(" ");
        String className = choiceClass.getValue();
        UMLClass umlClass = classDiagram.findClass(className);
        umlClass.removeOperation(operation[1]);

        // Processes the class to display.
        releaseClass(umlClass);
    }

    /**
     * For line setting.
     */
    public void lineSetting(Line line, double x1, double y1, double x2, double y2)
    {
        line.setStartX(x1);
        line.setStartY(y1);
        line.setEndX(x2);
        line.setEndY(y2);
    }

    /**
     * Works with the correct location of the arrows depending on the location of the object.
     */
    public void handleArrows(String relationType, double x1, double y1, double x2, double y2, double h1,  double h2,
                             Line line1, Line line2, Line line3, Line line4, Line line5, Line line6, Line line7, Polygon polygon)
    {
        if (relationType.equals("association")) {
            if (y2 - y1 >= 20) {
                lineSetting(line1, x1, y1 + h1 - 2, x1,y2 - h2 - 40);
                lineSetting(line2, x1, y2 - h2 - 40, x2 +30,y2 - h2 - 40);
                lineSetting(line3, x2+30, y2 - h2 - 40, x2+30,y2 - h2);
                lineSetting(line4, x2+30, y2 - h2, x2 +38,y2 - h2 - 16);
                lineSetting(line5, x2+30, y2 - h2, x2 +22,y2 - h2 - 16);
            } else {
                lineSetting(line1, x1, y1 - h1 + 2, x1,y2 + h2 + 40);
                lineSetting(line2, x1, y2 + h2 + 40, x2+30,y2 + h2 + 40);
                lineSetting(line3, x2+30, y2 + h2 + 40, x2+30,y2 + h2);
                lineSetting(line4, x2+30, y2 + h2, x2+38,y2 + h2 + 16);
                lineSetting(line5, x2+30, y2 + h2, x2 + 22,y2 + h2 + 16);
            }
        }
        if (relationType.equals("generalization")) {
            if (y2 - y1 >= 20) {
                lineSetting(line1, x1 + 10, y1 + h1 - 2,x1 + 10,y2 - h2 - 35);
                lineSetting(line2, x1 + 10, y2 - h2 - 35, x2-10,y2 - h2 - 35);
                lineSetting(line3, x2-10, y2 - h2 - 35, x2-10,y2 - h2 - 16);
                lineSetting(line4, x2-10, y2 - h2, x2-18,y2 - h2 - 16);
                lineSetting(line5, x2-10, y2 - h2, x2 -2,y2 - h2 - 16);
                lineSetting(line6, x2-2, y2 - h2- 16, x2 -18,y2 - h2 - 16);
            } else {
                lineSetting(line1, x1 + 10, y1 - h1 + 2,x1 + 10,y2 + h2 + 35);
                lineSetting(line2, x1 + 10, y2 + h2 + 35, x2-10,y2 + h2 + 35);
                lineSetting(line3, x2-10, y2 + h2 + 35, x2-10,y2 + h2 + 16);
                lineSetting(line4, x2-10, y2 + h2, x2 -18,y2 + h2 + 16);
                lineSetting(line5, x2-10, y2 + h2, x2 -2,y2 + h2 + 16);
                lineSetting(line6, x2 -2, y2 + h2 + 16, x2 -18,y2 + h2 + 16);
            }
        }
        if (relationType.equals("aggregation")) {
            if (y2 - y1 >= 20) {
                lineSetting(line1, x1+15, y1 + h1 - 2, x1+15,y2 - h2 - 40);
                lineSetting(line2, x1+15, y2 - h2 - 40, x2,y2 - h2 - 40);
                lineSetting(line3, x2, y2 - h2 - 40, x2,y2 - h2 - 24);
                lineSetting(line4, x2, y2 - h2, x2 - 6,y2 - h2 - 12);
                lineSetting(line5, x2, y2 - h2, x2 + 6,y2 - h2 - 12);
                lineSetting(line6, x2 + 6, y2 - h2 - 12, x2,y2 - h2 - 24);
                lineSetting(line7, x2 - 6, y2 - h2 - 12, x2,y2 - h2 - 24);
            } else {
                lineSetting(line1, x1+15, y1 - h1 + 2, x1+15,y2 + h2 + 40);
                lineSetting(line2, x1+15, y2 + h2 + 40, x2,y2 + h2 + 40);
                lineSetting(line3, x2, y2 + h2 + 40, x2,y2 + h2 + 24);
                lineSetting(line4, x2, y2 + h2, x2 - 6,y2 + h2 + 12);
                lineSetting(line5, x2, y2 + h2, x2 + 6,y2 + h2 + 12);
                lineSetting(line6, x2 + 6, y2 + h2 + 12, x2,y2 + h2 + 24);
                lineSetting(line7, x2 - 6, y2 + h2 + 12, x2,y2 + h2 + 24);
            }
        }
        if (relationType.equals("composition")) {

            if (y2 - y1 >= 20) {
                lineSetting(line1, x1-10, y1 + h1 - 2, x1-10,y2 - h2 - 40);
                lineSetting(line2, x1-10, y2 - h2 - 40, x2,y2 - h2 - 40);
                lineSetting(line3, x2, y2 - h2 - 40, x2,y2 - h2);
                polygon.getPoints().setAll(x2, y2 - h2,
                        x2 + 6, y2 - h2 - 12,
                        x2, y2 - h2 - 24,
                        x2 - 6, y2 - h2 - 12);
            } else {
                lineSetting(line1, x1-10, y1 - h1 + 2, x1-10,y2 + h2 + 40);
                lineSetting(line2, x1-10, y2 + h2 + 40, x2,y2 + h2 + 40);
                lineSetting(line3, x2, y2 + h2 + 40, x2,y2 + h2);
                polygon.getPoints().setAll(x2, y2 + h2,
                        x2 + 6, y2 + h2 + 12,
                        x2, y2 + h2 + 24,
                        x2 - 6, y2 + h2 + 12);
            }

        }
    }

    /**
     * Adds relation to classes.
     */
    @FXML
    public void addRelation(ActionEvent event) {

        String fromClass;
        String relationType;
        String toClass;

        // If function was called from another function. Used in the parser.
        // Reads the type of connection, from and to.
        if (event == null)
        {
            String[] parts = classDiagram.relations.get(classDiagram.relations.size()-1).split(" ");
            fromClass = parts[0];
            relationType = parts[1];
            toClass = parts[2];
        }
        else
        {
            fromClass = choiceClass.getValue();
            relationType = relationsChose.getValue();
            toClass = choiceClassForRelation2.getValue();

            // Adds to list.
            classDiagram.relations.add(fromClass + " " + relationType + " " + toClass);
        }



        // Gets class indices and then find their coordinates.
        int id = classDiagram.getClassPosition(classDiagram.findClass(fromClass));
        int id2 = classDiagram.getClassPosition(classDiagram.findClass(toClass));
        Bounds first = MainClass.lookup("#" + id + "-class").getBoundsInParent();
        Bounds second = MainClass.lookup("#" + id2 + "-class").getBoundsInParent();

        double x1 = first.getCenterX();
        double y1 = first.getCenterY();
        double h1 = first.getHeight() / 2;

        double x2 = second.getCenterX();
        double y2 = second.getCenterY();
        double h2 = second.getHeight() / 2;

        // Creates relationship lines and sets ID.
        Line line1 = new Line();
        Line line2 = new Line();
        Line line3 = new Line();
        line1.setId("1-" + id + "-" + id2);
        line2.setId("2-" + id + "-" + id2);
        line3.setId("3-" + id + "-" + id2);

        Line line4 = new Line();
        Line line5 = new Line();
        Line line6 = new Line();
        line4.setId("4-" + id + "-" + id2);
        line5.setId("5-" + id + "-" + id2);
        line6.setId("6-" + id + "-" + id2);

        Line line7 = new Line();
        line7.setId("7-" + id + "-" + id2);
        Polygon polygon = new Polygon();
        polygon.setFill(Color.BLACK);
        polygon.setStroke(Color.BLACK);
        polygon.setId("8-" + id + "-" + id2);

        handleArrows(relationType, x1, y1, x2, y2, h1, h2, line1, line2, line3, line4, line5, line6, line7, polygon);

        MainClass.getChildren().add(0, line1);
        MainClass.getChildren().add(0, line2);
        MainClass.getChildren().add(0, line3);

        // Moves lines to the back.
        line1.toBack();
        line2.toBack();
        line3.toBack();

        MainClass.getChildren().add(0, line4);
        MainClass.getChildren().add(0, line5);
        MainClass.getChildren().add(0, line6);
        MainClass.getChildren().add(0, line7);
        MainClass.getChildren().add(0, polygon);
    }

    /**
     * Renames a class.
     */
    @FXML
    public void renameClass(ActionEvent event) {

        // Gets the name of the class to be changed.
        String renameClass = choiceClass.getValue();
        // Gets the class.
        UMLClass forRename = classDiagram.findClass(renameClass);

        // Renames.
        String newName = renameClassField.getText();

        // Checks if the class already exists.
        if (classDiagram.findClass(newName) != null)
        {
            errorMessage.setText("Error: A class with the same name already exists.");
            errorMessage.setVisible(true);
            return;
        }

        forRename.rename(newName);

        //Sets up the choice boxes. заменяет имя в списках и выбирает его.
        handleChoices(renameClass, newName, true, false);

        // For undo.
        undo.saveAction(UNDO.renameCLass, newName, renameClass);

        // Processes the class to display.
        releaseClass(forRename);

        // Changes the name in the sequence diagram if needed.
        if(umlSequence.participants.contains(renameClass))
        {
            // Sets up the choice boxes.
            handleChoices(renameClass, newName, false, false);
            // For undo.
            undo.saveAction(UNDO.renameSeq, newName, renameClass);
            umlSequence.renameParticipant(renameClass, newName);
            // Processes sequence diagram and displays it.
            releaseSequence();
        }
    }

    /**
     * Creates a .txt file and saves the diagram there in text form.
     */
    @FXML
    public void saveFile(ActionEvent event) throws IOException {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Save File");
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("TXT files (*.txt)", "*.txt"));

        File file = fileChooser.showSaveDialog(stage);
        String filePath = file.getPath();
        Writer writer = new FileWriter(filePath);

        classesToFileStr(writer);
        writer.close();
    }

    /**
     * Parses diagram into text format.
     */
    public void classesToFileStr(Writer writer) throws IOException {

        // Saves diagrams depending on the open window.
        // Class diagram.
        if( tabClass.isSelected() )
        {
            writer.write("@startuml\n\n");

            for(UMLClass umlClass:classDiagram.classes) {

                writer.write("class " + umlClass.getName() + " {\n");

                for (UMLAttribute atr : umlClass.getAttributes()) {
                    writer.write("attribute " + atr + "\n");
                }
                for (UMLOperation oper : umlClass.getOperations()) {
                    writer.write("operation " + oper + "\n");
                }

                writer.write("}\n\n");
            }
            writer.write("@enduml");
        }
        // Sequence diagram.
        else if (tabSequence.isSelected())
        {
            writer.write("@startsequml\n\n");

            for (String participant :umlSequence.getParticipants()) {
                writer.write("participant " + participant + "\n");
            }

            writer.write("\n");

            for(int i = 0; i < umlSequence.operations.size(); i++)
            {
                writer.write("operation " + umlSequence.getOperations().get(i)  + " : ");

                String[] parts = umlSequence.getFromTo().get(i).split(" ");
                writer.write(parts[0] + " to " + parts[1] + " " );
                writer.write(umlSequence.getTypeArrow().get(i) + "\n");

            }
            writer.write("\n@endsequml");
        }
    }

    /**
     * Creates a participant for the sequence diagram.
     */
    @FXML
    public void createSequenceParticipant(ActionEvent event) {
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);
        String participant_name;

        // If the input field is empty, then create a participant with the name that is selected in the class.
        if (participantName.getText().isEmpty())
        {
            if(choiceClass.getItems().size() == 0)
            {
                errorMessage.setText("Error: You didn't enter the name of the participant/select from the class.");
                errorMessage.setVisible(true);
                return;
            }
            participant_name = choiceClass.getValue();
        }
        else
        {
            // Gets the name of the participant to be created.
            participant_name = participantName.getText();
        }


        // Checks if the name is empty.
        if (participant_name.equals(""))
        {
            errorMessage.setText("Error: A participant cannot be without a name.");
            errorMessage.setVisible(true);
            return;
        }
        // CheckS if the participant already exists or not.
        else if (umlSequence.findParticipant(participant_name) != null)
        {
            errorMessage.setText("Error: A participant with the same name already exists.");
            errorMessage.setVisible(true);
            return;
        }

        // Sets up the choice boxes.
        handleChoices(null, participant_name, false, true);

        // Adds a name to the list with participants and thereby create it.
        umlSequence.participants.add(participant_name);

        // For undo.
        undo.saveAction(UNDO.createParticipant, participant_name, " ");
        // Processes sequence diagram and displays it.
        releaseSequence();

        editSeqTab.setDisable(false);
    }

    /**
     * Removes the participant and everything associated with it.
     */
    @FXML
    public void deleteParticipant(ActionEvent event)
    {
        // Gets the name of the participant to be removed.
        String participant_name = choiceParticipant.getValue();

        // Removes.
        umlSequence.deleteParticipant(participant_name);

        // Removes from all choice boxes.
        choiceParticipant.getItems().remove(participant_name);
        choiceSecondParticipant.getItems().remove(participant_name);

        // Hides the sequence editing panel.
        if (choiceParticipant.getItems().isEmpty())
            editSeqTab.setDisable(true);
        else
        {
            choiceParticipant.setValue(umlSequence.participants.get(0));
            choiceSecondParticipant.setValue(umlSequence.participants.get(0));
        }
        // Processes sequence diagram and displays it.
        releaseSequence();
    }

    /**
     * Renames a participant.
     */
    @FXML
    public void renameParticipant(ActionEvent event) {

        // Gets the name of the participant to be renamed.
        String renameParticipant = choiceParticipant.getValue();
        // Gets new name.
        String newName = renameSeqField.getText();

        // For undo.
        undo.saveAction(UNDO.renameSeq, newName, renameParticipant);

        // Checks if this participant already exists or not.
        if (umlSequence.participants.contains(newName))
        {
            errorMessage.setText("Error: A participant with the same name already exists.");
            errorMessage.setVisible(true);
            return;
        }

        // Renames.
        umlSequence.renameParticipant(renameParticipant, newName);
        // Sets up the choice boxes. заменяет имя в списке и выбирает его.
        handleChoices(renameParticipant, newName, false, false);
        // Processes sequence diagram and displays it.
        releaseSequence();
    }

    /**
     * Sets up the choice boxes.
     */
    public void handleChoices(String rename, String newName, boolean diagram, boolean add){

        // Class.
        if (diagram)
        {
            if (add)
            {
                // Adds element.
                choiceClassForRelation2.getItems().add(newName);
                choiceClass.getItems().add(newName);
            }
            else
            {
                // Replaces the name in the list.
                choiceClassForRelation2.getItems().set(choiceClassForRelation2.getItems().indexOf(rename), newName);
                choiceClass.getItems().set(choiceClass.getItems().indexOf(rename), newName);
            }
            // Selects name.
            choiceClass.setValue(newName);
            choiceClassForRelation2.setValue(newName);
        }
        // Sequence.
        else
        {
            if(add)
            {
                choiceParticipant.getItems().add(newName);
                choiceSecondParticipant.getItems().add(newName);
            }
            else
            {
                // Replaces the name in the list.
                choiceParticipant.getItems().set(choiceParticipant.getItems().indexOf(rename), newName);
                choiceSecondParticipant.getItems().set(choiceSecondParticipant.getItems().indexOf(rename), newName);
            }
            // Selects name.
            choiceParticipant.setValue(newName);
            choiceSecondParticipant.setValue(newName);
        }
    }

    /**
     * Adds operation to sequence diagram.
     */
    @FXML
    public void addOperationSeq(ActionEvent event) {
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Gets all the data to add.
        String from = choiceParticipant.getValue();
        String to = choiceSecondParticipant.getValue();
        String arrow = typeChoiceArrow.getValue();
        int place = choicePlaceSeq.getValue();

        // Handles the arrow type.
        switch (arrow){
            case "synchronous":
                arrow = "syn";
                break;
            case "asynchronous":
                arrow = "asyn";
                break;
            case "return":
                arrow = "back";
                break;
            case "creation":
                arrow = "make";
                break;
            case "destruction":
                arrow = "del";
                break;
        }

        // Checks if the entered operation is correct.
        String operationName = nameSeqOperation.getText();
        if(!operationName.matches("\\w*\\([^()]*\\)\\s*") && !arrow.equals("back")){
            errorMessage.setText("Error: Invalid operation format.");
            errorMessage.setVisible(true);
            return;
        }

        // Checks the logic of the operation.
        int index1 = umlSequence.participantIndex(from);
        int index2 = umlSequence.participantIndex(to);

        if (index1 < index2 && arrow.equals("back"))
        {
            errorMessage.setText("Error: Can't return in that direction.");
            errorMessage.setVisible(true);
            return;
        }
        else if (index1 == index2)
        {
            errorMessage.setText("Error: Can't use one participant.");
            errorMessage.setVisible(true);
            return;
        }
        else if (index1 > index2 && arrow.equals("del"))
        {
            errorMessage.setText("Error: Can't destroy in that direction.");
            errorMessage.setVisible(true);
            return;
        }
        else if (index1 > index2 && arrow.equals("make"))
        {
            errorMessage.setText("Error: Can't create in that direction.");
            errorMessage.setVisible(true);
            return;
        }


        // Adds <<create> or <<delete>> if needed.
        if(arrow.equals("make"))
        {
            umlSequence.addArrow(from, to, arrow, "<<create>>" + operationName, place);
        }
        else if (arrow.equals("del"))
        {
            umlSequence.addArrow(from, to, arrow, "<<delete>>" + operationName, place);
        }
        else
            umlSequence.addArrow(from, to, arrow, operationName, place);

        // For undo.
        undo.saveAction(UNDO.addOperationSeq, operationName, null);
        // Processes sequence diagram and displays it.
        releaseSequence();
    }

    /**
     * Removes operation from sequence diagram.
     */
    @FXML
    public void deleteSeqOperation(ActionEvent event){
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Checks if there is something to delete.
        if(operationSeqChoice.getItems().size() == 0)
        {
            errorMessage.setText("Error: No operation to delete.");
            errorMessage.setVisible(true);
            return;
        }

        // Gets name of operation and removes it everywhere.
        String operation = operationSeqChoice.getValue();
        for(int i = 0; i < umlSequence.operations.size(); i++)
        {
            if (umlSequence.operations.get(i).equals(operation))
            {
                umlSequence.operations.remove(i);
                umlSequence.type_arrow.remove(i);
                umlSequence.from_to.remove(i);

                // Processes sequence diagram and displays it.
                releaseSequence();
                return;
            }
        }
    }

    /**
     * Undo the last action.
     */
    @FXML
    public void undo(ActionEvent event) {
        errorMessage.setVisible(false);
        errorMessage.setTextFill(Color.RED);

        // Checks if there is something to undo.
        if(!undo.isAction())
        {
            errorMessage.setVisible(true);
            errorMessage.setText("There is nothing to undo.");
            return;
        }

        // For new and old name.
        Object[] names;
        // Handles last action.
        switch (undo.getLastAction()){
            case UNDO.renameSeq:
                names = undo.undoAction();

                // Checks if this participant already exists or not.
                if (umlSequence.participants.contains((String) names[1]))
                {
                    errorMessage.setText("Error: A participant with the same name already exists.");
                    errorMessage.setVisible(true);
                    return;
                }

                // Renames.
                umlSequence.renameParticipant((String) names[0],(String) names[1]);
                // Sets up the choice boxes.
                handleChoices((String) names[0], (String) names[1], false, false);
                // Processes sequence diagram and displays it.
                releaseSequence();
                break;

            case UNDO.renameCLass:
                names = undo.undoAction();

                // Gets the class.
                UMLClass forRename = classDiagram.findClass((String) names[0]);

                // Renames.
                forRename.rename((String) names[1]);

                // Sets up the choice boxes.
                handleChoices((String) names[0],(String) names[1], true, false);

                // Processes the class to display.
                releaseClass(forRename);
                break;

            case UNDO.createClass:
                names = undo.undoAction();

                // Gets the class.
                UMLClass umlClass = classDiagram.findClass((String) names[0]);

                // Get its index in the list of classes.
                int index = classDiagram.getClassPosition(umlClass);

                // Gets its index in the list of classes.
                TitledPane pane = classDiagram.findPane(index);
                MainClass.getChildren().remove(pane);

                // Removes class and panel from lists and choice boxes.
                classDiagram.classes.remove(umlClass);
                classDiagram.panes.remove(pane);
                choiceClass.getItems().remove((String) names[0]);
                choiceClassForRelation2.getItems().remove((String) names[0]);


                // Hides the class editing panel.
                if (choiceClass.getItems().isEmpty())
                    editClassTab.setDisable(true);
                else
                {
                    choiceClass.setValue(classDiagram.classes.get(0).getName());
                    choiceClassForRelation2.setValue(classDiagram.classes.get(0).getName());
                }
                break;

            case UNDO.createParticipant:
                names = undo.undoAction();

                // Removes the participant.
                umlSequence.deleteParticipant((String) names[0]);

                // Removes from all choice boxes.
                choiceParticipant.getItems().remove((String) names[0]);
                choiceSecondParticipant.getItems().remove((String) names[0]);

                // Hides the sequence editing panel.
                if (choiceParticipant.getItems().isEmpty())
                    editSeqTab.setDisable(true);
                else
                {
                    choiceParticipant.setValue(umlSequence.participants.get(0));
                    choiceSecondParticipant.setValue(umlSequence.participants.get(0));
                }

                // Processes sequence diagram and displays it.
                releaseSequence();
                break;

            case UNDO.addAttributeClass:
                names = undo.undoAction();
                errorMessage.setVisible(false);

                // If there is no attribute to remove.
                if(attributeClassChoice.getItems().size() == 0)
                {
                    errorMessage.setText("Error: No attribute to delete.");
                    errorMessage.setVisible(true);
                    return;
                }
                // Gets an attribute and selects its name, then removes it.
                UMLClass forAddAttrClass = classDiagram.findClass((String) names[1]);
                forAddAttrClass.removeAttribute((String) names[0]);

                // Processes the class to display.
                releaseClass(forAddAttrClass);

                break;

            case UNDO.addOperationClass:
                names = undo.undoAction();
                errorMessage.setVisible(false);

                // Checks if an attribute exists.
                if(operationClassChoice.getItems().size() == 0)
                {
                    errorMessage.setText("Error: No operation to delete.");
                    errorMessage.setVisible(true);
                    return;
                }
                // Gets operation and selects its name, then removes it.
                UMLClass forAddOperationClass = classDiagram.findClass((String) names[1]);
                forAddOperationClass.removeOperation((String) names[0]);

                // Processes the class to display.
                releaseClass(forAddOperationClass);
                break;

            case UNDO.addOperationSeq:
                names = undo.undoAction();
                errorMessage.setVisible(false);

                // Checks if there is something to delete.
                if(operationSeqChoice.getItems().size() == 0)
                {
                    errorMessage.setText("Error: No operation to delete.");
                    errorMessage.setVisible(true);
                    return;
                }

                // Gets name of operation and removes it everywhere.
                for(int i = 0; i < umlSequence.operations.size(); i++)
                {
                    if (umlSequence.operations.get(i).equals(names[0]))
                    {
                        umlSequence.operations.remove(i);
                        umlSequence.type_arrow.remove(i);
                        umlSequence.from_to.remove(i);

                        // Processes sequence diagram and displays it.
                        releaseSequence();
                        return;
                    }
                }
                break;
        }
    }

    /**
     * Updates the class's choice boxes.
     */
    @FXML
    void updateBoxesClass(ActionEvent event) {
        attributeClassChoice.getItems().clear();
        operationClassChoice.getItems().clear();
        for(int i = 0; i < classDiagram.classes.size(); i++)
        {
            if(classDiagram.classes.get(i).getName().equals(choiceClass.getValue()))
            {
                for (int j = 0; j < classDiagram.classes.get(i).getAttributes().size(); j++)
                {
                    attributeClassChoice.getItems().add(classDiagram.classes.get(i).getAttributes().get(j).toString());
                }
                if(attributeClassChoice.getItems().size() > 0)
                    attributeClassChoice.setValue(attributeClassChoice.getItems().get(0));

                for (int j = 0; j < classDiagram.classes.get(i).getOperations().size(); j++)
                {
                    operationClassChoice.getItems().add(classDiagram.classes.get(i).getOperations().get(j).toString());
                }
                if(operationClassChoice.getItems().size() > 0)
                    operationClassChoice.setValue(operationClassChoice.getItems().get(0));
                return;
            }
        }
    }

    /**
     * Updates the sequence's choice boxes.
     */
    @FXML
    void updateOperationDelChoiceSeq(ActionEvent event) {
        operationSeqChoice.getItems().clear();
        String participant = choiceParticipant.getValue();

        //Search by participants
        for(int i = 0; i < umlSequence.participants.size(); i++)
        {
            // Determines what name the participant was chosen with
            if (umlSequence.participants.get(i).equals(participant))
            {
                // Gets necessary operations.
                for (int a = 0; a < umlSequence.operations.size(); a++) {
                    // Takes each word and return its index in order.
                    String[] parts = umlSequence.from_to.get(a).split(" ");
                    // If FROM is name of participant.
                    if (parts[0].equals(participant))
                    {
                        String operation = umlSequence.operations.get(a);
                        operationSeqChoice.getItems().add(operation);
                    }
                }
                // Sets it.
                if(operationSeqChoice.getItems().size() > 0)
                    operationSeqChoice.setValue(operationSeqChoice.getItems().get(0));
                break;
            }
        }

        choiceOperationSeq.getItems().clear();
        for(int i = 0; i < classDiagram.classes.size(); i++)
        {
            if(classDiagram.classes.get(i).getName().equals(choiceSecondParticipant.getValue()))
            {
                for (int j = 0; j < classDiagram.classes.get(i).getOperations().size(); j++)
                {
                    choiceOperationSeq.getItems().add(classDiagram.classes.get(i).getOperations().get(j).toString());
                }
                if(choiceOperationSeq.getItems().size() > 0)
                    choiceOperationSeq.setValue(choiceOperationSeq.getItems().get(0));
                return;
            }
        }
    }

    /**
     * Add the "Main" participant to sequence diagram.
     */
    @FXML
    void addMainSeq(ActionEvent event)
    {
        umlSequence.participants.add("Main");
        // Sets up the choice boxes.
        handleChoices(null, "Main", false, true);
        // For undo.
        undo.saveAction(UNDO.createParticipant, "Main", " ");
        // Processes sequence diagram and displays it.
        releaseSequence();
        //There is no point in pressing this button anymore.
        addMainSeqButton.setDisable(true);
    }

    /**
     * Updates operation field in sequence editing panel.
     */
    @FXML
    void updateOperationFieldSeq(ActionEvent event){

        // Prepares the operation. | + boolean addAttribute(attr:UMLAttribute) -> addAttribute() |
        if (choiceOperationSeq.getItems().size() > 0)
        {
            String[] parts = choiceOperationSeq.getValue().split(" ");
            int index = parts[1].indexOf("(");
            nameSeqOperation.setText(parts[1].substring(0, index) + "()");
        }
    }
}
