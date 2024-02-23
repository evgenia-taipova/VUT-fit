package ija.homework1.uml;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class UMLOperation extends UMLAttribute {
    List<UMLAttribute> args = new ArrayList<>();

    public UMLOperation (String name, UMLClassifier type) {
        super(name, type);
    }

    public static UMLOperation create(String name, UMLClassifier type, UMLAttribute... args) {
        UMLOperation object = new UMLOperation(name, type);
        for (UMLAttribute arg : args) {
            object.addArgument(arg);
        }
        return object;
    }

    public boolean addArgument(UMLAttribute arg) {
        if (this.args.contains(arg)){
            return false;
        }
        this.args.add(arg);
        return true;
    }

    public List<UMLAttribute> getArguments() {
        return Collections.unmodifiableList(this.args);
    }
}
