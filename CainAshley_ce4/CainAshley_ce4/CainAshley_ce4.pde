//Ashley Cain CE4

import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_function  button;

ControlP5 p5;
SamplePlayer music; 
// store the length, in ms, of the music SamplePlayer
double musicLength;
 
 
// endListener to detect beginning/end of music playback, rewind, FF
Bead musicEndListener;

 
Glide musicRateGlide; 
 
SamplePlayer uiPlay; 
SamplePlayer stop; 
SamplePlayer fastForward; 
SamplePlayer rewind;
SamplePlayer reset; 

 
 
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  p5 = new ControlP5(this);
 
  music = getSamplePlayer("guitarSong.wav"); 

  // get the length of the music sample to use in tape deck function button callbacks
  musicLength = music.getSample().getLength(); 
  

  
  // create music playback rate Glide, set to 0 initially or music will play on startup
  musicRateGlide = new Glide(ac, 0, 500);
  // use rateGlide to control music playback rate
  // notice that music.pause(true) is not needed since
  // we set the initial playback rate to 0
  music.setRate(musicRateGlide);

  // create all of your button sound effect SamplePlayers
  uiPlay = getSamplePlayer("PlaySound.wav"); 
  uiPlay.pause(true); 
  stop = getSamplePlayer("stopSound.wav"); 
  stop.pause(true); 
  reset = getSamplePlayer("stopSound.wav"); 
  reset.pause(true); 
  fastForward = getSamplePlayer("fastForwardSound.wav"); 
  fastForward.pause(true); 
  rewind = getSamplePlayer("fastForwardSound.wav"); 
  rewind.pause(true);
  
  // and connect them into a UGen graph to ac.out
  ac.out.addInput(music); 
  ac.out.addInput(uiPlay); 
  ac.out.addInput(stop); 
  ac.out.addInput(reset); 
  ac.out.addInput(fastForward); 
  ac.out.addInput(rewind); 
  
  // create a reusable endListener Bead to detect end/beginning of music playback
  musicEndListener = new Bead() 
  { 
    public void messageReceived(Bead message) 
    { 
      // Get handle to the SamplePlayer which received this endListener message
      println("End / Beginning of tape"); 
      SamplePlayer sp = (SamplePlayer) message; 
      
      // remove this endListener to prevent its firing over and over
      // due to playback position bugs in Beads
      sp.setEndListener(null);

      // The playback head has reached either the end or beginning of the tape.
      // Stop playing music by setting the playback rate to 0 immediately

      setPlaybackRate(0, true); 
      
      stop.start(0); 
    }
  };
  
  // Create the UI
  p5.addButton("Play")
  .setPosition(width / 2 -50, 10)
  .setSize(width / 2, 20)
  .activateBy((ControlP5.RELEASE)); 
  
  p5.addButton("Rewind")
  .setPosition(width / 2 -50, 35)
  .setSize(width / 2, 20)
  .activateBy((ControlP5.RELEASE)); 
  
  p5.addButton("FastForward")
  .setPosition(width / 2 -50, 60)
  .setSize(width / 2, 20)
  .activateBy((ControlP5.RELEASE)); 
  
  p5.addButton("Stop")
  .setPosition(width / 2 -50, 85)
  .setSize(width / 2, 20)
  .activateBy((ControlP5.RELEASE)); 
  
  p5.addButton("Reset")
  .setPosition(width / 2 -50, 110)
  .setSize(width / 2, 20)
  .activateBy((ControlP5.RELEASE)); 
  
  

    
  ac.start();
     
}

// Add endListener to the music SamplePlayer if one doesn't already exist
public void addEndListener() {
  if (music.getEndListener() == null) {
    music.setEndListener(musicEndListener);
  }
}

// Set music playback rate using a Glide
public void setPlaybackRate(float rate, boolean immediately){ 
  // Make sure playback head position isn't past end or beginning of the sample 
  if (music.getPosition() >= musicLength) { 
    println("End of tape"); 
    // reset playback head position to end of sample (tape)
    music.setToEnd(); 
  } 
  
  if (music.getPosition() <0) {
    println("Beginning of tape");
    // reset playback head position to beginning of sample (tape)
    music.reset(); 
  }
  if (immediately) { 
    musicRateGlide.setValueImmediately(rate); 
  }
  else { 
    musicRateGlide.setValue(rate); 
  }
}


//Assuming you have a ControlP5 button called Play
public void Play(int value) {
  println("Pressed Play"); 
   
   // if playback head isn't at the end of tape, set rate to 1
  if (music.getPosition() < musicLength) { 
    setPlaybackRate(1, false); 
    music.setEndListener(musicEndListener); 
  } 
  // always play the button sound
  uiPlay.start(0); 
}


public void FastForward(int value) {
  println("Pressed FF"); 
  if (music.getPosition() < musicLength) { 
    setPlaybackRate(4, false); 
    music.setEndListener(musicEndListener); 
  } 
  fastForward.start(); 
}


public void Stop(int value) { 
  println("Pressed Stop"); 
  stop.start(0); 
  setPlaybackRate(0, false); 
} 


public void Reset(int value) {
  println("Pressed Reset"); 
  reset.start(0); 
  music.reset(); 
  setPlaybackRate(0, true); 
} 


public void Rewind(int value) { 
  println("Pressed RWD"); 
  if (music.getPosition() > 0) { 
    setPlaybackRate(-4, false); 
    music.setEndListener(musicEndListener); 
  } 
  rewind.start(0); 
} 
  

void draw() {
  background(0);  //fills the canvas with black (0) each frame
  
}
