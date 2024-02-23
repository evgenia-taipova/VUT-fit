package ija.homework1.uml;

import java.util.ArrayList;
import java.util.List;

public class ClassDiagram extends Element {

    List<UMLClass> Class = new ArrayList<>();
    List<UMLClassifier> Classifier = new ArrayList<>();

    public ClassDiagram(String name) {
        super(name);
    }

    public UMLClass createClass(String name) {
        UMLClass object = new UMLClass(name);
        if (!(this.Class.contains(object))) {
            this.Class.add(object);
            this.Classifier.add(object);
            return object;
        }
        return null;
    }

    public UMLClassifier classifierForName(String name) {
        UMLClassifier clfier = findClassifier(name);
        if (findClassifier(name) == null) {
            clfier = UMLClassifier.forName(name);
            Classifier.add(clfier);
        }
        return clfier;
    }

    public UMLClassifier findClassifier(String name) {
        for (UMLClassifier clfier : Classifier) {
            if (name.equals(clfier.name)) {
                return clfier;
            }
        }
        return null;
    }
}
