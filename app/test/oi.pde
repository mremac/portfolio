
import processing.pdf.*;
import java.util.Calendar;

boolean recordPDF = false;

int formResolution = 10;
int stepSize = 2;
float distortionFactor = 1;
float initRadius = 300;
float centerX, centerY;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float[] xo = new float[formResolution];
float[] yo = new float[formResolution];
float[] xk = new float[formResolution];
float[] yk = new float[formResolution];

boolean filled = false;
boolean freeze = false;
int mode = 0;
int wide = window.innerWidth;
int high = window.innerHeight;
int count = 1;
int kicktime = 30;

int clicked = 0;
int offsetX = 0;
int offsetY = 0;
int dialX = wide*0.1;
int dialY = high*0.9;
int dialW = wide - 2*dialX;
int dx = dialX + 0.05*dialW;
int sx = 1 - 2*dx/wide;
int ex = dx;
int ey = high*0.05 + dialY;


void setup(){
  // use fullscreen size 
  size(wide, high);
  smooth();

  // init form
  centerX = width/2; 
  centerY = height/2;
  float angle = radians(360/float(formResolution));
  for (int i=0; i<formResolution; i++){
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;  
    xo[i] = cos(angle*i) * initRadius * 2;
    yo[i] = sin(angle*i) * initRadius * 2;  
    xk[i] = 0;
    yk[i] = 0;  
  }

  stroke(255, 130, 130);
  strokeWeight(3);
  background(255);
}


void draw(){
  // background(255);
  // stroke(255, 130, 130);
  noStroke();
    // ellipse(centerX, centerY, initRadius*4, initRadius*4);
  // stroke(0);
  // floating towards mouse position
  // if (mouseX != 0 || mouseY != 0) {
  //   centerX += (mouseX-centerX) * 0.01;
  //   centerY += (mouseY-centerY) * 0.01;
  // }
  
  count ++;
  int ran = floor(random(1, formResolution/3));
  float avgx = 0;
  float avgy = 0;
  for (int i=0; i<formResolution; i++){
    xk[i] = xk[i]*2.2/(count - 1);
    yk[i] = yk[i]*2.2/(count - 1);  
    // ellipse(x[i], y[i], 5, 5);
  }


for(int q = 0; q < kicktime/2; q ++){
  if(count == q){
    fill(255, 255, 255, 50);
    rect(0, 0, wide, high);
  }
}


if(count >= kicktime){

  for (int i=0; i<formResolution; i++){
    avgx += xk[i];
    avgy += yk[i];
  }
  avgx = avgx/formResolution;
  avgy = avgy/formResolution;


  count = 1;
  for(int k = 0; k < ran; k ++){
    float clickedp = clicked/wide;
    int jump = floor(random(0, formResolution));
    kicktime = random(20*(1 - clickedp), 60);
    console.log(ran + " " + jump);
    for (int i = jump - 6; i < jump + 6; i++){
      int a = i;
      if(a < 0){
        a += 15;
      }
      if(a > 15){
        a -= 15;
      }
      int direction = floor(random(-2, 1)) + 1;
      xk[a] += direction*(xo[jump] - x[a])*0.25*clickedp/(count*(abs(jump - i) + 1));
      yk[a] += direction*(yo[jump] - y[a])*0.25*clickedp/(count*(abs(jump - i) + 1));
    }
  }
}

  // calculate new points
  for (int i=0; i<formResolution; i++){
    x[i] += avgx + xk[i] + (xo[i] - x[i])*0.04 - x[i]*0.04;
    y[i] += avgy + yk[i] + (yo[i] - y[i])*0.04 - y[i]*0.04;
  }

  noStroke();
  fill(255, 130, 130);
  fill(255 - 2*count, 130, 100 + 2*count);


    beginShape();
    // start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

    // only these points are drawn
    for (int i=0; i<formResolution; i++){
      curveVertex(x[i]+centerX, y[i]+centerY);
      // stroke(255, 130, 130);
      // line(x[i] + centerX, y[i] + centerY, xo[i] + centerX, yo[i] + centerY);
      // line(x[i] + centerX, y[i] + centerY, centerX, centerY);
      // stroke(0);
    }
    curveVertex(x[0]+centerX, y[0]+centerY);

    // end controlpoint
    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();

  noFill();

  dial();
}


void mousePressed() {
    if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX;
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX*sx;
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
    clicked = mouseX;
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX*sx;
    if(mouseX <= dx){
      ex = dx;
    } else if(mouseX >= wide - dx){
      ex = wide - dx;
    }
  }
}

void dial(){
  fill(255);
  stroke(0);
  strokeWeight(1);
  rect(dialX, dialY + high*0.03, wide - 2*dialX, high*0.04);
  fill(100);
  ellipse(ex, ey, 0.01*wide, 0.01*wide);
}


void keyPressed() {
  if (keyCode == UP) stepSize++;
  if (keyCode == DOWN) stepSize--;
  stepSize = max(stepSize, 1);
  println("stepSize: " + stepSize);
}

void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == DELETE || key == BACKSPACE) background(255);

  if (key == '1') filled = false;
  if (key == '2') filled = true;
  if (key == '3') mode = 0;
  if (key == '4') mode = 1;

  // ------ pdf export ------
  // press 'r' to start pdf recording and 'e' to stop it
  // ONLY by pressing 'e' the pdf is saved to disk!
  if (key =='r' || key =='R') {
    if (recordPDF == false) {
      beginRecord(PDF, timestamp()+".pdf");
      println("recording started");
      recordPDF = true;
      stroke(0, 50);
    }
  } 
  else if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
      background(255); 
    }
  } 

  // switch draw loop on/off
  if (key == 'f' || key == 'F') freeze = !freeze;
  if (freeze == true) noLoop();
  else loop();
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


