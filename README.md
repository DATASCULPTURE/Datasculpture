# Shape generator

This program is a shape generator in Processing. 
It generates a shape from a .csv files and export it to a .stl file.
The entry point is the file ```main.pde```

---

## Usage

*  **TODO** from Processing
*  **TODO** from build

---

## Librairies 

The program uses the Peasycam library.

---

## STLExporter 

The class ```STLExporter.pde``` is used to export the generated shape into a .stl file.
This class can be used to export any PShape.
Feel free to use it in your projects if you ever need to export a PShape you created in Processing as a .stl file.
To use it in your project, simply copy the file ```STLExporter.pde``` in your Processing project's folder.
You can then create a new STLExporter object like this :
`STLExporter exporter = new STLExporter();`
`exporter.export(myPShape, filename);`
Please take a look at the file  ```main.pde``` to see it in actual use.


---

## Classes  

The game use the following classes.

* Branch 
* STLExporter 
* ShapeVisulisation

The file ```game.pde``` contains the main program.

