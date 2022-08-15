class ShapeVisualisation {
    int nbBranches; 
    Branch[] branches;   
    float[][] values;

    PShape shape;
    
    //shapes settings
    float angle;
    float width;
    float moduleLength;
    
    //default parameters
    ShapeVisualisation(float[][] values) {  
        this(values,(PI * 2) / values.length, 10, 10);
    }   
    
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
    void getShape() {
        shape = createShape(GROUP);
        for (int i = 0; i < nbBranches; i++) {
            branches[i].generate();
            shape.addChild(branches[i].shape);
        }  
        shape.addChild(getCaps());
    }
    
    
    PShape getCaps() {
        PShape caps = createShape(GROUP);
        
        PShape frontCap = this.getCap(true);
        caps.addChild(frontCap);
        
        
        PShape backCap = this.getCap(false);          
        caps.addChild(backCap);
        
        
        return caps;
    }
    
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
        this.getShape();
    }
    
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