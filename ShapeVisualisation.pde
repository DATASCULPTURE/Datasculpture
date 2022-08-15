class ShapeVisualisation {
    int nbBranches; 
    Branch[] branches;   
    PVector origin;
    PShape shape;
    float angle;
    
    ShapeVisualisation(float[][] values, float angle) {
        
        nbBranches = values.length;
        origin = new PVector();    
        branches = new Branch[nbBranches];
        angle = min(angle,(PI * 2) / nbBranches);
        
        
        for (int i = 0; i < nbBranches; i++) {
            branches[i] = new Branch(angle * i, 20.0, 20,  values[i]);
        }   
        
        ///get starting points
        for (int i = 0; i < nbBranches; i++) {
            
            //get branches
            Branch currentBranch = this.branches[i];
            int j = (i + 1) % nbBranches;
            Branch nextBranch = this.branches[j];
            int k = (i - 1) < 0 ? nbBranches - 1 : i - 1;
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
        
        
        shape = createShape(GROUP);
        //branches
        
        for (int i = 0; i < nbBranches; i++) {
            branches[i].generate();
            shape.addChild(branches[i].shape);
        }  
        
        //cap
        shape.addChild(getCap());
        
        
    }

    
    PShape getCap() {
        PShape cap = createShape();
        cap.beginShape();

        for (int i = 0; i < nbBranches; i++) {
            PVector v = this.branches[i].bottomRight.rotate(this.branches[i].angle);
            cap.vertex(v.x, v.y);

        }  
        cap.endShape(CLOSE);
        return cap;
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