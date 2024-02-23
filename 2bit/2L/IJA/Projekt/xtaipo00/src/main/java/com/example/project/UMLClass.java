/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class working with attributes and operations in a class
 */
package com.example.project;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

// Class UMLClass.
public class UMLClass extends UMLClassifier {
    List<UMLAttribute> attributes;
    List<UMLOperation> operations;


    // Constructor.
    public UMLClass(java.lang.String name)
    {
        super(name);
        this.attributes = new ArrayList<UMLAttribute>();
        this.operations = new ArrayList<UMLOperation>();
        this.isUserDefined = true;
    }

    //Methods

    /**
     * Adds an attribute to the attribute list and returns whether it was successful or not.
     */
    public boolean addAttribute(UMLAttribute attribute)
    {
        if (this.attributes.contains(attribute))
            return false;
        else
        {
            this.attributes.add(attribute);
            return true;
        }
    }

    /**
     * Removes an attribute in an attribute list.
     */
    public void removeAttribute(String attributeName)
    {
        for (int i = 0; i < this.attributes.size(); i++)
        {
            if(this.attributes.get(i).getName().equals(attributeName))
            {
                this.attributes.remove(i);
                return;
            }
        }
    }

    /**
     * Removes operation in an attribute list.
     */
    public void removeOperation(String operationName)
    {
        for (int i = 0; i < this.operations.size(); i++)
        {
            if(this.operations.get(i).getName().equals(operationName))
            {
                this.operations.remove(i);
                return;
            }
        }
    }

    /**
     * Returns a list of all attributes.
     */
    public java.util.List<UMLAttribute> getAttributes()
    {
        return Collections.unmodifiableList(this.attributes);
    }

    /**
     *  Adds operation to the operation list and returns whether it was successful or not.
     */
    public boolean addOperation(UMLOperation operation)
    {
        if (this.operations.contains(operation) == true)
            return false;

        if(this.operations.add(operation) == true)
            return true;

        return false;
    }

    /**
     * Returns a list of all operations.
     */
    public java.util.List<UMLOperation> getOperations()
    {
        return Collections.unmodifiableList(this.operations);
    }
}