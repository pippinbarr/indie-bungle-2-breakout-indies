MENU_STATE = 'Menu';

BasicGame.Instructions = function (game)
{
  //	When a State is added to Phaser it automatically has the following properties set on it, even if they already exist:

  this.game;		//	a reference to the currently running game
  this.add;		//	used to add sprites, text, groups, etc
  this.camera;	//	a reference to the game camera
  this.cache;		//	the game cache
  this.input;		//	the global input manager (you can access this.input.keyboard, this.input.mouse, as well from it)
  this.load;		//	for preloading assets
  this.math;		//	lots of useful common math operations
  this.sound;		//	the sound manager - add a sound, play one, set-up markers, etc
  this.stage;		//	the game stage
  this.time;		//	the clock
  this.tweens;    //  the tween manager
  this.state;	    //	the state manager
  this.world;		//	the game world
  this.particles;	//	the particle manager
  this.physics;	//	the physics manager
  this.rnd;		//	the repeatable random number generator

  //	You can use any of these from any function within this State.
  //	But do consider them as being 'reserved words', i.e. don't create a property for your own game called "world" or you'll over-write the world reference.

};



BasicGame.Instructions.prototype = {

  create: function () {

    KEYBOARD_INSTRUCTIONS = "" +
      "PRESS [LEFT] TO MOVE PADDLE LEFT\n" +
      "PRESS [RIGHT] TO MOVE PADDLE RIGHT\n" +
      "PRESS [ESCAPE] TO RETURN TO MENU\n\n\n" +
      "NOW PRESS [LEFT] OR [RIGHT] TO BEGIN" +
      "";

    MOBILE_INSTRUCTIONS = "" +
    "TOUCH LEFT SIDE TO MOVE PADDLE LEFT\n" +
    "TOUCH RIGHT SIDE TO MOVE PADDLE RIGHT\n" +
    "TOUCH CENTRE TO RETURN TO MENU\n\n\n" +
    "NOW TOUCH ANYWHERE TO BEGIN" +
    "";

    this.game.stage.backgroundColor = '#000000';

    this.instructionsTitleText = this.game.add.bitmapText(100,100, 'atari', 'INSTRUCTIONS', 48);
    this.instructionsTitleText.x = this.game.width/2 - this.instructionsTitleText.width/2;
    this.instructionsTitleText.visible = false;
    this.instructionsText = this.game.add.bitmapText(this.instructionsTitleText.x,200, 'atari', MOBILE_INSTRUCTIONS, 24);

    this.instructionsText.visible = false;

    this.showInstructions();
  },


  showInstructions: function () {

    if (this.game.device.desktop) {
      this.instructionsTitleText.visible = true;
      this.instructionsText.text = KEYBOARD_INSTRUCTIONS;
      this.instructionsText.visible = true;
    }
    else {
      this.instructionsTitleText.visible = true;
      this.instructionsText.text = MOBILE_INSTRUCTIONS;
      this.instructionsText.visible = true;
    }

    MENU_STATE = 'Menu';

    document.addEventListener("touchend", this.touchInputUp.bind(this), false);
    touched = false;
  },


  touchInputUp: function (e) {
    touched = true;
  },



  update: function () {

    if (!this.game.device.desktop && touched) {
      this.game.state.start(NEXT_GAME_STATE);
    }
    else if (this.game.device.desktop) {
      if (this.leftPressed() || this.rightPressed()) {
        this.game.state.start(NEXT_GAME_STATE);
      }
    }
  },


  leftPressed: function () {

    if (this.game.device.desktop) {
      if (this.game.input.keyboard.isDown(Phaser.Keyboard.LEFT)) {
        return 1.0;
      }
    }
    else {
      var clicked = (this.game.input.activePointer.isDown && (this.game.input.activePointer.x > 2*this.game.canvas.width/3));
      if (clicked) {
        return 1.0;
      }
    }

    return 0;

  },


  rightPressed: function () {

    if (this.game.device.desktop) {
      if (this.game.input.keyboard.isDown(Phaser.Keyboard.RIGHT)) {
        return 1.0;
      }
    }
    else {
      var clicked = this.game.input.activePointer.isDown && this.game.input.activePointer.x > 2*this.game.canvas.width/3;

      if (clicked) {
        return 1.0;
      }
    }

    return 0;
  },


  shutdown: function () {

    // window.removeEventListener("touchend", this.touchInputUp);

  }

};
