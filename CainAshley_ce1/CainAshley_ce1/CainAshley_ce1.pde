import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_function  button;
 SamplePlayer buttonSound;
 ControlP5 p5;
 Gain masterGain; 
 BiquadFilter lpFilter; 
 Glide gainGlide; 
 Glide panGlide;
 Panner masterPan;
 
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  
  p5 = new ControlP5(this);
  
  buttonSound = getSamplePlayer("mysound.wav");
  buttonSound.pause(true);
  
  //glide to change masterpan smoothly
  panGlide = new Glide(ac, -1.0, 1.0);
  masterPan = new Panner(ac,  panGlide);
  
  //glide to change mastergain smoothly
  gainGlide = new Glide(ac, 1.0, 500); 
  masterGain = new Gain(ac, 1, gainGlide);
  
  //add output of lp filter to th e gain
  masterGain.addInput(buttonSound);
  masterPan.addInput(masterGain);
  
  
  ac.out.addInput(masterPan); 

  p5.addButton("Play")
   .setSize(60, 20)
   .setPosition(60, 60)
   .setLabel("Play Music")
   .activateBy((ControlP5.RELEASE));
  
  
  p5.addSlider("GainSlider")
    .setPosition(20,20)
    .setSize(20, 200)
    .setRange(0, 100)
    .setValue(50) 
    .setLabel("Gain"); 
    
   p5.addSlider("PanSlider")
    .setPosition(140, 20)
    .setSize(20, 200)
    .setRange(-1.00, 1.00)
    .setValue(0.00) 
    .setLabel("Pan"); 
    


  ac.start();
               
}

// button handler - play button
public void Play() {
  println("play button pressed");
  //resets back to start of sound
  buttonSound.setToLoopStart();
  buttonSound.start();
}

//slider handler - for value change for gain slider
public void GainSlider(float value) { 
  println("gain slider moved: ", value);
  gainGlide.setValue(value / 50.0); 
} 

public void PanSlider(float value) { 
  panGlide.setValue(value / 1.00); 
} 


void draw() {
  background(0);  //fills the canvas with black (0) each frame
  
}
