package edu.unal.main.Data;

/**
 * Entity class
 * Created by yesika on 08/05/2015.
 */
public class EcgObject {

    private String beatTypes [];
    private String signalSamples [];
    private int fiducialPoints [];

    public String[] getBeatTypes() {
        return beatTypes;
    }

    public void setBeatTypes(String text) {
       this.beatTypes = text.split(" ");
    }

    public String[] getSignalSamples() {
        return signalSamples;
    }

    public void setSignalSamples(String text) {
        this.signalSamples = text.split(" ");
    }

    public int[] getFiducialPoints() {
        return fiducialPoints;
    }

    public void setFiducialPoints(String text) {
        //this.fiducialPoints = fiducialPoints;
    }

 }
