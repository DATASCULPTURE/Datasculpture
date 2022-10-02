/**
* This progam generates an STL file from a .csv file
* The .csv can contain any number of rows or columns
* the first row and the first column of the .csv will be ignored.
*/

import peasy.PeasyCam;
PeasyCam cam;

PShape shape;   //the 3D shape
float[][] values;   //the values excerpt from the .csv file
float moduleWidth =  3; 
float  moduleLength =  3;
float angle = PI / 2;   //the angle beteween two branches of the shape


STLExporter exporter;
ShapeVisualisation visualisation;

public void setup() {
    size(800, 800, P3D);
    
    //change the default clipping planes of the camera
    perspective(PI / 3.0,(float)width / height,1.0,1000.0);
    cam = new PeasyCam(this, 400);
    
    //parse the data from the .csv file
    values = parseValues("data.csv");
    
    //create the PShape
    visualisation = new ShapeVisualisation(values);
    visualisation.setWidth(moduleWidth);
    visualisation.setModuleLength(moduleLength);
    visualisation.setAngle(angle);
    shape = visualisation.shape;
    
    //export the PShape
    exporter = new STLExporter();
    exporter.export(shape, "export/result");   
}


public void draw() {
    
    background(210);
    
    //draw axis
    strokeWeight(1);
    stroke(0,255,0);
    line(0,0,0,0,1000,0);
    stroke(255,0,0);
    line(0,0,0,1000,0, 0);
    stroke(0,0,255);
    line(0,0,0,0,0, 1000);
    
    //draw the PShape
    shape(shape);
}


/**
* Parses the values from the .csv files into the values[][] array.
* Ignores the first column of each row (the country name), and the first row (the header)
*/
public float[][] parseValues(String file) {
    
    Table table = loadTable(file, "header");    //file includes a header
    
    int rowCount = table.getRowCount();  
    int columnCount = table.getColumnCount();  
    
    float[][] values = new float[columnCount - 1][rowCount];
    
    for (int i = 0; i < rowCount; i++) {    
        TableRow row = table.getRow(i);
        for (int j = 0; j <  columnCount - 1; j++) 
            values[j][i] = row.getFloat(j + 1);
    } 
    
    return values;       
}
