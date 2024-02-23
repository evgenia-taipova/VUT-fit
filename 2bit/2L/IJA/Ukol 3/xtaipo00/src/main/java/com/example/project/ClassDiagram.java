package com.example.project;
import java.util.List;
import java.util.ArrayList;

//Class ClassDiagram
public class ClassDiagram extends Element
{
    List<UMLClass> classes;
    List<UMLClassifier> classifiers;

    //Constructor
    public ClassDiagram(java.lang.String name)
    {
        super(name);
        this.classes = new ArrayList<UMLClass>();
        this.classifiers = new ArrayList<UMLClassifier>();
    }

    //Methods
    public UMLClass createClass(java.lang.String name)
    {
        UMLClass object = new UMLClass(name);
        if (this.classes.contains(object) == true)
            return null;
        this.classes.add(object);
        this.classifiers.add(object);
        return object;
    }

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
}
