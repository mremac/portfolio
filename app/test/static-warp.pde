import processing.pdf.*;
import java.util.Calendar;

boolean recordPDF = false;

int formResolution = 40;
int stepSize = 2;
float distortionFactor = 1;
float initRadius = 300;
float centerX, centerY;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float[] xs = new float[formResolution];
float[] ys = new float[formResolution];
float[] xo = new float[formResolution];
float[] yo = new float[formResolution];
float[] xk = new float[formResolution];
float[] yk = new float[formResolution];

boolean dragging = false;
boolean filled = false;
boolean freeze = false;
int mode = 0;
int wide = window.innerWidth;
int high = window.innerHeight;
int count = 1;
int kicktime = 30;
int direction = 1;

float avgx = 0;
float avgy = 0;

float textA = 0;
float textB = 0.0;
float textC = 0.0;
float clickedp;
int randomness = 0.0;


void setup(){
  size(wide, high);
  smooth();

  // init form
  centerX = width/2; 
  centerY = height/2;
  float angle = radians(360/float(formResolution));
  for (int i=0; i<formResolution; i++){
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;  
    xs[i] = cos(angle*i) * initRadius;
    ys[i] = sin(angle*i) * initRadius;  
    xo[i] = cos(angle*i) * initRadius * 2;
    yo[i] = sin(angle*i) * initRadius * 2;  
    xk[i] = 0;
    yk[i] = 0;  
  }

  stroke(255, 130, 130);
  strokeWeight(3);
  background(255);

  $(".inputBox").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A, Command+A
            (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) || 
             // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
                 // let it happen, don't do anything
                if(e.keyCode == 38){
                  // e.preventDefault();
                  float a = parseFloat($("#" + this.id).val()) + 0.5;
                  $("#" + this.id).val(a);
                } else if(e.keyCode == 40){
                  // e.preventDefault();
                  float a = parseFloat($("#" + this.id).val()) - 0.5;
                  $("#" + this.id).val(a);
                }
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
}


void draw(){
  background(255);


  textA = parseFloat($("#inputA").val());
  textB = parseFloat($("#inputB").val());
  textC = parseFloat($("#inputC").val());
  randomness = parseInt($("#inputE").val());

  randomSeed(randomness);

  if(dragging){
    // $("#inputD").val(clickedp*10);
  }else{
    clickedp = parseFloat($("#inputD").val())/10;
    clicked = clickedp*wide;
    console.log(clickedp);
    // console.log($("#inputA"));
  }
  fill(130 + 20*textA, 200, 130 + 10*textA);

  
  noStroke();
  // ellipse(centerX, centerY, initRadius*4, initRadius*4);
  // stroke(0);
  // floating towards mouse position
  // if (mouseX != 0 || mouseY != 0) {
  //   centerX += (mouseX-centerX) * 0.01;
  //   centerY += (mouseY-centerY) * 0.01;
  // }
  
  count ++;
  
  
  avgx = 0;
  avgy = 0;

    float clickedp = $( "#slider" ).slider( "option", "value" )/100;
    clicked = clickedp*wide;

  for (int i=0; i<formResolution; i++){
    avgx += xk[i];
    avgy += yk[i];
  }
  avgx = avgx/formResolution;
  avgy = avgy/formResolution;



  count = 1;
  for(int k = 0; k < formResolution; k ++){
    // int jump = floor(random(0, formResolution));
    kicktime = 50*(1 - 0.9*clickedp);
    direction = -direction;
    float angle = radians(360/float(formResolution));

    float xquirk = random(1, randomness);
    float yquirk = random(1, randomness);

    xk[k] = 0.1*xquirk*direction*(clicked*clickedp*clickedp*cos(angle*k));
    yk[k] = 0.1*yquirk*direction*(clicked*clickedp*clickedp*sin(angle*k));
  }

  for (int i=0; i<formResolution; i++){
    x[i] = (3*textB+1)*0.1*(xs[i] + xk[i])/* + (xo[i] - x[i])*0.04 - x[i]*0.04*/;
    y[i] = (3*textC+1)*0.1*(ys[i] + yk[i])/* + (yo[i] - y[i])*0.04 - y[i]*0.04*/;
  }
  



    beginShape();
    // start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

    // only these points are drawn
    for (int i=0; i<formResolution; i++){
      curveVertex(x[i]+centerX, y[i]+centerY);
    }
    curveVertex(x[0]+centerX, y[0]+centerY);

    // end controlpoint
    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();

  noFill();

}


void mousePressed() {
  avgx = 0;
  avgy = 0;

    clicked = mouseX;
    float clickedp = clicked/wide;

  for (int i=0; i<formResolution; i++){
    avgx += xk[i];
    avgy += yk[i];
  }
  avgx = avgx/formResolution;
  avgy = avgy/formResolution;



  count = 1;
  for(int k = 0; k < formResolution; k ++){
    // int jump = floor(random(0, formResolution));
    kicktime = 50*(1 - 0.9*clickedp);
    direction = -direction;
    float angle = radians(360/float(formResolution));
    xk[k] = 0.1*direction*(clicked*clickedp*clickedp*cos(angle*k));
    yk[k] = 0.1*direction*(clicked*clickedp*clickedp*sin(angle*k));
  }

  for (int i=0; i<formResolution; i++){
    x[i] = (textB+1)*0.1*(xs[i] + xk[i])/* + (xo[i] - x[i])*0.04 - x[i]*0.04*/;
    y[i] = (textC+1)*0.1*(ys[i] + yk[i])/* + (yo[i] - y[i])*0.04 - y[i]*0.04*/;
  }
  // $( "#slider" ).slider( "option", "value", clickedp*100 );
        $("#inputD").val(clickedp*10);
}

void mouseDragged() {
        dragging = true;
  avgx = 0;
  avgy = 0;

    clicked = mouseX;
    float clickedp = clicked/wide;

  for (int i=0; i<formResolution; i++){
    avgx += xk[i];
    avgy += yk[i];
  }
  avgx = avgx/formResolution;
  avgy = avgy/formResolution;



  count = 1;
  for(int k = 0; k < formResolution; k ++){
    // int jump = floor(random(0, formResolution));
    kicktime = 50*(1 - 0.9*clickedp);
    direction = -direction;
    float angle = radians(360/float(formResolution));
    xk[k] = 0.1*direction*(clicked*clickedp*clickedp*cos(angle*k));
    yk[k] = 0.1*direction*(clicked*clickedp*clickedp*sin(angle*k));
  }

  for (int i=0; i<formResolution; i++){
    x[i] = (textB+1)*0.1*(xs[i] + xk[i])/* + (xo[i] - x[i])*0.04 - x[i]*0.04*/;
    y[i] = (textC+1)*0.1*(ys[i] + yk[i])/* + (yo[i] - y[i])*0.04 - y[i]*0.04*/;
  }
  $( "#slider" ).slider( "option", "value", clickedp*100 );
  $("#inputD").val(clickedp*10);
}

void mouseReleased(){
  dragging = false;
}


void keyPressed() {
  if (keyCode == UP) stepSize++;
  if (keyCode == DOWN) stepSize--;
  stepSize = max(stepSize, 1);
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
      recordPDF = true;
      stroke(0, 50);
    }
  } 
  else if (key == 'e' || key =='E') {
    if (recordPDF) {
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


