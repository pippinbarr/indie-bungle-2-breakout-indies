var VVVVVVLEVEL = 0;
var VVVVVVDEATHS = 0;

BasicGame.VVVVVV1 = function (game) {
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


BasicGame.VVVVVV1.prototype = new Phaser.State();

BasicGame.VVVVVV1.prototype.parent = Phaser.State;

VVVVVV1State = {
  START: 'START',
  PLAY: 'PLAY',
  DEATH: 'DEATH',
  GAME_OVER: 'GAME_OVER',
  GAME_OVER_SCREEN: 'GAME_OVER_SCREEN',
  PAUSED: 'PAUSED',
  LOST_PADDLE: 'LOST_PADDLE',
  RESCUE: 'RESCUE'
};

BasicGame.VVVVVV1.prototype = {

  create: function () {

    Phaser.State.prototype.create.call(this);

    // this.game.sound.mute = true;

    PADDLE_SPEED = 600;
    PADDLE_WIDTH = 70;
    PADDLE_HEIGHT = 10;

    BALL_SPEED = 150;
    BALL_X_SPEED = 200;
    BALL_SIZE = 10;

    BRICKS = [];
    MAX_BRICK_ROWS = 12;
    BRICKS_Y_OFFSET = 80;
    BRICK_WIDTH = 30;
    BRICK_HEIGHT = 15;

    NUM_PADDLES = 5;

    SEEN_CONTROLS = false;
    CONTROLS_SEEN_THRESHOLD = 60;

    BG_START_COLOR = '#CC9E5E';
    BRICK_START_COLOR = '#CB7735';

    this.levels = [VVVVVV_LEVEL_1,VVVVVV_LEVEL_2,VVVVVV_LEVEL_3,VVVVVV_LEVEL_4,VVVVVV_LEVEL_5,VVVVVV_LEVEL_6]
    // this.levels = [VVVVVV_LEVEL_2,VVVVVV_LEVEL_6]
    this.level = this.levels[VVVVVVLEVEL];



    this.currentStateName = 'Breakout';

    this.game.stage.backgroundColor = BG_START_COLOR;

    this.game.add.sprite(0,0,'vvvvvv_bg');

    this.brickColor = BRICK_START_COLOR;


    this.state = VVVVVV1State.START;

    this.physics.startSystem(Phaser.Physics.ARCADE);




    // BALL

    // this.ball = this.game.add.sprite(0,0,'vvvvvv_viridian');
    this.ball = this.game.add.sprite(0,0,'vvvvvv_character');
    this.ball.tint = 0x709C96;
    this.ball.anchor.y = 0.5;
    // this.ball.anchor.x = 0.5;

    this.ball.x = this.game.canvas.width/2;
    this.ball.y = this.game.canvas.height/2 + this.ball.height*4;
    this.game.physics.enable(this.ball, Phaser.Physics.ARCADE);
    this.ball.body.bounce.setTo(1,1);

    this.ball.collides = false;

    this.ball.body.velocity.x = 0;
    this.ball.body.velocity.y = 0;
    this.ball.body.x = this.game.width/2 - this.ball.width/2;
    this.ball.body.y = this.game.height - 180;

    // WALLS

    this.walls = this.game.add.group();

    this.leftWall = this.game.add.sprite(0,0,'white_pixel');
    this.leftWall.width = 100;
    this.leftWall.height = this.game.height + 40;
    this.leftWall.x = 0 - this.leftWall.width;
    this.leftWall.y = -40;

    this.rightWall = this.game.add.sprite(0,0,'white_pixel');
    this.rightWall.width = 100;
    this.rightWall.height = this.game.height + 40;
    this.rightWall.x = this.game.width;
    this.rightWall.y = -40;

    if (this.level == VVVVVV_LEVEL_4 || this.level == VVVVVV_LEVEL_6) {
      // No top wall
    }
    else {
      this.game.physics.enable(this.leftWall, Phaser.Physics.ARCADE);
      this.walls.add(this.leftWall);
      this.leftWall.body.immovable = true;

      this.game.physics.enable(this.rightWall, Phaser.Physics.ARCADE);
      this.walls.add(this.rightWall);
      this.rightWall.body.immovable = true;
    }



    this.topWall = this.game.add.sprite(0,0,'white_pixel');
    this.topWall.width = this.game.width + 80;
    this.topWall.height = 100;
    this.topWall.x = -40;
    this.topWall.y = -this.topWall.height;
    if (this.level == VVVVVV_LEVEL_4 || this.level == VVVVVV_LEVEL_6) {
      // No top wall
    }
    else {
      this.game.physics.enable(this.topWall, Phaser.Physics.ARCADE);
      this.walls.add(this.topWall);
      this.topWall.body.immovable = true;
    }

    // SOUNDS

    this.launch_wall_sfx = this.game.add.audio('vvvvvv_flip_line',1);

    if (this.level != VVVVVV_LEVEL_4) {
      this.paddle_sfx = this.game.add.audio('vvvvvv_flip_up',1);
    }
    else {
      this.paddle_sfx = this.game.add.audio('vvvvvv_flip_down',1);
    }

    if (!this.BRICK_SFX) {
      this.BRICK_SFX = {};
      this.BRICK_SFX["brick_blue"] = this.game.add.audio('vvvvvv_flip_down',1);
      this.BRICK_SFX["brick_green"] = this.game.add.audio('vvvvvv_flip_down',1);
      this.BRICK_SFX["brick_yellow"] = this.game.add.audio('vvvvvv_flip_down',1);
      this.BRICK_SFX["brick_orange"] = this.game.add.audio('vvvvvv_flip_down',1);
      this.BRICK_SFX["brick_oranger"] = this.game.add.audio('vvvvvv_flip_down',1);
      this.BRICK_SFX["brick_red"] = this.game.add.audio('vvvvvv_flip_down',1);
    }

    this.death_sfx = this.game.add.audio('vvvvvv_death',1);
    this.rescue_sfx = this.game.add.audio('vvvvvv_rescue',1);
    this.teleporter_sfx = this.game.add.audio('vvvvvv_teleporter');

    // BRICKS

    this.bricks = this.game.add.group();
    this.solid_bricks = this.game.add.group();
    this.enemies = this.game.add.group();
    this.teleporters = this.game.add.group();
    if (this.level == VVVVVV_LEVEL_5) this.teleporterConnections = [[],[],[]];
    else this.teleporterConnections = [];

    switch (this.level) {
      case VVVVVV_LEVEL_1:
      this.brickTint = 0xFF9999;
      break;

      case VVVVVV_LEVEL_2:
      this.brickTint = 0xFFFF99;
      break;

      case VVVVVV_LEVEL_3:
      this.brickTint = 0x99FF99;
      break;

      case VVVVVV_LEVEL_4:
      this.brickTint = 0x99FFFF;
      break;

      case VVVVVV_LEVEL_5:
      this.brickTint = 0xFF99FF;
      break;

      case VVVVVV_LEVEL_6:
      this.brickTint = 0x9999FF;
      break;
    }


    // PADDLE

    this.paddle = this.game.add.sprite(0,0,'vvvvvv_paddle');
    this.paddle.x = this.game.canvas.width/2 - this.paddle.width/2;
    this.paddle.y = this.game.canvas.height - 3*this.paddle.height;
    this.game.physics.enable(this.paddle, Phaser.Physics.ARCADE);
    this.paddle.body.immovable = true;
    this.paddle.tint = this.brickTint;


    // RESCUEE

    this.rescuee = null;

    if (this.level != VVVVVV_LEVEL_6) {
      this.rescuee = this.game.add.sprite(0,0,'vvvvvv_character');
      this.rescuee.frame = 1;
    }

    switch (this.level) {
      case VVVVVV_LEVEL_1:
      // this.rescuee = this.game.add.sprite(0,0,'vvvvvv_violet');
      this.rescuee.tint = 0xA462B8;
      break;

      case VVVVVV_LEVEL_2:
      // this.rescuee = this.game.add.sprite(0,0,'vvvvvv_verdigris');
      this.rescuee.tint = 0x6ABD59;
      break;

      case VVVVVV_LEVEL_3:
      // this.rescuee = this.game.add.sprite(0,0,'vvvvvv_vermillion');
      this.rescuee.tint = 0xE74741;
      break;

      case VVVVVV_LEVEL_4:
      // this.rescuee = this.game.add.sprite(0,0,'vvvvvv_victoria');
      this.rescuee.tint = 0x2E47EE;
      break;

      case VVVVVV_LEVEL_5:
      // this.rescuee = this.game.add.sprite(0,0,'vvvvvv_vitelleri');
      this.rescuee.tint = 0xC8C267;
      break;
    }

    if (this.rescuee) {
      this.game.physics.enable(this.rescuee, Phaser.Physics.ARCADE);
      this.rescuee.anchor.y = 0.5;
      this.rescuee.x = this.game.width/2 - this.rescuee.width/2;

      if (this.level == VVVVVV_LEVEL_4) {
        this.rescuee.body.velocity.x = -300;
        this.rescuee.y = 80;
        this.rescuee.scale.y = -1;
      }
      else {
        this.rescuee.y = 95;
      }

      // this.rescuee.x = 200;
      // this.rescuee.y = this.game.height - this.rescuee.height*2;

    }


    // TEXTS

    // Score

    this.score = VVVVVVDEATHS;
    this.scoreText = this.game.add.bitmapText(0, 8, 'atari','',120);
    this.scoreText.tint = 0xFFFFFF;
    this.scoreText.scale.x = 0.75;
    this.scoreText.scale.y = 0.25;


    this.updateScore(0);


    // Game Over

    this.gameOverBG = this.game.add.sprite(0,0,'white_pixel');
    this.gameOverBG.width = this.game.canvas.width;
    this.gameOverBG.height = this.game.canvas.height;
    this.gameOverBG.tint = 0x000000;
    this.gameOverBG.visible = false;

    this.gameOverText = this.game.add.bitmapText(100, 100, 'atari','GAME OVER',48);
    this.gameOverText.x = this.game.width/2 - this.gameOverText.width/2;
    this.gameOverText.y = this.game.height/2;
    this.gameOverText.visible = false;

    this.gameOverScoreText = this.game.add.bitmapText(100, 100, 'atari','',24);
    this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    this.gameOverScoreText.y = this.gameOverText.y + 2 * this.gameOverText.height;
    this.gameOverScoreText.visible = false;

    this.gameOverScoreString = 'FINAL SCORE';

    this.gameOverScoreNumberText = this.game.add.bitmapText(100, 100, 'atari',this.gameOverScoreString,24);
    this.gameOverScoreNumberText.x = this.game.width/2 - this.gameOverScoreNumberText.width/2;
    this.gameOverScoreNumberText.y = this.gameOverScoreText.y + 1.2 * this.gameOverScoreText.height;
    this.gameOverScoreNumberText.visible = false;


    // Set up the game

    this.resetGame();

    touchLeftPressed = false;
    touchRightPressed = false;

    document.addEventListener("touchstart", this.touchInputDown.bind(this), false);
    document.addEventListener("touchend", this.touchInputUp.bind(this), false);
  },


  touchInputDown: function (e) {

    var leftMargin =  Number(this.game.canvas.style["margin-left"].replace("px",""));


    if (e.pageX < leftMargin + this.game.width/3) {
      touchLeftPressed = true;
    }
    else if (e.pageX > leftMargin + 2 * this.game.width/3) {
      touchRightPressed = true;
    }
  },


  touchInputUp: function (e) {
    touchLeftPressed = false;
    touchRightPressed = false;
  },


  updateScore: function (score) {

    this.score += score;
    this.scoreText.text = this.score.toString();
    this.scoreText.x = this.game.canvas.width - 280 - this.scoreText.width;

  },

  update: function () {

    Phaser.State.prototype.update.call(this);

    // You can always exit
    if (this.exitPressed()) {
      this.exitToMenu();
    }

    if (this.state != VVVVVV1State.DEATH) this.handleInput();

    if (this.ball.body.velocity.y > 0) this.ball.scale.y = 1;
    else if (this.ball.body.velocity.y < 0) this.ball.scale.y = -1;

    this.enemies.forEachAlive(function (enemy) {
      if (enemy.body.x + enemy.body.width > this.game.canvas.width) {
        enemy.body.velocity.x *= -1;
        enemy.body.x = this.game.canvas.width - enemy.body.width;
      }
      else if (enemy.body.x < 0) {
        enemy.body.velocity.x *= -1;
        enemy.body.x = 0;
      }
    },this);

    // PHYSICS

    if (this.level == VVVVVV_LEVEL_4) {
      if (this.paddle.body.x < 0 - this.paddle.width/2) {
        this.paddle.body.x = this.game.width - this.paddle.width/2;
      }
      else if (this.paddle.body.x > this.game.width - this.paddle.width/2) {
        this.paddle.body.x = 0 - this.paddle.body.width/2;
      }
      if (this.ball.body.x < 0 - this.ball.width/2) {
        this.ball.body.x = this.game.width - this.ball.width/2;
      }
      else if (this.ball.body.x > this.game.width - this.ball.width/2) {
        this.ball.body.x = 0 - this.ball.body.width/2;
      }

    }
    else if (this.level == VVVVVV_LEVEL_6) {
      if (this.paddle.body.x < 240) this.paddle.body.x = 240;
      if (this.paddle.body.x > 300) this.paddle.body.x = 300;
    }
    else {
      this.physics.arcade.overlap(this.paddle,this.walls,this.handlePaddleWallColliders,null,this);
    }
    this.physics.arcade.collide(this.ball,this.walls,this.handleBallWallColliders,null,this);

    if (this.level == VVVVVV_LEVEL_4 && this.rescuee.body.x + this.rescuee.width/2 < 0) {
      this.rescuee.body.x = this.game.width - this.rescuee.width/2;
    }

    if (this.state == VVVVVV1State.PLAY) {

      this.physics.arcade.collide(this.ball,this.paddle,this.handleBallPaddleColliders,null,this);
      this.physics.arcade.collide(this.ball,this.solid_bricks,this.handleBallBrickColliders.bind(this),null,this);
      this.physics.arcade.overlap(this.ball,this.bricks,this.handleBallBrickColliders.bind(this),null,this);

      this.physics.arcade.overlap(this.ball,this.enemies,function (ball, enemy) {
        this.die();
      },null,this);

      if (this.rescuee) this.physics.arcade.overlap(this.ball,this.rescuee,function (ball, rescuee) {
        this.rescue_sfx.play();
        this.rescuee.frame = 0;
        this.state = VVVVVV1State.RESCUE;
        this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
        this.rescuee.body.velocity.x = this.rescuee.body.velocity.y = 0;
        VVVVVVLEVEL++;
        // console.log("test");
        this.game.time.events.add(Phaser.Timer.SECOND * 3, this.finishedLevel, this);
      },null,this);

      if (this.ball.body.y < -200) {
        this.rescue_sfx.play();
        this.state = VVVVVV1State.RESCUE;
        this.game.time.events.add(Phaser.Timer.SECOND * 3, this.finishedLevel, this);
      }

      this.physics.arcade.overlap(this.ball,this.teleporters,function (ball, teleporter) {

        this.teleporter_sfx.play();
        this.ball.body.x = teleporter.toTeleporter.x;

        if (teleporter.toTeleporter.isCorrectTeleporter) {
          this.ball.body.y = teleporter.toTeleporter.body.y - this.ball.body.height - 1;
          this.ball.body.velocity.y = -BALL_SPEED;
          this.ball.collides = true;
        }
        else {
          this.ball.body.y = teleporter.toTeleporter.body.y + teleporter.toTeleporter.body.height + 1;
          this.ball.body.velocity.x = 0;
          this.ball.body.velocity.y = BALL_SPEED;
          this.ball.collides = true;
        }
      },null,this)
      this.checkBallOut();
    }
  },


  die: function () {
    if (this.state == VVVVVV1State.DEATH) return;

    VVVVVVDEATHS++;

    this.ball.frame = 1;
    this.death_sfx.play();
    this.updateScore(1);
    this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
    this.ball.tint = 0xFF0000;
    this.paddle.body.velocity.x = 0;
    this.flashSprite(this.ball,2);
    this.state = VVVVVV1State.DEATH;

    this.game.time.events.add(Phaser.Timer.SECOND * 2, this.resetBall, this);
  },


  nextLevel: function () {
    this.game.state.start('VVVVVV1');
  },


  handleInput: function () {



    // You can't move the paddle unless you're playing or the ball is about to launch
    if (this.state == VVVVVV1State.GAME_OVER || this.state == VVVVVV1State.LOST_PADDLE || !this.paddle.visible) return;

    // Here we can move the paddle
    var leftPressed = (this.leftPressed());
    var rightPressed = (this.rightPressed());

    if (leftPressed > 0) {
      this.paddle.body.velocity.x = leftPressed * -PADDLE_SPEED;
    }
    else if (rightPressed > 0) {
      this.paddle.body.velocity.x = rightPressed * PADDLE_SPEED;
    }
    else {
      this.paddle.body.velocity.x = 0;
    }

  },



  checkBallOut: function () {

    if (this.state != VVVVVV1State.PLAY) return;

    if (this.level == VVVVVV_LEVEL_4) {
      if (this.ball.body.y < 0 - this.ball.height) {
        this.ball.body.y = this.game.height;
      }
      else if (this.ball.body.y > this.game.height) {
        this.ball.body.y = 0 - this.ball.height;
        this.ball.collides = true;
      }
      return;
    }

    if (this.ball.visible && this.ball.y > this.game.canvas.height)
    {
      this.lostPaddle();
    }

  },


  lostPaddle: function () {

    this.updateScore(1);
    this.resetBall();
    this.state = VVVVVV1State.START;

  },


  gameOver: function () {

    this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
    this.paddle.body.velocity.x = this.paddle.body.velocity.y = 0;
    this.state = VVVVVV1State.GAME_OVER;

    this.game.time.events.add(Phaser.Timer.SECOND * 1, this.showGameOver, this);

  },


  finishedLevel: function () {
    this.showGameOver();
  },


  showGameOver: function () {

    this.bricks.visible = false;
    this.solid_bricks.visible = false;
    this.enemies.visible = false;
    this.ball.visible = false;
    this.paddle.visible = false;
    this.walls.visible = false;
    this.scoreText.visible = false;
    if (this.rescuee) this.rescuee.visible = false;
    this.teleporters.visible = false;

    this.gameOverBG.visible = true;
    this.gameOverScoreText.visible = true;
    this.gameOverScoreNumberText.visible = true;

    if (this.level != VVVVVV_LEVEL_6) {
      this.gameOverScoreText.text = "YOU HAVE RESCUED A CREW MEMBER";
      if (VVVVVVLEVEL < 5) {
        this.gameOverScoreNumberText.text = (5-VVVVVVLEVEL) + " REMAIN";
      }
      else {
        this.gameOverScoreNumberText.text = " ALL CREW MEMBERS RESCUED!";
      }
      this.game.time.events.add(Phaser.Timer.SECOND * 3, this.nextLevel, this);

    }
    else {
      this.gameOverText.visible = true;
      this.gameOverScoreText.text = "DEATHS";
      this.gameOverScoreNumberText.text = this.score.toString();

      this.game.time.events.add(Phaser.Timer.SECOND * 3, this.exitToMenu, this);
    }
    this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;

    this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    this.gameOverScoreNumberText.x = this.game.width/2 - this.gameOverScoreNumberText.width/2;
    this.gameOverScoreNumberText.y = this.gameOverScoreText.y + 2 * this.gameOverScoreText.height;

    this.state = VVVVVV1State.GAME_OVER_SCREEN;

  },


  leftPressed: function () {

    if (this.game.device.desktop) {
      if (this.game.input.keyboard.isDown(Phaser.Keyboard.LEFT)) {
        return 1.0;
      }
    }
    else {
      if (touchLeftPressed) return 1.0;

      var clicked = (this.game.input.activePointer.isDown && (this.game.input.activePointer.x < this.game.canvas.width/3));
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
      if (touchRightPressed) return 1.0;

      var clicked = this.game.input.activePointer.isDown && this.game.input.activePointer.x > 2*this.game.canvas.width/3;

      if (clicked) {
        return 1.0;
      }
    }

    return 0;
  },


  exitPressed: function () {

    return ((this.game.device.desktop && this.game.input.keyboard.downDuration(Phaser.Keyboard.ESC,10)) ||
    (this.game.input.activePointer.isDown &&
      this.game.input.activePointer.x > this.game.canvas.width/3 &&
      this.game.input.activePointer.x < 2*this.game.canvas.width/3));

    },


    handlePaddleWallColliders: function (paddle,wall) {

      paddle.body.velocity.x = 0;

      if (wall == this.leftWall) {
        paddle.body.x = wall.body.x + wall.width;
      }
      else if (wall == this.rightWall) {
        paddle.body.x = wall.body.x - paddle.width;
      }

    },


    handleBallPaddleColliders: function (ball,paddle) {

      this.paddle_sfx.play();

      paddleMid = paddle.x + paddle.width/2;
      ballMid = ball.x + ball.width/2;
      diff = 0;

      if (ballMid < paddleMid - ball.width/2) {

        //  Ball is on the left of the bat
        diff = paddleMid - ballMid;
        var proportion = (diff / (paddle.width/2));
        ball.body.velocity.x = (-BALL_X_SPEED * proportion);

      }
      else if (ballMid > paddleMid + ball.width/2) {

        //  Ball on the right of the bat
        diff = ballMid - paddleMid;
        var proportion = (diff / (paddle.width/2));
        ball.body.velocity.x = (BALL_X_SPEED * proportion);

      }
      else {

        //  Ball is perfectly in the middle
        //  A little random X to stop it bouncing up!
        ball.body.velocity.x = 2 + Math.floor(Math.random() * 8);

      }

      ball.collides = true;

    },


    handleBallBrickColliders: function (ball,brick) {

      if (brick.kills) {
        this.die();
        // this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
        // this.ball.tint = 0xFF0000;
        // this.flashSprite(this.ball,2);
        return;
      }

      if (!ball.collides && !brick.solid) {
        return;
      }

      brick.sfx.play();

      if (brick.solid) return;

      ball.body.velocity.y *= -1;

      ball.collides = false;

      brick.disable();
      brick.alive = false;

    },


    handleBallWallColliders: function (ball,wall) {

      if (wall == this.topWall) ball.collides = true;

      this.launch_wall_sfx.play();

    },


    resetGame: function () {

      // Change tint of BG
      var newBGColor = '#' + ((this.game.stage.backgroundColor + 0x000001) % 0xffffff).toString (16);
      this.game.stage.backgroundColor = newBGColor;

      // Change tint of brick
      this.brickColor = '#' + ((parseInt(this.brickColor.slice(1,this.brickColor.length), 16) + 0x000001) % 0xffffff).toString(16);

      this.resetBricks();
      this.resetBall();

    },


    resetBall: function () {

      this.ball.x = this.paddle.x + this.paddle.width/2 - this.ball.width/2;
      this.ball.y = this.paddle.y - 40;

      this.ball.body.velocity.x = 0;
      this.ball.body.velocity.y = 0;

      this.ball.tint = 0x709C96;
      this.ball.frame = 0;
      this.ball.scale.y = 1;

      this.state = VVVVVV1State.START;

      this.restartTimer = this.game.time.events.add(Phaser.Timer.SECOND * 2, this.restartBall, this, this.ball, this.paddle);
    },


    restartBall: function (ball,paddle) {

      this.ball.body.velocity.x = 20 - Math.random() * 40;
      this.ball.body.velocity.y = BALL_SPEED;

      this.launch_wall_sfx.play();

      this.state = VVVVVV1State.PLAY;

    },


    resetBricks: function () {

      BRICKS = [];
      this.bricks.removeAll();
      this.solid_bricks.removeAll();

      for (var row = 0; row < this.level.length; row++) {
        for (var col = 0; col < this.level[row].length; col++) {
          this.createBrick(row, col);
        }
      }

      for (var i = 0; i < this.teleporterConnections.length; i++) {
        this.teleporterConnections[i][0].toTeleporter = this.teleporterConnections[i][1];
        this.teleporterConnections[i][1].toTeleporter = this.teleporterConnections[i][0];
      }
    },


    createBrick: function (row, col) {

      var brick;

      switch (this.level[row][col]) {
        case '  ':
        break;

        case '^^':
        brick = new Brick(this,col*BRICK_WIDTH,row*BRICK_HEIGHT,0,0,null,0,this.BRICK_SFX["brick_oranger"],'vvvvvv_^^',1);
        brick.kills = true;
        break;

        case 'vv':
        brick = new Brick(this,col*BRICK_WIDTH,row*BRICK_HEIGHT,0,0,null,0,this.BRICK_SFX["brick_oranger"],'vvvvvv_vv',1);
        brick.kills = true;
        break;

        case '><':
        enemy = this.game.add.sprite(0,0,'vvvvvv_><');
        enemy.anchor.x = enemy.anchor.y = 0.5;
        enemy.y = row*BRICK_HEIGHT;
        enemy.x = col*BRICK_HEIGHT;
        this.game.physics.enable(enemy, Phaser.Physics.ARCADE);
        enemy.body.immovable = true;
        enemy.body.velocity.x = 100;
        this.enemies.add(enemy);
        break;

        case 't1':
        case 't2':
        case 't3':
        tp = this.game.add.sprite(0,0,'vvvvvv_tp');
        tp.x = col*BRICK_WIDTH;
        tp.y = row*BRICK_HEIGHT;
        tp.y -= BRICK_HEIGHT/3;
        this.game.physics.enable(tp, Phaser.Physics.ARCADE);
        tp.body.immovable = true;
        tp.isCorrectTeleporter = false;
        if (this.level[row][col] == 't1') {
          this.teleporterConnections[0].push(tp);
          if (col == 2 && row == 6) {
            // It's the origin teleporter
            tp.isCorrectTeleporter = true;
          }
        }
        else if (this.level[row][col] == 't2') {
          this.teleporterConnections[1].push(tp);
        }
        else if (this.level[row][col] == 't3') {
          this.teleporterConnections[2].push(tp);
        }

        this.teleporters.add(tp);
        break;

        case 'bp':
        brick = new Brick(this,col*BRICK_WIDTH,row*BRICK_HEIGHT,0,0,null,0,this.BRICK_SFX["brick_oranger"],'vvvvvv_bp',1);
        brick.tint = this.brickTint;
        break;

        case 'sp':
        brick = new Brick(this,col*BRICK_WIDTH,row*BRICK_HEIGHT,0,0,null,0,this.BRICK_SFX["brick_oranger"],'vvvvvv_sp',1);
        brick.solid = true;
        brick.tint = this.brickTint;
        break;
      }

      if (brick) {
        brick.y -= brick.height/3;
        this.game.physics.enable(brick, Phaser.Physics.ARCADE);
        brick.body.immovable = true;
        if (brick.solid) {
          this.solid_bricks.add(brick);
        }
        else {
          this.bricks.add(brick);
        }
      }
    },


    getLowestBrickY: function () {

      var lowestY = 0;
      this.bricks.forEachAlive(function (brick) {
        if (brick.y > lowestY) lowestY = brick.y;
      },this);

      return lowestY;

    },


    checkOverlap: function (spriteA, spriteB) {

      var boundsA = spriteA.getBounds();
      var boundsB = spriteB.getBounds();

      return Phaser.Rectangle.intersects(boundsA, boundsB);

    },


    exitToMenu: function () {

      this.game.state.start(MENU_STATE);

    },


    shutdown: function () {

      this.paddle.destroy();
      this.ball.destroy();
      this.walls.destroy();
      this.bricks.destroy();

      this.scoreText.destroy();

      this.game.sound.remove(this.launch_wall_sfx);
      this.game.sound.remove(this.paddle_sfx);

      for (var sfx in this.BRICK_SFX) {
        this.game.sound.remove(sfx);
      }

      this.gameOverBG.destroy();
      this.gameOverText.destroy();
      this.gameOverScoreText.destroy();
      this.gameOverScoreNumberText.destroy();

    },

    flashSprite: function (sprite, duration) {

      sprite.flashTimer = this.time.events.repeat(Phaser.Timer.SECOND * 0.1, duration / 0.1,
        function (sprite) {
          sprite.visible = !sprite.visible
        },
        this, sprite);

      },



    };



    var VVVVVV_LEVEL_1 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','vv','vv','vv','vv','vv','bp','bp','bp','bp','bp','bp','vv','vv','vv','vv','vv','bp','bp'],
      ['bp','bp','  ','  ','  ','  ','  ','bp','bp','bp','bp','bp','bp','  ','  ','  ','  ','  ','bp','bp'],
      ['bp','bp','  ','  ','  ','  ','  ','bp','bp','bp','bp','bp','bp','  ','  ','  ','  ','  ','bp','bp'],
      ['bp','bp','  ','  ','  ','  ','  ','bp','bp','bp','bp','bp','bp','  ','  ','  ','  ','  ','bp','bp'],
      ['bp','bp','  ','  ','  ','  ','  ','bp','bp','bp','bp','bp','bp','  ','  ','  ','  ','  ','bp','bp'],
      ['bp','bp','  ','  ','  ','  ','  ','bp','bp','bp','bp','bp','bp','  ','  ','  ','  ','  ','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^'],
    ];


    var VVVVVV_LEVEL_2 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','vv','bp','bp','bp','bp','vv','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','  ','bp','vv','bp','bp','  ','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','  ','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','vv','bp','bp','vv','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','  ','bp','bp','  ','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^'],
    ];


    var VVVVVV_LEVEL_3 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','><','  ','  ','  ','  ','  ','  ','  ','  ','  ','><','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','><','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^'],
    ];


    var VVVVVV_LEVEL_4 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
      ['vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv','vv'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    ];


    var VVVVVV_LEVEL_5 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','t1','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['bp','bp','t2','bp','bp','bp','t1','bp','bp','bp','t3','bp','bp','bp','t3','bp','bp','bp','t2','bp'],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^'],
    ];



    // var VVVVVV_LEVEL_5 = [
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','t1','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
    //   ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
    //   ['sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp','sp'],
    //   ['bp','bp','t2','bp','bp','bp','t1','bp','bp','bp','t3','bp','bp','bp','t3','bp','bp','bp','t2','bp'],
    //   ['bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp'],
    //   ['bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp'],
    //   ['bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp'],
    //   ['bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp','bp','bp','  ','bp'],
    //   ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
    //   ['bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp','bp'],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
    //   ['^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^','^^'],
    // ];



    var VVVVVV_LEVEL_6 = [
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  '],
      ['sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp'],
      ['sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp'],
      ['sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp'],
      ['sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp'],
      ['sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp'],
      ['sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp'],
      ['sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp'],
      ['sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp'],
      ['sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp'],
      ['sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp','sp'],
      ['sp','sp','sp','sp','sp','sp','sp','sp','  ','  ','  ','  ','sp','sp','sp','sp','sp','sp','sp','sp'],
    ];

    BasicGame.VVVVVV1.prototype.constructor = BasicGame.VVVVVV1;
