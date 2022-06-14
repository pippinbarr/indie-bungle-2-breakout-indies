BasicGame.Menu = function (game)
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
  //	But do consider them as being 'reserved words', i.e. don't create a property for your own game called world or you'll over-write the world reference.

};



BasicGame.Menu.prototype = {

  create: function () {

    MENU_COLOURS = [0xB24541, 0xAD5D34, 0x9E6A2D, 0x969128, 0x528F3B, 0x2B42BF];
    this.menuColourIndex = 0;

    MENU_ITEMS = [
      ['DESERT BREAKOUT','DesertGolfing'],
      ['HOW DO YOU BREAKOUT?','HowDoYouDoIt'],
      ['THE GRAVE BREAKOUT','TheGraveyard'],
      ['THE BREAKOUT IS PRESENT','TheArtistIsPresent'],
      ['BREAKVVVVVVOUT','VVVVVV1']
    ];

    MENU_KEYS = ['1','2','3','4','5'];

    this.game.stage.backgroundColor = '0x000000';

    this.createDesktopMenu();

    this.game.input.keyboard.onDownCallback = this.handleKeyDown;

  },


  handleKeyDown: function (event) {

    var index = MENU_KEYS.indexOf(String.fromCharCode(event.keyCode));

    if (index != -1) {
      NEXT_GAME_STATE = MENU_ITEMS[index][1];
      this.game.state.start('Instructions');
    }

  },


  createDesktopMenu: function () {

    title = this.game.add.bitmapText(0,0,'atari','INDIE BUNGLE 2:',64);
    title.anchor.x = 0.5;
    // title.anchor.y = 0;
    title.x = this.game.width/2;
    title.y = 20;
    // title.angle = 270;

    subtitle = this.game.add.bitmapText(0,0,'atari','BREAKOUT INDIES',48);
    subtitle.anchor.x = 0.5;
    // title.anchor.y = 0;
    subtitle.x = this.game.width/2;
    subtitle.y = title.y + title.height + 10;


    var MENU_X_OFFSET = title.x - title.width/2;
    var MENU_Y_OFFSET = title.y + title.height + 80;
    var MENU_Y_MAX = this.game.height - MENU_Y_OFFSET;

    var TITLE_OFFSET = 30;

    var ii = 0;
    for (var i = 0; i < MENU_ITEMS.length; i++) {

      var pixel = this.game.add.sprite(0,0,'white_pixel');

      // if (MENU_Y_OFFSET + 24*ii >= MENU_Y_MAX) {
      //   MENU_X_OFFSET = this.game.canvas.width/2 + 50;
      //   ii = 0;
      // }

      menuKey = this.game.add.bitmapText(MENU_X_OFFSET, MENU_Y_OFFSET + 48*ii, 'atari', "(" + MENU_KEYS[i] + ")", 32);
      menuItem = this.game.add.bitmapText(MENU_X_OFFSET + 80, MENU_Y_OFFSET + 48*ii, 'atari', MENU_ITEMS[i][0], 32);

      pixel.tint = MENU_COLOURS[i];
      pixel.x = 0;
      pixel.y = menuKey.y - 8;
      pixel.width = this.game.width;
      pixel.height = menuItem.height*2;

      if (true) {
        pixel.inputEnabled = true;
        pixel.events.onInputUp.add(this.buttonUp);
        pixel.gameState = MENU_ITEMS[i][1];
        // like_button.events.onInputDown.add(this.buttonDown);
        // like_button.events.onInputOut.add(this.buttonOut);

      }

      ii++;

    }

    var pixel = this.game.add.sprite(0,0,'white_pixel');
    pixel.tint = MENU_COLOURS[5];
    pixel.x = 0;
    pixel.y = MENU_Y_OFFSET + 48*ii - 8;
    pixel.width = this.game.width;
    pixel.height = menuItem.height*2;

  },


  buttonUp: function (button) {
    NEXT_GAME_STATE = button.gameState;
    button.game.state.start('Instructions');
  },


  update: function () {

  },


  shutdown: function () {

    this.game.input.keyboard.onDownCallback = null;

  }

};
