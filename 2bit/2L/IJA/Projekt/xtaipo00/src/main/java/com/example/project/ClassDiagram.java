/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class contains methods for processing Class Diagrams
 */

package com.example.project;
import javafx.scene.control.TitledPane;
import javafx.scene.layout.AnchorPane;
import javafx.scene.shape.Line;

import java.util.List;
import java.util.ArrayList;

// Class ClassDiagram.
public class ClassDiagram extends Element
{
    List<UMLClass> classes;
    List<String> relations;
    List<UMLClassifier> classifiers;
    List<TitledPane> panes;
    int idCounter = 0;

    // Constructor.
    public ClassDiagram(java.lang.String name)
    {
        super(name);
        this.classes = new ArrayList<UMLClass>();
        this.relations = new ArrayList<String>();
        this.classifiers = new ArrayList<UMLClassifier>();
        this.panes = new ArrayList<TitledPane>();
    }

    //Methods

    /**
     * Takes a name and creates a class with that name. Returns null if such a class has already been created.
     * Creates a panel for this class and adds an id to it.
     */
    public UMLClass createClass(java.lang.String name)
    {
        UMLClass object = new UMLClass(name);
        if (this.classes.contains(object))
            return null;
        this.classes.add(object);
        this.classifiers.add(object);

        TitledPane titledPane = new TitledPane();
        titledPane.setId(idCounter + "-class");
        idCounter++;
        this.panes.add(titledPane);

        return object;
    }

    /**
     * Finds a classifier by name in the diagram.
     */
    public UMLClassifier findClassifier(java.lang.String name)
    {
        UMLClassifier object;
        for (int i = 0; i < classifiers.size(); i++)
        {
            object = this.classifiers.get(i);
            if(object.name.equals(name) == true)
                return object;
        }
        return null;
    }

    /**
     * Finds a classifier by name in the diagram. If it does not exist,
     * it creates an instance of the Classifier class that represents a classifier that is not captured in the diagram.
     */
    public UMLClassifier classifierForName(java.lang.String name)
    {
        UMLClassifier object = findClassifier(name);
        if (object == null)
        {
            object = UMLClassifier.forName(name);
            classifiers.add(object);
        }
        return object;
    }


    /**
     * Finds a class by name in the diagram and returns it. If not found, then returns null.
     */
    public UMLClass findClass(java.lang.String name)
    {
        UMLClass object;
        for (int i = 0; i < classes.size(); i++)
        {
            object = this.classes.get(i);
            if(object.name.equals(name) == true)
                return object;
        }
        return null;
    }

    /**
     * Finds a pane by index and returns it.
     */
    public TitledPane findPane(int index)
    {
        TitledPane object;
        object = this.panes.get(index);
        return object;
    }

    /**
     * Finds the position of the class in the list.
     */
    public int getClassPosition(UMLClass umlClass)
    {
        for (int i = 0; i < this.classes.size(); i++)
        {
            if (this.classes.get(i).equals(umlClass))
                return i;
        }
        return -1;
    }

    /**
     * Removes relations from lists and delete arrow.
     */
    //todo
    public void removeRelations(String className, ClassDiagram classDiagram, AnchorPane MainClass)
    {
        for(int i = 0; i < this.relations.size(); i++)
        {
            String[] parts = this.relations.get(i).split(" ");
            if(parts[0].equals(className) || parts[2].equals(className))
            {
                int id = classDiagram.getClassPosition(classDiagram.findClass(parts[0]));
                int id2 = classDiagram.getClassPosition(classDiagram.findClass(parts[2]));

//                Bounds first = MainClass.lookup("#" + id + "-class").getBoundsInParent();
//                Bounds second = MainClass.lookup("#" + id2 + "-class").getBoundsInParent();
                Line line1 = (Line) MainClass.lookup("#1-" + id + "-" + id2);
                Line line2 = (Line) MainClass.lookup("#2-" + id + "-" + id2);
                Line line3 = (Line) MainClass.lookup("#3-" + id + "-" + id2);
                line1.setVisible(false);
                line2.setVisible(false);
                line3.setVisible(false);

                this.relations.remove(i);
            }
        }
    }
}
