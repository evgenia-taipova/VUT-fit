/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 */
package com.example.project;

// Class UMLOperation.
public class UMLOperation extends Element {
    public String type;
    public String visibility;

    // Constructor.
    public UMLOperation(String name, String type, String visibility) {
        super(name);
        this.type = type;
        this.visibility = visibility;
    }

    // Methods.

    /**
     * Prints in correct form.
     */
    public java.lang.String toString()
    {
        if(this.type.equals(""))
            return String.format("%s %s", this.visibility, this.name);

        return String.format("%s %s : %s", this.visibility, this.name, this.type);
    }

}
