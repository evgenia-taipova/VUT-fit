/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class is using for print
 */
package com.example.project;

// Class UMLAttribute.
public class UMLAttribute extends Element
{
    public String type;
    public String visibility;

    // Constructor.
    public UMLAttribute(String name, String type, String visibility)
    {
        super(name);
        this.type = type;
        this.visibility = visibility;
    }

    // Methods.

    // Prints.
    public java.lang.String toString()
    {
        return String.format("%s %s : %s", this.visibility, this.name,this.type);
    }
}
