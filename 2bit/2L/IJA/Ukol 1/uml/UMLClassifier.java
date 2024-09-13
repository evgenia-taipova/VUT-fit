package ija.homework1.uml;

public class UMLClassifier extends Element {
    boolean isUserDefined = false;
    static UMLClassifier Classifier;

    public UMLClassifier(String name, boolean isUserDefined) {
        super(name);
        this.isUserDefined = isUserDefined;
    }

    public UMLClassifier(String name) {
        super(name);
    }

    public static UMLClassifier forName(String name) {
        return Classifier = new UMLClassifier(name);
    }

    public boolean isUserDefined() {
        return isUserDefined;
    }

    public String toString() {
        return String.format("%s(%s)", this.name, this.isUserDefined);
    }
}
