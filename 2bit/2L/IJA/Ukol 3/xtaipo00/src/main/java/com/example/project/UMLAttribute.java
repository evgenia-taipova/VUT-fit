package com.example.project;

//Class UMLAttribute
public class UMLAttribute extends Element
{
    public String type;
    public String visibility;

    //Constructor
    public UMLAttribute(String name, String type, String visibility)
    {
        super(name);
        this.type = type;
        this.visibility = visibility;
    }

    //Methods

    //Get
    public String getType()
    {
        return this.type;
    }

    //Print
    public java.lang.String toString()
    {
        return String.format("%s%s %s", this.visibility, this.type, this.name);
    }
}
