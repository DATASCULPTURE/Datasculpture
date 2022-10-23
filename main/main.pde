/**
* This progam generates an STL file from a .csv file
* The .csv can contain any number of rows or columns
* the first row and the first column of the .csv will be ignored.
*/

import peasy.PeasyCam;
PeasyCam cam;

PShape shape;   //the 3D shape
boolean isShapeReady = false;
float[][] values;   //the values excerpt from the .csv file
float moduleWidth =  3; 
float  moduleLength =  3;

//paths & folders
String folder = "";
String filename = "";
boolean isCsvSelected = false;
String csvPath;
boolean isStlExported = false;
String stlPath;


STLExporter exporter;
ShapeVisualisation visualisation;

public void setup() {
    size(800, 800, P3D);
    textSize(16);
    
    //change the default clipping planes of the camera
    perspective(PI / 3.0,(float)width / height,1.0,1000.0);
    cam = new PeasyCam(this, 400); 
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
    if (isShapeReady)  
        shape(shape);
    
    //draw the GUI
    cam.beginHUD();
    fill(0);    
    text("Press Spacebar to load a .csv file", 40, 40);   
    if (isShapeReady) 
        text("Press Enter to export to .stl", 40, 80);
    fill(100);    
    if (isCsvSelected)
        text(".csv loaded: " + csvPath, 40,60);
    if (isStlExported)
        text(".stl exported to: " + stlPath, 40,100);
    
    cam.endHUD(); 
    
}


void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } 
    else { 
        int index =  selection.getName().indexOf(".csv");
        if (index == -1) {
            println("File should be .csv");
        }
        else {    
            
            csvPath = selection.getAbsolutePath();
            isCsvSelected = true;
            
            //store name for export    
            filename = selection.getName().substring(0, index);
            folder = selection.getParent();
            
            //parse the data from the .csv file
            values = parseValues(csvPath);
            
            //create the PShape
            visualisation = new ShapeVisualisation(values);
            visualisation.setWidth(moduleWidth);
            visualisation.setModuleLength(moduleLength);
            
            //set the angle between two branches
            if (values.length == 2)
                visualisation.setAngle(PI / 2);
            else
                visualisation.setAngle((PI * 2) / values.length);
            
            shape = visualisation.shape;
            isShapeReady = true;   
        } 
    }
}


/**
* Parses the values from the.csv files into the values[][] array.
* Ignores the first column of each row(the country name), and the first row(the header)
*/
public float[][]parseValues(String file) {
    
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


void keyPressed() {
    switch(keyCode) {
        case 32:
            selectInput("Select a .csv file to process:", "fileSelected");
            break;
        
        case 10:
            export();
            break;
    }
}

/**
* Exports the shape as .stl in teh same folder as the .csv input file
*/
void export() {
    if (isShapeReady) {
        stlPath = folder + "/" + filename + ".stl";   
        exporter = new STLExporter();
        exporter.export(shape, stlPath);  
        isStlExported = true;   
    }   
}
