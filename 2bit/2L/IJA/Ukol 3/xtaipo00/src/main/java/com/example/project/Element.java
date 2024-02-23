package com.example.project;

//Class Element
public class Element extends java.lang.Object{
    java.lang.String name;

    //Constructor
    public Element(java.lang.String name)
    {
        this.name = name;
    }

    //Methods
    public java.lang.String getName()
    {
        return this.name;
    }

    public void rename(java.lang.String newName)
    {
        this.name = newName;
    }
}
