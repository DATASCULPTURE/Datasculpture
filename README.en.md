# Shape generator 

This program is a shape generator in Processing.  
It generates a shape from a .csv file and exports it to a .stl file.  
The entry point is the file ```main.pde```  

---

## Librairies 

The program uses the Peasycam library. 

---

## Usage

Clone the project by running `TODO`  
Open and launch the project from the Processing IDE. (You may have to import the Peasycam library in your sketch to launch the project, go to Sketch -> Import Library -> Peasycam)  
When the program is running, you can press *spacebar* to choose a .csv file to import.  
When the 3D shape is gnereated, you can export it to .stl by pressing *enter*.  

By default, the program des not take into accout the first row and the first column of the .csv file when parsing the data.

---

## STLExporter 

The class ```STLExporter.pde``` is used to export the generated shape into a .stl file. This class can be used to export any PShape.  
Feel free to use it in your projects if you ever need to export a PShape you created in Processing as a .stl file. 


To use it in your project, simply copy the file ```STLExporter.pde``` in your Processing project's folder.  
You can then create a new STLExporter object like this :  
`STLExporter exporter = new STLExporter();`  
`exporter.export(myPShape, filename);`  


Please take a look at the file  ```main.pde``` to see it in actual use.


---

## Classes  

The program uses the following classes.

* Branch 
* STLExporter 
* ShapeVisulisation

The file ```main.pde``` contains the main program.
