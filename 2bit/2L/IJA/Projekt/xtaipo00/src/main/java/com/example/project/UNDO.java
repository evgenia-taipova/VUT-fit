/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class for UNDO
 */
package com.example.project;

import java.util.ArrayList;
import java.util.List;

public class UNDO {
    List<String> actions;
    List<String> newNames;
    List<String> oldNames;

    final public static String renameSeq = "renameSeq";
    final public static String renameCLass = "renameClass";
    final public static String createClass = "createClass";
    final public static String createParticipant = "createParticipant";
    final public static String addAttributeClass = "addAttributeClass";
    final public static String addOperationClass = "addOperationClass";
    final public static String addOperationSeq = "addOperationSeq";

    public UNDO()
    {
        this.actions = new ArrayList<String>();
        this.newNames = new ArrayList<String>();
        this.oldNames = new ArrayList<String>();
    }

    /**
     * Returns the name of the last saved action. If there is none, then it returns null.
     */
    public String getLastAction()
    {
        if (actions.size() != 0)
            return actions.get(actions.size() - 1);
        else
            return null;
    }

    /**
     * Saves the action and its required parameters.
     */
    public void saveAction(String action, String newName, String oldName)
    {
        actions.add(action);
        oldNames.add(oldName);
        newNames.add(newName);
    }

    /**
     * Returns an object with the new and old name for the action.
     */
    public Object[] undoAction()
    {
        actions.remove(actions.size()-1);

        // They always have the same index.
        int index = newNames.size() - 1;
        String newN = newNames.get(index);
        String oldN = oldNames.get(index);

        // Removes the last elements.
        newNames.remove(index);
        oldNames.remove(index);

        return new Object[]{newN, oldN};
    }

    /**
     * Checks if there are saved actions.
     */
    public boolean isAction(){
        return actions.size() != 0;
    }
}
