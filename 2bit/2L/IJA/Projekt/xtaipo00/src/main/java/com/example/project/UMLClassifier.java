/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class using for creating a classifier and returning it
 */
package com.example.project;

// Class UMLClassifier.
public class UMLClassifier extends Element {
    boolean isUserDefined;

    // Constructors.
    public UMLClassifier(java.lang.String name)
    {
        super(name);
        this.isUserDefined = false;
    }

    // Methods.

    /**
     * Creates a classifier and returns it
     */
    public static UMLClassifier forName(java.lang.String name)
    {
        return new UMLClassifier(name);
    }


    public java.lang.String toString()
    {
        return String.format("%s(%s)", this.name, this.isUserDefined);
    }
}
