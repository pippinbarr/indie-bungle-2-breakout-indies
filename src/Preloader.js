BasicGame.Preloader = function (game) {

  this.background = null;
  this.preloadBar = null;

  this.ready = false;

};

BasicGame.Preloader.prototype = {

  preload: function () {

    //	These are the assets we loaded in Boot.js
    //	A nice sparkly background and a loading progress bar
    // this.background = this.add.sprite(0, 0, 'preloaderBackground');
    this.preloadBar = this.add.sprite(0, 0, 'preloaderBar');
    this.preloadBar.y = this.game.canvas.width / 2 - this.preloadBar.height / 2;

    //	This sets the preloadBar sprite as a loader sprite.
    //	What that does is automatically crop the sprite from 0 to full-width
    //	as the files below are loaded in.
    this.load.setPreloadSprite(this.preloadBar);


    // FONTS

    this.load.bitmapFont('atari', 'assets/fonts/atari.png', 'assets/fonts/atari.xml');


    // SPRITES/IMAGES

    this.load.image('white_pixel', 'assets/images/white_pixel.png');

    this.load.image('flag_left', 'assets/images/flag_left.png');
    this.load.image('flag_right', 'assets/images/flag_right.png');

    this.load.image('gravestone', 'assets/images/gravestone.png');
    this.load.image('bench', 'assets/images/bench.png');
    this.load.image('clouds', 'assets/images/clouds.png');
    this.load.image('new_game', 'assets/images/graveyard_new_game.png');

    this.load.image('hdydi_bg', 'assets/images/hdydi_bg.png');
    this.load.image('hdydi_girl_body', 'assets/images/hdydi_girl_body.png');
    this.load.spritesheet('hdydi_faces', 'assets/images/hdydi_faces.png', 205, 200);

    this.load.image('taip_hours_message', 'assets/images/taip_hours_message.png');
    this.load.image('taip_closed_message', 'assets/images/taip_closed_message.png');
    this.load.image('taip_closing_message', 'assets/images/taip_closing_message.png');
    this.load.image('taip_hours_message', 'assets/images/taip_hours_message.png');
    this.load.image('taip_entry_ground', 'assets/images/taip_entry_ground.png');
    this.load.image('taip_entry_glass_left', 'assets/images/taip_entry_glass_left.png');
    this.load.image('taip_entry_glass_right', 'assets/images/taip_entry_glass_right.png');
    this.load.image('taip_entry_wall_left', 'assets/images/taip_entry_wall_left.png');
    this.load.image('taip_entry_wall_right', 'assets/images/taip_entry_wall_right.png');
    this.load.image('taip_entry_wall_top', 'assets/images/taip_entry_wall_top.png');
    this.load.image('person_1', 'assets/images/person_1.png');
    this.load.image('person_2', 'assets/images/person_2.png');
    this.load.image('person_3', 'assets/images/person_3.png');
    this.load.image('taip_left_chair', 'assets/images/taip_left_chair.png');
    this.load.image('taip_table_and_chair', 'assets/images/taip_table_and_chair.png');
    this.load.image('taip_sitting_marina', 'assets/images/taip_sitting_marina.png');

    this.load.spritesheet('taip_marina', 'assets/images/taip_marina.png', 200, 100);
    this.load.spritesheet('taip_entry_doors', 'assets/images/taip_entry_doors.png', 180, 149);

    this.load.image('vvvvvv_bg', 'assets/images/vvvvvv_bg.png');
    this.load.image('vvvvvv_paddle', 'assets/images/vvvvvv_paddle.png');

    this.load.spritesheet('vvvvvv_character', 'assets/images/vvvvvv_character.png', 19, 40);

    this.load.image('vvvvvv_^^', 'assets/images/vvvvvv_^^.png');
    this.load.image('vvvvvv_vv', 'assets/images/vvvvvv_vv.png');
    this.load.image('vvvvvv_><', 'assets/images/vvvvvv_><.png');
    this.load.image('vvvvvv_bp', 'assets/images/vvvvvv_bp.png');
    this.load.image('vvvvvv_sp', 'assets/images/vvvvvv_sp.png');
    this.load.image('vvvvvv_tp', 'assets/images/vvvvvv_tp.png');


    // AU0I0

    this.load.audio('launch_wall_sfx', ['assets/sounds/launch_wall.mp3', 'assets/sounds/launch_wall.ogg']);
    this.load.audio('paddle_sfx', ['assets/sounds/paddle.mp3', 'assets/sounds/paddle.ogg']);
    this.load.audio('ball_out_sfx', ['assets/sounds/ball_out.mp3', 'assets/sounds/ball_out.ogg']);

    this.load.audio('brick_blue_sfx', ['assets/sounds/0.mp3', 'assets/sounds/0.ogg']);
    this.load.audio('brick_green_sfx', ['assets/sounds/1.mp3', 'assets/sounds/1.ogg']);
    this.load.audio('brick_yellow_sfx', ['assets/sounds/2.mp3', 'assets/sounds/2.ogg']);
    this.load.audio('brick_orange_sfx', ['assets/sounds/3.mp3', 'assets/sounds/3.ogg']);
    this.load.audio('brick_oranger_sfx', ['assets/sounds/4.mp3', 'assets/sounds/4.ogg']);
    this.load.audio('brick_red_sfx', ['assets/sounds/5.mp3', 'assets/sounds/5.ogg']);

    this.load.audio('acid_on_granite', ['assets/sounds/acid_on_granite.mp3', 'assets/sounds/acid_on_granite.ogg']);

    this.load.audio('hdydi_click_1', ['assets/sounds/hdydi_click_1.mp3', 'assets/sounds/hdydi_click_1.ogg']);
    this.load.audio('hdydi_click_2', ['assets/sounds/hdydi_click_2.mp3', 'assets/sounds/hdydi_click_2.ogg']);
    this.load.audio('hdydi_click_3', ['assets/sounds/hdydi_click_3.mp3', 'assets/sounds/hdydi_click_3.ogg']);

    this.load.audio('hdydi_girl_1', ['assets/sounds/hdydi_girl_1.mp3', 'assets/sounds/hdydi_girl_1.ogg']);
    this.load.audio('hdydi_girl_2', ['assets/sounds/hdydi_girl_2.mp3', 'assets/sounds/hdydi_girl_2.ogg']);
    this.load.audio('hdydi_girl_3', ['assets/sounds/hdydi_girl_3.mp3', 'assets/sounds/hdydi_girl_3.ogg']);
    this.load.audio('hdydi_girl_4', ['assets/sounds/hdydi_girl_4.mp3', 'assets/sounds/hdydi_girl_4.ogg']);
    this.load.audio('hdydi_girl_5', ['assets/sounds/hdydi_girl_5.mp3', 'assets/sounds/hdydi_girl_5.ogg']);
    this.load.audio('hdydi_girl_6', ['assets/sounds/hdydi_girl_6.mp3', 'assets/sounds/hdydi_girl_6.ogg']);

    this.load.audio('vvvvvv_flip_up', ['assets/sounds/vvvvvv_flip_up.mp3', 'assets/sounds/vvvvvv_flip_up.ogg']);
    this.load.audio('vvvvvv_flip_down', ['assets/sounds/vvvvvv_flip_down.mp3', 'assets/sounds/vvvvvv_flip_down.ogg']);
    this.load.audio('vvvvvv_flip_line', ['assets/sounds/vvvvvv_flip_line.mp3', 'assets/sounds/vvvvvv_flip_line.ogg']);
    this.load.audio('vvvvvv_death', ['assets/sounds/vvvvvv_death.mp3', 'assets/sounds/vvvvvv_death.ogg']);
    this.load.audio('vvvvvv_teleporter', ['assets/sounds/vvvvvv_teleporter.mp3', 'assets/sounds/vvvvvv_teleporter.ogg']);
    this.load.audio('vvvvvv_rescue', ['assets/sounds/vvvvvv_rescue.mp3', 'assets/sounds/vvvvvv_rescue.ogg']);

    MUSEUM_JUST_CLOSED = false;

  },


  create: function () {

    //	Once the load has finished we disable the crop because we're going to sit in the update loop for a short while as the music decodes
    this.preloadBar.cropEnabled = false;

  },


  update: function () {

    if (this.cache.isSoundDecoded('acid_on_granite') && this.ready == false) {
      this.ready = true;
      // this.state.start('Menu');
      this.state.start('Menu');
    }

  }

};