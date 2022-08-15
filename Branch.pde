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
        
        if (left.y > right.y) {
            this.offsetRight = left.y - right.y;
            this.origin = new PVector(left.x, left.y);
        }
        else  {
            this.offsetLeft = right.y - left.y;
            this.origin = new PVector(left.x, right.y);
        }
    }
    
    void generate() {   
        this.parseValues();
        
        shape = createShape(GROUP);
        shape.rotate(this.angle);
        shape.addChild(getFaces());
        shape.addChild(getTop());
        shape.addChild(getCaps());
    }
    
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

    PShape  getCaps() {
        PShape caps = createShape(GROUP);
            
            PShape frontCap = this.getCap();
            caps.addChild(frontCap);

            PShape backCap = this.getCap();          
            backCap.translate(0, 0, this.length);
            caps.addChild(backCap);

        return caps;
    }
    
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

    PVector getBottomRight(boolean front){
        PVector res = this.bottomRight.copy().rotate(this.angle);
        if (!front)
            res.set(res.x, res.y,res.z + this.length);
        return res;
    }
}

