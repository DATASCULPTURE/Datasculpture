/**
* A Branch is a series of vertices, extruded with a fixed width.
* All of the Branches are created by ShapeVisualisation, then the Branches are edited to fix the overlapping or fill teh gaps between them.
*/
class Branch {
    float angle;
    float width;
    float length;
    float moduleLength;
    int nbModules;
    float[] values;
    
    float offsetLeft = 0;
    float offsetRight = 0;
    
    ArrayList<PVector> vertices;
    PVector origin;
    
    PVector bottomLeft;
    PVector bottomRight;
    PVector bottomSpike;
    
    PShape shape;
    
    /**
    * The constructor takes  and array of float values which will be used to generate the different heights of the Branch
    */
    Branch(float angle, float width, float moduleLength, float[] values) {
        this.angle = angle;
        this.width = width;
        this.nbModules = values.length; 
        this.moduleLength = moduleLength;
        this.length = this.moduleLength * this.nbModules;    
        this.values = values;
    }
    
    /**
    * Creates a series of vertices in the same plane from the values array.
    */
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
    
    /**
    * Creates a series of vertices in the same plane from the values array.
    */
    void generate() {   
        this.parseValues();
        
        shape = createShape(GROUP);
        shape.rotate(this.angle);
        shape.addChild(getFaces());
        shape.addChild(getTop());
        shape.addChild(getCaps());
    }
    
    /**
    * Edits the current branch's bottom two vertices
    * Needed to remove the overlapping after having generated all of the branches.
    */
    void setBottom(PVector left, PVector right) {
        this.bottomLeft = left;
        this.bottomRight = right;
        
        if (left.y > right.y) {
            this.offsetRight = left.y - right.y;
            this.origin = new PVector(left.x, left.y);
        }
        else  {
            this.offsetLeft = right.y - left.y;
            this.origin = new PVector(left.x, right.y);
        }
    }
    
    
    /**
    * Creates the two faces of the Branch from the series of vertices
    */
    PShape getFaces() {
        PShape faces = createShape(GROUP);
        
        PShape leftFace =  createShape();
        PShape rightFace =  createShape();
        
        leftFace.beginShape();
        rightFace.beginShape();
        
        //first vertex offset
        PVector v = vertices.get(0);
        if (this.offsetLeft > 0)
            leftFace.vertex(v.x, v.y - this.offsetLeft, v.z);
        if (this.offsetRight > 0)
            rightFace.vertex(v.x + this.width, v.y - this.offsetRight, v.z);
        
        //middle vertices
        for (int i = 0; i < vertices.size(); i++) {
            v = vertices.get(i);
            leftFace.vertex(v.x, v.y, v.z);
            rightFace.vertex(v.x + this.width, v.y, v.z);
        }
        
        //last vertex offset
        v = vertices.get(vertices.size() - 1);
        if (this.offsetLeft > 0)
            leftFace.vertex(v.x, v.y - this.offsetLeft, v.z);
        if (this.offsetRight > 0)
            rightFace.vertex(v.x + this.width, v.y - this.offsetRight, v.z);
        
        leftFace.endShape(CLOSE);
        rightFace.endShape(CLOSE);
        faces.addChild(leftFace);
        faces.addChild(rightFace);   
        
        return faces;  
    }
    
    /**
    * Creates the Top pat of the Branch (the ribbon) from the vertices array.
    */
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
    
    /**
    * Returns the two caps of the Branch: the triangle facets at the bottom of the Branch on the front and the back.
    */
    PShape  getCaps() {
        PShape caps = createShape(GROUP);
        
        PShape frontCap = this.getCap();
        caps.addChild(frontCap);
        
        PShape backCap = this.getCap();          
        backCap.translate(0, 0, this.length);
        caps.addChild(backCap);
        
        return caps;
    }
    
    /**
    * Returns the front cap of the Branch: the triangle facet at the bottom of the Branch
    */
    PShape  getCap() {
        PShape cap = createShape();
        cap.beginShape();
        
        if (this.offsetLeft > 0) {
            
            cap.vertex(this.bottomLeft.x, this.bottomLeft.y);
            cap.vertex(this.bottomLeft.x, this.bottomLeft.y + this.offsetLeft);
            cap.vertex(this.bottomRight.x, this.bottomRight.y);
            
        }
        
        else if (this.offsetRight > 0) {
            
            cap.vertex(this.bottomRight.x, this.bottomRight.y);
            cap.vertex(this.bottomRight.x, this.bottomRight.y + this.offsetRight);
            cap.vertex(this.bottomLeft.x, this.bottomLeft.y);
            
        }
        
        cap.endShape(CLOSE);
        return cap;  
    }
    
    /**
    * Returns the bottom right corner of the Branch (either from the front or the back)
    * Needed to compute the intersection between two Branches
    */
    PVector getBottomRight(boolean front) {
        PVector res = this.bottomRight.copy().rotate(this.angle);
        if (!front)
            res.set(res.x, res.y,res.z + this.length);
        return res;
    }
}
