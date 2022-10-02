
/**
* Creates a PShape from the array of values.
* The PShape is made of several Branches, and two caps (front and back)
*/
class ShapeVisualisation {
    int nbBranches; 
    Branch[] branches;   
    float[][] values;
    
    PShape shape;
    
    //shapes settings
    float angle;
    float width;
    float moduleLength;
    
    //constructor with default settings
    ShapeVisualisation(float[][] values) {  
        this(values,(PI * 2) / values.length, 10, 10);
    }   
    
    //constructor with custom settings
    ShapeVisualisation(float[][] values, float angle, float width, float moduleLength) {
        this.values = values;
        this.nbBranches = values.length; 
        this.branches = new Branch[this.nbBranches];
        this.angle = min(angle,(PI * 2) / this.nbBranches);
        this.width = width;
        this.moduleLength = moduleLength;
        
        this.update();  
    }
    
    
    /***********************************************************************************************
    SETTERS
    ************************************************************************************************/
    void setAngle(float angle) {
        this.angle = min(angle,(PI * 2) / this.nbBranches);
        this.update();
    }
    
    void setWidth(float width) {
        this.width = width;
        this.update();
    }
    
    void setModuleLength(float moduleLength) {
        this.moduleLength = moduleLength;
        this.update();
    }
    
    
    /***********************************************************************************************
    SHAPES
    ************************************************************************************************/
    
    /**
    * Creates the PShape ( the actual Shape and two Caps).
    */
    void generateShape() {
        shape = createShape(GROUP);
        for (int i = 0; i < nbBranches; i++) {
            branches[i].generate();
            shape.addChild(branches[i].shape);
        }  
        shape.addChild(getCaps());
    }
    
    /**
    * Returns a PShape group containing the two caps.
    */
    PShape getCaps() {
        PShape caps = createShape(GROUP);
        
        PShape frontCap = this.getCap(true);
        caps.addChild(frontCap);
        
        PShape backCap = this.getCap(false);          
        caps.addChild(backCap);
        
        return caps;
    }
    
    /**
    * Returns one cap (either back or front) bewteen the ShapeVisualisation branches.
    */
    PShape getCap(boolean front) {
        PShape cap = createShape();
        cap.beginShape();
        
        for (int i = 0; i < nbBranches; i++) {
            PVector v = this.branches[i].getBottomRight(front);
            cap.vertex(v.x, v.y, v.z);
        }  
        cap.endShape(CLOSE);
        return cap;
    }
    
    
    /***********************************************************************************************
    INTERNALS
    ************************************************************************************************/
    
    /**
    * Generates the PShape. 
    */
    void update() {
        
        //Create empty branches
        for (int i = 0; i < this.nbBranches; i++) {
            this.branches[i] = new Branch(this.angle * i, this.width, this.moduleLength,  this.values[i]);
        }   
        
        //Compute the bottom vertices of each branch (they intersect each other)
        for (int i = 0; i < this.nbBranches; i++) {
            
            //get branches
            Branch currentBranch = this.branches[i];
            int j = (i + 1) % this.nbBranches;
            Branch nextBranch = this.branches[j];
            int k = (i - 1) < 0 ? this.nbBranches - 1 : i - 1;
            Branch previousBranch = this.branches[k];
            
            pushMatrix();
            rotate(currentBranch.angle);
            
            //intersections
            PVector innerIntersection = branchesIntersection(currentBranch, nextBranch, true);
            PVector outerIntersection = branchesIntersection(currentBranch, previousBranch, false);     
            circle(innerIntersection.x, innerIntersection.y, 5);
            circle(outerIntersection.x, outerIntersection.y, 5);
            
            //face
            line( -currentBranch.width / 2,0, -currentBranch.width / 2,100);
            line(currentBranch.width / 2,0, currentBranch.width / 2,100);
            
            currentBranch.setBottom(innerIntersection, outerIntersection);
            
            popMatrix();
        }   
        
        //Create the PShape
        this.generateShape();
    }
    
    
    /***********************************************************************************************
    UTILS
    ************************************************************************************************/
    
    /**
    * Return the intersection of two Branches as a PVertex 
    */
    PVector branchesIntersection(Branch branch1, Branch branch2, boolean inner) {
        float angle = branch2.angle - branch1.angle;
        //current
        PVector branch1Direction = new PVector(0,100);
        PVector branch2Direction = new PVector(0,100).rotate(angle);
        
        PVector branch1Start;
        PVector branch2Start;
        
        if (inner) {
            branch1Start = new PVector( -branch1.width / 2,0);
            branch2Start = new PVector(branch2.width / 2,0).rotate(branch2.angle - branch1.angle);
        }
        else {
            branch1Start = new PVector(branch1.width / 2,0);
            branch2Start = new PVector( -branch2.width / 2,0).rotate(branch2.angle - branch1.angle);
        }
        
        PVector intersection = intersect(branch1Start, branch1Direction, branch2Start, branch2Direction);
        
        return intersection;
    }
    
    /**
    * Returns the intersection of two lines defined by a point (PVertex) and a direction (PVertex)
    */
    PVector intersect(PVector P, PVector dir1, PVector Q, PVector dir2) {
        
        PVector R = dir1.copy();
        PVector S = dir2.copy();
        R.normalize();
        S.normalize();
        
        PVector QP  = PVector.sub(Q, P);
        PVector SNV = new PVector(S.y, -S.x);
        
        float t  =  QP.dot(SNV) / R.dot(SNV); 
        
        PVector X = PVector.add(P, PVector.mult(R, t));
        return X;
    }
    
}
