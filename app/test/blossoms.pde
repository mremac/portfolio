boolean saveOne = false;
color c1 = color(230, 60, 60);
color c2 = color(120, 25, 25);

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
int[] coords = [random(0, wide/2), random(0, high/2), random(wide/2, wide), random(0, high/2), random(0, wide/2), random(high/2, high), random(wide/2, wide), random(high/2, high)];

PVector[][] vertices = new PVector[noSquares + 1][noSquares + 1];

PVector[][] velocities = new PVector[noSquares + 1][noSquares + 1];

PVector[][] uncrumple = new PVector[noSquares + 1][noSquares + 1];

void setup()
{
    size( wide, high, P3D );

    int p = 0;
    int q = 0;
    
    for (int j = 0; j < noSquares + 1; j++) {
        for (int i = 0; i < noSquares + 1; i++) {
            vertices[i][j] = new PVector( i*gravities[2] + p, j*gravities[2] + q, 0 );
            uncrumple[i][j] = new PVector( i*gravities[2], j*gravities[2], 0 );
            velocities[i][j] = new PVector(0, 0, 0);
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
    gravities = [0.0005*pow(2.5, (clicked - wide/2)/100), 0.0001*clicked*clicked, high/noSquares];

    background(c1);
    lights();
    fill(250, 50, 50, 100);
    hint(DISABLE_DEPTH_TEST);
    stroke(c2, 0);
    strokeWeight(2);
    smooth();


    attractTo([wide/2, coords[0], coords[2], coords[4], coords[6]], [high/2, coords[1], coords[3], coords[5], coords[7]], [0, 3, 3, 3, 3], [random(gravities[0]/2, gravities[0]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1]), random(gravities[1]/2, gravities[1])], false);
    
    
    

for (int j = 2; j < noSquares - 1; j++) {
        for (int i = 2; i < noSquares - 1; i++) {
            vertices[i][j] = new PVector(vertices[i][j].x + velocities[i][j].x, vertices[i][j].y + velocities[i][j].y, vertices[i][j].z + velocities[i][j].z );
            
            uncrumpleX = uncrumple[i][j].x - vertices[i][j].x;
            uncrumpleY = uncrumple[i][j].y - vertices[i][j].y;
            
            vertices[i][j] = new PVector(vertices[i][j].x + uncrumpleX*0.005*(1 - (clicked/(wide + 500))), vertices[i][j].y + uncrumpleY*0.005*(1 - (clicked/(wide + 500))), vertices[i][j].z);
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
}

void mousePressed() {
    if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX + 500;
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
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
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
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