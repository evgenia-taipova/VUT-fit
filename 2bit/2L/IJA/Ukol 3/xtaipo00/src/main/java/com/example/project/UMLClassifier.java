package com.example.project;

//Class UMLClassifier
public class UMLClassifier extends Element {
    boolean isUserDefined;

    //Constructors
    public UMLClassifier(java.lang.String name, boolean isUserDefined)
    {
        super(name);
        this.isUserDefined = isUserDefined;
    }

    public UMLClassifier(java.lang.String name)
    {
        super(name);
        this.isUserDefined = false;
    }

    //Methods
    public static UMLClassifier forName(java.lang.String name)
    {
        UMLClassifier object = new UMLClassifier(name);
        return object;
    }

    public boolean isUserDefined()
    {
        return isUserDefined;
    }

    public java.lang.String toString()
    {
        return String.format("%s(%s)", this.name, this.isUserDefined);
    }

}
