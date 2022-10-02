/**
* A STL exporter for a PShape.
* A STL file consist essentially in a series of triangle facets represented by three vertices and a normal.
* It uses the getTessellation() method of the PShape class to convert the original PShape into a series of triangle facets, 
* and then the getNormal() method of the PShape class on each facet to get the normal.
*/

class STLExporter { 
    
    PrintWriter writer;
    String name;
    
    /**
    * Creates a new STL exporter.
    */
    STLExporter() {}
    
    /**
    * Exports the specified PShape as a STL file.
    * @param shape The PShape to export
    * @param filename The name of the STL file
    */
    void export(PShape shape, String filename) {
        
        //remove extension if it exists
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
        
        //Write the STL data
        writeHeader();      
        writeShape(shape); 
        writeFooter();  
        
        //Close writer   
        writer.flush();
        writer.close();    
    }
    
    /**
    * Tesselates the PShape, then writes the vertices data.
    * @param shape The PShape to write the vertices data of.
    */
    void writeShape(PShape shape) {
        
        //Get tesselated shape
        PShape tesselated = shape.getTessellation().getChild(0);
        
        //Write vertices
        if (tesselated.getVertexCount() % 3 == 0) { 
            for (int i = 0; i < tesselated.getVertexCount(); i += 3) {
                writeNormal(tesselated.getNormal(i));
                
                writer.println("outer loop");
                for (int j = i; j < i + 3; j++) {
                    writeVertex(tesselated.getVertex(j));
                }
                writer.println("endloop");
                writer.println("endfacet");
            }           
        }       
    }
    
    /**
    * Writes one vertex data.
    * @param vertex The PVertex to write the data of
    */
    void writeVertex(PVector vertex) {
        writer.println("vertex " + vertex.x + " " + vertex.y + " " + vertex.z);
    }
    
    /**
    * Writes one normal data.
    * @param normal The normal (as a PVertex) to write the data of
    */
    void writeNormal(PVector normal) {
        writer.println("facet normal " + normal.x + " " + normal.y + " " + normal.z);
    }
    
    /**
    * Writes the header of the STL file.
    */
    void writeHeader() {
        writer.println("solid " + name);
    }
    
    /**
    * Writes the footer of the STL file.
    */
    void writeFooter() {
        writer.println("endsolid " + name);
    } 
} 



