package com.example.project;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

//Class UMLOperation
public class UMLOperation extends Element {
    public String type;
    public String visibility;

    //Constructor
    public UMLOperation(String name, String type, String visibility) {
        super(name);
        this.type = type;
        this.visibility = visibility;
    }

    public java.lang.String toString()
    {
        return String.format("%s%s %s", this.visibility, this.type, this.name);
    }

}
