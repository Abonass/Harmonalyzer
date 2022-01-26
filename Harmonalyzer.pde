import ddf.minim.analysis.*;
import ddf.minim.*;
PImage img;

Minim minim;  
AudioPlayer jingle;
FFT fft;
float xMargin = 205.5;
int yMargin = 200;
int oct = 1;
int xOffset = 85;

void setup() {
  size(2048, 512, P3D);
  img = loadImage("key.png");
  minim = new Minim(this);
  jingle = minim.loadFile("Asus2.mp3",4096);
  jingle.loop();
  
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  frameRate( 60 );
  img.updatePixels();
}

void draw() {
  // set background color
  background(#000000);  

  // compute FFT
  fft.forward(jingle.mix);
  oct = 1;
  // draw foreground
  stroke(#EEE8D5);
  strokeWeight(2);
  for(int i = 0; i < fft.specSize(); i++) {
    float y = fft.getBand(i) * 2.0 / fft.specSize();
    float xlog = log(float(i) / fft.specSize()) / log(10);
    
    float nextxlog = log(float(i+1) / fft.specSize()) / log(10);
    float ylog = 20 * log(y) / log(10);
    // float ylog = y*100000;
    //println(ylog);
    // adjust x/y positions to fit into window
    xlog = (3.0 + xlog) / 3.0 * width;
    ylog = height - (ylog+60)/60 * height;
    nextxlog = (3.0 + nextxlog) / 3.0 * width;
    nextxlog = (nextxlog-xlog);
    if(nextxlog < 1.0) nextxlog = 1;
    // color based on amplitude
    
   
    // line(xlog, height, xlog, ylog);
    if((oct * xMargin)< xlog-xOffset){
      oct++;
      //println(oct);
    } 
    strokeWeight(nextxlog*5);
    if(xlog < 0) stroke(color(255*0.9, (255-255*ylog/height)*0.5, (255-255*ylog/height)*0.9));
    else stroke(color((255-255*ylog/height)*5/(10-oct)-50, (255-255*ylog/height)*5/(10-oct)-50, (255-255*ylog/height)*5/(10-oct)-50));
    if(oct>2) line((xlog-xOffset-xMargin*(oct-1))*10, height-60*(oct-1), (xlog-xOffset-xMargin*(oct-1))*10, (height-30)-60*(oct-1));
    
  }
  // for(int i = 0; i <= 10; i++){
  //   stroke(color(255, 0, 0));
  //   line(204*i, height,204*i, 0); 
  // }
  image(img, 0, height-100, 2048, 100);
}
