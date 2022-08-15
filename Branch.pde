class Branch {
    float angle;
    float width;
    float length;
    float moduleLength;
    int nbModules;
    float[] values;
    
    ArrayList<PVector> vertices;
    PVector origin;
    
    PVector bottomLeft;
    PVector bottomRight;
    PVector bottomSpike;
    
    PShape shape;
    
    Branch(float angle, float width, float moduleLength, float[] values) {
        this.angle = angle;
        this.width = width;
        this.nbModules = values.length; 
        this.moduleLength = moduleLength;
        this.length = this.moduleLength * this.nbModules;    
        this.values = values;
    }
    
    void parseValues() {
        vertices = new ArrayList<PVector>();
        
        vertices.add(origin);
        
        PVector latestVertex = origin.copy();
        for (int i = 0; i < this.nbModules; i++) {
            float value = this.values[i];
            PVector start = new PVector(origin.x, origin.y + value, origin.z + (i * moduleLength));
            PVector end = new PVector(origin.x, origin.y + value, origin.z + (i * moduleLength) + moduleLength);
            
            if (!latestVertex.equals(start))
                vertices.add(start);
            vertices.add(end);
            
            latestVertex = end.copy();
        }
        
        vertices.add(new PVector(origin.x, origin.y, origin.z + this.length));
    }
    
    void setBottom(PVector left, PVector right) {
        this.bottomLeft = left;
        this.bottomRight = right;
        //todo
        this.origin = new PVector(left.x, max(left.y, right.y));
    }
    
    void generate() {   
        this.parseValues();
        
        shape = createShape(GROUP);
        shape.rotate(this.angle);
        shape.addChild(getFaces());
        shape.addChild(getTop());
    }
    
    PShape getFaces() {
        PShape faces = createShape(GROUP);
        
        PShape innerFace =  createShape();
        PShape outerFace =  createShape();
        
        innerFace.beginShape();
        outerFace.beginShape();
        for (int i = 0; i < vertices.size(); i++) {
            PVector v = vertices.get(i);
            innerFace.vertex(v.x, v.y, v.z);
            outerFace.vertex(v.x + this.width, v.y, v.z);
        }
        innerFace.endShape(CLOSE);
        outerFace.endShape(CLOSE);
        faces.addChild(innerFace);
        faces.addChild(outerFace);   
        
        return faces;  
    }
    
    
    
    
    PShape getFace() {
        PShape face = createShape();
        face.beginShape();
        face.vertex(this.bottomLeft.x, this.bottomLeft.y);
        face.vertex(this.bottomLeft.x, this.bottomLeft.y + 100);
        face.vertex(this.bottomRight.x, this.bottomRight.y + 100);
        face.vertex(this.bottomRight.x, this.bottomRight.y);
        face.endShape(CLOSE);
        return face;
    }
    
    PShape  getTop() {
        PShape top = createShape(GROUP);
        
        for (int i = 0; i < vertices.size() - 1; i++) {
            PShape face = createShape();
            PVector start = vertices.get(i);
            PVector end = vertices.get(i + 1);
            face.beginShape();
            face.vertex(start.x, start.y, start.z);
            face.vertex(end.x, end.y, end.z);
            face.vertex(end.x + this.width, end.y, end.z);
            face.vertex(start.x + this.width, start.y, start.z);
            face.endShape(CLOSE);
            top.addChild(face);
        }
        
        return top;
    }
}



/*
class Branch {

int nbModules;
float moduleLength;
float moduleWidth;
float shapeLength;
ArrayList<PVector> vertices;
PVector origin;

Branch(float[] values, float moduleLength, float moduleWidth) {

this.nbModules =values.length;     
this.shapeLength= nbModules * moduleLength;
this.moduleLength = moduleLength;
this.moduleWidth= moduleWidth;
origin = new PVector();    

vertices = new ArrayList<PVector>();

vertices.add(origin);

PVector latestVertex = origin.copy();
for (int i = 0; i < nbModules; i++) {
float value = values[i];
PVector start = new PVector(origin.x, origin.y + (i * moduleLength), origin.z + value);
PVector end = new PVector(origin.x, origin.y + (i * moduleLength) + moduleLength, origin.z + value);

if (!latestVertex.equals(start))
vertices.add(start);
vertices.add(end);

latestVertex = end.copy();
}

vertices.add(new PVector(origin.x, origin.y + moduleLength * nbModules, origin.z));

generate();   
}

void generate() {   
shape = createShape(GROUP);
shape.translate(moduleWidth / 2,0,0);
shape.addChild(getTop());
shape.addChild(getFaces());
shape.addChild(getBottom());
shape.addChild(getCaps());

}

PShape getShape() {
return shape;
}
*/

/**** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
PARTS
***** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * / 

/*


PShape getFaces() {
PShape faces = createShape(GROUP);

PShape innerFace =  createShape();
PShape outerFace =  createShape();

innerFace.beginShape();
outerFace.beginShape();
for (int i = 0; i < vertices.size(); i++) {
PVector v = vertices.get(i);
innerFace.vertex(v.x, v.y, v.z);
outerFace.vertex(v.x - moduleWidth, v.y, v.z);
}
innerFace.endShape(CLOSE);
outerFace.endShape(CLOSE);
faces.addChild(innerFace);
faces.addChild(outerFace);   

return faces;  
}

PShape getBottom() {

PShape bottom = createShape();
bottom.beginShape();
PVector start = vertices.get(0);
PVector end = vertices.get(vertices.size() - 1);
bottom.vertex(start.x - moduleWidth, start.y, start.z);
bottom.vertex(end.x - moduleWidth, end.y, end.z);
bottom.vertex(end.x - moduleWidth, end.y, end.z + moduleWidth);
bottom.vertex(start.x - moduleWidth , start.y, start.z + moduleWidth);
bottom.endShape(CLOSE);
bottom.translate(0,0, -moduleWidth);

return bottom;  
}

PShape getCaps() {
PShape caps = createShape(GROUP);
PShape capStart = getCap();
caps.addChild(capStart);


PShape capEnd = getCap();
capEnd.translate(0,shapeLength,0);
caps.addChild(capEnd);

return caps;
}

PShape getCap() {
PShape cap = createShape();
cap.beginShape();
cap.vertex(origin.x, origin.y, origin.z);
cap.vertex(origin.x - moduleWidth, origin.y, origin.z);
cap.vertex(origin.x - moduleWidth, origin.y, origin.z - moduleWidth);
cap.endShape(CLOSE);
return cap;
}

}

*/