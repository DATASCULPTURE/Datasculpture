import peasy.PeasyCam;
PeasyCam cam;

PShape shape;

STLExporter exporter;
ShapeVisualisation visualisation;

public void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 400);

  exporter = new STLExporter();

  float[] values = {60, 30, 30, 20};
  visualisation = new ShapeVisualisation(values);
  shape = visualisation.getShape();

  exporter.export(shape, "export/file");

}


public void draw() {
  background(0);
  strokeWeight(2);
  stroke(0,0,255);
  line(0,0,0,0,1000,0);

  stroke(0,255,0);
  line(0,0,0,1000,0, 0);

  shape(shape);
   
}
