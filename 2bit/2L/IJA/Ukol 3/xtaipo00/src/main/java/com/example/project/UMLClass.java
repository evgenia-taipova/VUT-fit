package com.example.project;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

//Class UMLClass
public class UMLClass extends UMLClassifier {
    boolean isAbstract;
    List<UMLAttribute> attributes;
    List<UMLOperation> operations;

    //Constructor
    public UMLClass(java.lang.String name)
    {
        super(name);
        this.attributes = new ArrayList<UMLAttribute>();
        this.operations = new ArrayList<UMLOperation>();
        this.isUserDefined = true;
    }

    //Methods
    public boolean addAttribute(UMLAttribute attribute)
    {
        if (this.attributes.contains(attribute) == true)
            return false;

        if(this.attributes.add(attribute) == true)
            return true;

        return false;
    }

    public boolean addOperation(UMLOperation operation)
    {
        if (this.operations.contains(operation) == true)
            return false;

        if(this.operations.add(operation) == true)
            return true;

        return false;
    }


    public int getAttrPosition(UMLAttribute attr)
    {
        for (int i = 0; i < this.attributes.size(); i++)
        {
            if (this.attributes.get(i).equals(attr) == true)
                return i;
        }
        return -1;
    }

    public int moveAttrAtPosition(UMLAttribute attr, int pos)
    {
        if (this.attributes.contains(attr) == true)
        {
            this.attributes.remove(attr);
            this.attributes.add(pos, attr);
            return pos;
        }
        return -1;
    }

    public java.util.List<UMLAttribute> getAttributes()
    {
        return Collections.unmodifiableList(this.attributes);
    }
}