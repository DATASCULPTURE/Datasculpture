class ShapeVisualisation {
    int nbModules;
    float moduleLength;
    float moduleWidth;
    float shapeLength;
    ArrayList<PVector> vertices;
    
    PVector origin;

    PShape shape;
    
    ShapeVisualisation(float[] values) {
        moduleLength = 10;
        moduleWidth = 10;
        nbModules = values.length;
        
        shapeLength = nbModules * moduleLength;
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

        //whole mesh
        shape = createShape(GROUP);

        //part 1
        PShape part1 = createShape(GROUP);
        part1.addChild(getTop());
        part1.addChild(getFaces());
        part1.addChild(getBottom());
        part1.addChild(getCaps());

        shape.addChild(part1);
       
        //part 2
        
        PShape part2 = createShape(GROUP);
        part2.addChild(getTop());
        part2.addChild(getFaces());
        part2.addChild(getBottom());
        part2.addChild(getCaps());


        //part2.translate(0, 0, moduleWidth);
        part2.rotateY(-PI/2);   
        part2.scale(-1,1,1); 
        shape.addChild(part2);
    

    }
    
    PShape getShape() {
        return shape;
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
            face.vertex(end.x - moduleWidth, end.y, end.z);
            face.vertex(start.x - moduleWidth, start.y, start.z);
            face.endShape(CLOSE);
            top.addChild(face);
        }

        return top;
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
        bottom.vertex(start.x- moduleWidth, start.y, start.z);
        bottom.vertex(end.x- moduleWidth, end.y, end.z);
        bottom.vertex(end.x - moduleWidth, end.y, end.z+ moduleWidth);
        bottom.vertex(start.x- moduleWidth , start.y, start.z+ moduleWidth);
        bottom.endShape(CLOSE);
        bottom.translate(0,0,-moduleWidth);

        return bottom;  
    }

    PShape getCaps(){
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
        cap.vertex(origin.x- moduleWidth, origin.y, origin.z- moduleWidth);
        cap.endShape(CLOSE);
        return cap;
    }

    
}