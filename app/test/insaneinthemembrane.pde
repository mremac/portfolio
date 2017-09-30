boolean saveOne = false;
color c1 = color(230, 60, 60);
color c2 = color(120, 25, 25);
float thetaInc = PI/noSquares;
int spin = 0;

int noSquares = 25;
int wide = window.innerWidth;
int high = window.innerHeight;

int[] gravities = [2, 4, wide/noSquares];
int clicked = 500;
int count = 0;
int dialX = wide*0.1;
int dialY = high*0.9;
int dialW = wide - 2*dialX;
int dx = dialX + 0.05*dialW;
int sx = 1 - 2*dx/wide;
int ex = dx;
int ey = high*0.05 + dialY;
int uncrumpleX = 20;
int uncrumpleY = 20;
int[] coords = [wide/4, high/4, 3*wide/4, high/4, wide/4, 3*high/4, 3*wide/4, 3*high/4];

PVector[][] vertices = new PVector[noSquares + 1][noSquares + 1];

PVector[][] velocities = new PVector[noSquares + 1][noSquares + 1];

PVector[][] uncrumple = new PVector[noSquares + 1][noSquares + 1];

PVector[][] destination = new PVector[noSquares + 1][noSquares + 1];

void setup()
{
    size( wide, high, P3D );

    int p = wide/2;
    int q = high/2;
    int coneRad = 100;
    
    for (int j = 0; j < noSquares + 1; j++) {
        coneRad = 100 + j*10;
        for (int i = 0; i < noSquares + 1; i++) {
            thetaInc = i*1.5*PI/noSquares;
            vertices[i][j] = new PVector( i*gravities[2], j*gravities[2], 0 );
            uncrumple[i][j] = new PVector( i*gravities[2], j*gravities[2], 0 );
            velocities[i][j] = new PVector(0, 0, 0);
            destination[i][j] = new PVector(j*wide/100 + sin(thetaInc)*coneRad, q + cos(thetaInc)*coneRad, -sin(thetaInc)*10);
        }
    }
    
}

void attractTo(int cox[], int coy[], int coz[], int factor[], boolean q){
    for (int k = 0; k < cox.length; k ++){
    for (int j = 0; j < noSquares + 1; j++) {
        for (int i = 0; i < noSquares + 1; i++) {
            int a = (cox[k] - vertices[i][j].x);
            int b = (coy[k] - vertices[i][j].y);
            int d = (coz[k] - vertices[i][j].z);
            float c = sqrt(pow(a, 2) + pow(b, 2) + pow(d, 2));
            float sinthet = 0.005*a/c;
            float costhet = 0.005*b/c;
            float zthet = 0.005*d/c;
                velocities[i][j] = new PVector(velocities[i][j].x + factor[k]*sinthet, velocities[i][j].y + factor[k]*costhet, velocities[i][j].z + factor[k]*zthet);
        }
    }
    }
}

void draw()
{
    gravities = [clicked, 5*clicked, high/noSquares];

    background(c1);
    lights();
    fill(250, 50, 50, 100);
    hint(DISABLE_DEPTH_TEST);
    stroke(c2, 0);
    strokeWeight(2);
    smooth();


    attractTo([wide/2, coords[0], coords[2], coords[4], coords[6]], [high/2, coords[1], coords[3], coords[5], coords[7]], [0, 3, 3, 3, 3], [random(gravities[0]/2, gravities[0]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1])], false);
    

    // int p = wide/2*(1 + sin(spin/10));
    int q = high/2;
    int coneRad = 100;
    spin ++;
    
    for (int j = 0; j < noSquares + 1; j++) {
        coneRad = wide/5 + j*wide/60;
        for (int i = 0; i < noSquares + 1; i++) {
            thetaInc = (1.5*PI/noSquares) * (i + spin);
            int coneVelX = ((j + 5)*wide/60 + sin(thetaInc)*coneRad - destination[i][j].x)/10;
            int coneVelY = (q  + cos(thetaInc)*coneRad - destination[i][j].y)/10;
            vertices[i][j] = new PVector(vertices[i][j].x + velocities[i][j].x, vertices[i][j].y + velocities[i][j].y, vertices[i][j].z + velocities[i][j].z );
            
            uncrumpleX = vertices[0][0].x + uncrumple[i][j].x - vertices[i][j].x;
            uncrumpleY = vertices[0][0].y + uncrumple[i][j].y - vertices[i][j].y;

            int transformX = (destination[i][j].x - vertices[i][j].x)*pow(1.1, clicked/50)/110;
            int transformY = (destination[i][j].y - vertices[i][j].y)*pow(1.1, clicked/50)/110;
            int transformZ = (destination[i][j].z - vertices[i][j].z)*pow(1.1, clicked/50)/110;
            
            vertices[i][j] = new PVector(vertices[i][j].x + uncrumpleX*0.0005 + transformX, vertices[i][j].y + uncrumpleY*0.0005 + transformY, vertices[i][j].z + transformZ);
            //vertices[i][j] = new PVector(destination[i][j].x, destination[i][j].y, destination[i][j].z);
            destination[i][j] = new PVector(destination[i][j].x + coneVelX, destination[i][j].y + coneVelY, destination[i][j].z);
        }
    }
    
    for (int j = 0; j < noSquares; j ++) {
        beginShape(TRIANGLE_STRIP);
        for (int i = 0; i < noSquares + 1; i++) {
            vertex( vertices[i][j].x, vertices[i][j].y  , vertices[i][j].z );
            vertex( vertices[i][j+1].x, vertices[i][j+1].y, vertices[i][j+1].z );
        }
        endShape();
    }

    popMatrix();

    if (saveOne) {
        saveFrame("images/"+getClass().getSimpleName()+"-####.png");
        saveOne = false;
    }
    dial();
    // stroke(0);
    // strokeWeight(5);
    // line(wide - 150, 0, wide - 150, high);
}

void mousePressed() {
    if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX + 500;
    if(clicked >= wide + 450){
        clicked = wide + 450;
    }
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
    if(clicked >= wide + 450){
        clicked = wide + 450;
    }
    clicked = clicked*sx;
    if(mouseX <= dx){
      ex = dx;
    } else if(mouseX >= wide - dx){
      ex = wide - dx;
    }
  }
}

void mouseDragged() {
  if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX + 500;
    if(clicked >= wide + 450){
        clicked = wide + 450;
    }
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
    if(clicked >= wide + 450){
        clicked = wide + 450;
    }
    clicked = clicked*sx;
    if(mouseX <= dx){
      ex = dx;
    } else if(mouseX >= wide - dx){
      ex = wide - dx;
    }
  }
}

void dial(){
  noFill();
  stroke(0);
  strokeWeight(1);
  rect(dialX, dialY + high*0.03, wide - 2*dialX, high*0.04);
  noStroke();
  fill(c2);
  ellipse(ex, ey, 0.01*wide, 0.01*wide);
}

void keyPressed()
{
    if (key == 's') {
        saveOne = true;
    }
}