package ija.homework1.uml;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class UMLClass extends UMLClassifier {
    boolean isAbstract = false;
    List<UMLAttribute> attrs = new ArrayList<>();
    List<UMLOperation> opers = new ArrayList<>();

    public UMLClass(String name) {
        super(name);
        this.isUserDefined = true;
    }

    public boolean isAbstract() {
        return isAbstract;
    }

    public void setAbstract(boolean isAbstract) {
        this.isAbstract = isAbstract;
    }

    public boolean addAttribute(UMLAttribute attr) {
        if (this.attrs.contains(attr)) {
            return false;
        }
        this.attrs.add(attr);
        return true;
    }

    public int getAttrPosition(UMLAttribute attr) {
        for (int position = 0; position < this.attrs.size(); position++) {
            if (this.attrs.get(position).equals(attr))
                return position;
        }
        return -1;
    }

    public int moveAttrAtPosition(UMLAttribute attr, int pos) {
        if (!(this.attrs.contains(attr))) {
            return -1;
        }
        this.attrs.remove(attr);
        this.attrs.add(pos, attr);
        return 0;
    }

    public List<UMLAttribute> getAttributes() {
        return Collections.unmodifiableList(this.attrs);
    }
}
