/**
 * @author Taipova Evgeniya - xtaipo00
 * @author Kovalets Vladyslav - xkoval21
 *
 * Class for working with sequence diagram
 */
package com.example.project;

import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

public class UMLSequence extends Element{
    List<String> participants;
    List<String> operations;
    List<String> from_to;
    List<String> type_arrow;

    //Constructor
    public UMLSequence(java.lang.String name)
    {
        super(name);
        this.participants = new ArrayList<String>();
        this.operations = new ArrayList<String>();
        this.from_to = new ArrayList<String>();
        this.type_arrow = new ArrayList<String>();
    }

    /**
     *  Checks if a participant with the given name exists.
     */
    public String findParticipant(String name)
    {
        String object;
        for (int i = 0; i < participants.size(); i++)
        {
            object = this.participants.get(i);
            if(object.equals(name))
                return object;
        }
        return null;
    }

    /**
     * Completely deletes all data about the participant.
     */
    public void deleteParticipant(String name){

        this.participants.remove(name);

        for (int i = 0; i < this.from_to.size(); i++ ) {

            if (this.from_to.get(i).contains(name)) {
                this.from_to.remove(i);
                this.operations.remove(i);
                this.type_arrow.remove(i);
                i--;
            }
        }
    }

    /**
     * Changes the name of the participant. Expects old and new name.
     */
    public void renameParticipant(String name, String newName) {
        for(int i = 0; i < this.participants.size(); i++) {
            if (this.participants.get(i).equals(name)) {
                this.participants.set(i, newName);
            }
        }

        for(int i = 0; i < this.from_to.size(); i++) {

            if (this.from_to.get(i).contains(name)){

                String[] parts = this.from_to.get(i).split(" ");
                if (parts[0].equals(name))
                {
                    this.from_to.set(i, newName + " " + parts[1]);
                }
                else this.from_to.set(i, parts[0] + " " + newName);
            }
        }
    }

    /**
     * Adds operations data.
     */
    public void addArrow(String from, String to, String type, String operationName, Integer place)
    {
        // AddS the operation to the right place.
        this.operations.add(place - 1 , operationName);
        // From which participant to which.
        this.from_to.add(place - 1 , from + " " + to);
        // Arrow type.
        this.type_arrow.add(place - 1, type);
    }

    /**
     * Takes the name of a participant and returns its index in the list of participants.
     * If it doesn't exist, it returns -1
     */
    public int participantIndex(String name){
        for(int i = 0; i < this.participants.size(); i++)
        {
            if(this.participants.get(i).equals(name))
                return i;
        }
        return -1;
    }

    /**
     * Returns a list of all participants.
     */
    public List<String> getParticipants()
    {
        return Collections.unmodifiableList(this.participants);
    }

    /**
     * Returns a list of all operations.
     */
    public List<String> getOperations()
    {
        return Collections.unmodifiableList(this.operations);
    }

    /**
     * Returns a list of all operations from to.
     */
    public List<String> getFromTo()
    {
        return Collections.unmodifiableList(this.from_to);
    }

    /**
     * Returns a list of all arrow types.
     */
    public List<String> getTypeArrow()
    {
        return Collections.unmodifiableList(this.type_arrow);
    }
}

