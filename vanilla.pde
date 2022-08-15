import peasy.PeasyCam;
PeasyCam cam;

/*
TODO
-des points en trop à l'export -> se passer des groupes??
-validation des values
-remap des values
-lecture des fichiers xl
*/

PShape shape;
float[] valuesA = {60, 30, 30, 20};
float[] valuesB = {0, 25, 15, 35};
float[] valuesC = {0, 60, 25, 35};
float[][] values = {valuesA, valuesB, valuesC};
float angle = PI ;

STLExporter exporter;
ShapeVisualisation visualisation;

public void setup() {
    size(800, 800, P3D);
    cam = new PeasyCam(this, 400);
    
    exporter = new STLExporter();
    
    
    visualisation = new ShapeVisualisation(values);
    visualisation.setWidth(10);
    visualisation.setModuleLength(10);
    visualisation.setAngle(PI/3);
    shape = visualisation.shape;
    
    exporter.export(shape, "export/file");
    
}


public void draw() {
    
    background(0);

    //axis
    strokeWeight(1);
    stroke(0,255,0);
    line(0,0,0,0,1000,0);
    stroke(255,0,0);
    line(0,0,0,1000,0, 0);
    stroke(0,0,255);
    line(0,0,0,0,0, 1000);
    
    //shape
    shape(shape);
   
}
