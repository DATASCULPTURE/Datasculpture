class STLExporter { 
    
    float ypos, speed; 
    PShape tesselated;
    PrintWriter writer;
    String name;
    
    STLExporter() {}
    
    void export(PShape shape, String filename) {
        
        //check filename
        int index = filename.toLowerCase().indexOf(".stl");
        if (index == -1) {
            name = filename;
            filename += ".stl";
        }
        else {
            name = filename.substring(0, index);
        }
        
        //Create writer
        writer = createWriter(filename); 
        
        
        //get Tesselated PShape
        this.tesselated = shape.getTessellation().getChild(0);
        
        writeHeader();      
        writeShape(this.tesselated); 
        writeFooter();  
        
        //close writer   
        writer.flush();
        writer.close();
        
    }
    
    void writeShape(PShape shape) {
        if (shape.getVertexCount() % 3 == 0) { 
            for (int i = 0; i < shape.getVertexCount(); i += 3) {
                writeNormal(shape.getNormal(i));
                
                writer.println("outer loop");
                for (int j = i; j < i + 3; j++) {
                    writeVertex(shape.getVertex(j));
                }
                writer.println("endloop");
                writer.println("endfacet");
            }           
        }       
    }
    
    void writeHeader() {
        writer.println("solid " + name);
    }
    
    void writeFooter() {
        writer.println("endsolid " + name);
    }
    
    void writeVertex(PVector vertex) {
        writer.println("vertex " + vertex.x + " " + vertex.y + " " + vertex.z);
    }
    
    void writeNormal(PVector normal) {
        writer.println("facet normal " + normal.x + " " + normal.y + " " + normal.z);
    }
    
    
} 



