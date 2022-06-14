BasicGame.TheArtistIsPresent2 = function (game) {
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


BasicGame.TheArtistIsPresent2.prototype = new Phaser.State();

BasicGame.TheArtistIsPresent2.prototype.parent = Phaser.State;

TheArtistIsPresent2State = {
  START: 'START',
  PLAY: 'PLAY',
  GAME_OVER: 'GAME_OVER',
  GAME_OVER_SCREEN: 'GAME_OVER_SCREEN',
  PAUSED: 'PAUSED',
  LOST_PADDLE: 'LOST_PADDLE'
};

BasicGame.TheArtistIsPresent2.prototype = {

  create: function () {

    Phaser.State.prototype.create.call(this);

    // this.game.sound.mute = true;

    PADDLE_SPEED = 600;
    PADDLE_WIDTH = 70;
    PADDLE_HEIGHT = 10;

    // BALL_SPEED = 250;
    // BALL_X_SPEED = 300;
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

    BG_START_COLOR = '#4C4D4E';

    SIT_TIMES = [2,2,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,8,
			9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,
			11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,
			13,13,13,13,13,13,13,13,13,14,14,14,14,14,
			15,15,15,15,15,15,15,15,15,15,15,16,16,16,16,
			17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,19,19,
			20,20,20,20,20,20,20,28,30,30,30,40,50,60,60,60,70,80,90,
			100,120,240,480];

    this.currentStateName = 'Breakout';

    this.game.stage.backgroundColor = BG_START_COLOR;
    // this.brickColor = BRICK_START_COLOR;


    this.state = TheArtistIsPresent2State.START;

    this.physics.startSystem(Phaser.Physics.ARCADE);


    // PADDLE

    this.paddle = this.game.add.sprite(0,0,'white_pixel');
    this.paddle.width = PADDLE_WIDTH;
    this.paddle.height = PADDLE_HEIGHT;
    this.paddle.x = this.game.canvas.width/2 - this.paddle.width/2;
    this.paddle.y = this.game.canvas.height - 3*this.paddle.height;
    this.game.physics.enable(this.paddle, Phaser.Physics.ARCADE);
    this.paddle.body.immovable = true;


    // BALL

    this.ball = this.game.add.sprite(0,0,'white_pixel');
    this.ball.width = this.ball.height = BALL_SIZE;
    this.ball.x = this.game.canvas.width/2 - this.ball.width/2;
    this.ball.y = this.game.canvas.height/2 + this.ball.height*4;
    this.game.physics.enable(this.ball, Phaser.Physics.ARCADE);
    this.ball.body.bounce.setTo(1,1);

    this.ball.collides = false;

    this.ball.body.velocity.x = 0;
    this.ball.body.velocity.y = 0;
    this.ball.body.x = this.paddle.x + this.paddle.width/2 - this.ball.width/2;
    this.ball.body.y = this.paddle.y - 160;

    // flag_left

    // WALLS

    this.walls = this.game.add.group();

    this.leftWall = this.game.add.sprite(0,0,'white_pixel');
    this.leftWall.width = 100;
    this.leftWall.height = this.game.height + 40;
    this.leftWall.x = 0 - this.leftWall.width;
    this.leftWall.y = -40;
    this.game.physics.enable(this.leftWall, Phaser.Physics.ARCADE);
    this.walls.add(this.leftWall);
    this.leftWall.body.immovable = true;

    this.rightWall = this.game.add.sprite(0,0,'white_pixel');
    this.rightWall.width = 100;
    this.rightWall.height = this.game.height + 40;
    this.rightWall.x = this.game.width;
    this.rightWall.y = -40;
    this.game.physics.enable(this.rightWall, Phaser.Physics.ARCADE);
    this.walls.add(this.rightWall);
    this.rightWall.body.immovable = true;

    this.topWall = this.game.add.sprite(0,0,'white_pixel');
    this.topWall.width = this.game.width + 80;
    this.topWall.height = 100;
    this.topWall.x = -40;
    this.topWall.y = -this.topWall.height;
    this.game.physics.enable(this.topWall, Phaser.Physics.ARCADE);
    this.walls.add(this.topWall);
    this.topWall.body.immovable = true;



    this.chair = this.game.add.sprite(0,0,'taip_left_chair');
    this.chair.width *= 4; this.chair.height *= 4;
    this.table = this.game.add.sprite(0,0,'taip_table_and_chair');
    this.table.width *= 4; this.table.height *= 4;
    this.marina = this.game.add.sprite(0,0,'taip_sitting_marina');
    this.marina.width *= 4; this.marina.height *= 4;

    this.chair.x = this.game.width/2 - (this.chair.width + this.table.width)/2;
    this.chair.y = 20;
    this.table.x = this.chair.x + this.chair.width;
    this.table.y = this.chair.y;
    this.marina.x = this.table.x + 60;
    this.marina.y = this.table.y - 16;

    this.game.physics.enable(this.chair, Phaser.Physics.ARCADE);
    this.chair.body.immovable = true;
    this.game.physics.enable(this.table, Phaser.Physics.ARCADE);
    this.table.body.immovable = true;
    this.game.physics.enable(this.marina, Phaser.Physics.ARCADE);
    this.marina.body.immovable = true;



    // SOUNDS

    this.launch_wall_sfx = this.game.add.audio('launch_wall_sfx',1);
    this.paddle_sfx = this.game.add.audio('paddle_sfx',1);

    if (!this.BRICK_SFX) {
      this.BRICK_SFX = {};
      this.BRICK_SFX["brick_blue"] = this.game.add.audio('brick_blue_sfx',1);
      this.BRICK_SFX["brick_green"] = this.game.add.audio('brick_green_sfx',1);
      this.BRICK_SFX["brick_yellow"] = this.game.add.audio('brick_yellow_sfx',1);
      this.BRICK_SFX["brick_orange"] = this.game.add.audio('brick_orange_sfx',1);
      this.BRICK_SFX["brick_oranger"] = this.game.add.audio('brick_oranger_sfx',1);
      this.BRICK_SFX["brick_red"] = this.game.add.audio('brick_red_sfx',1);
    }

    // BRICKS

    this.bricks = this.game.add.group();

    // TEXTS

    // Score

    this.score = 0;
    this.scoreText = this.game.add.bitmapText(0, 8, 'atari','',120);
    this.scoreText.tint = 0xFFFFFF;
    this.scoreText.scale.x = 0.75;
    this.scoreText.scale.y = 0.25;
    this.scoreText.visible = false;


    this.updateScore(this.score);


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


    this.closingMessage = this.game.add.sprite(0,0,'taip_closing_message');
    this.closingMessage.x = this.game.width/2 - this.closingMessage.width/2;
    this.closingMessage.y = this.game.height/2 - this.closingMessage.height/2;
    this.closingMessage.visible = false;

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

    this.handleTime();

    this.handleInput();

    // PHYSICS

    this.physics.arcade.overlap(this.paddle,this.walls,this.handlePaddleWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.walls,this.handleBallWallColliders,null,this);

    this.physics.arcade.collide(this.ball,this.chair,function (ball,chair) {this.game.state.start('TheArtistIsPresent')},null,this);
    this.physics.arcade.collide(this.ball,this.table,this.handleBallWallColliders,null,this);

    if (this.state == TheArtistIsPresent2State.PLAY) {

      this.physics.arcade.collide(this.ball,this.paddle,this.handleBallPaddleColliders,null,this);
      this.physics.arcade.overlap(this.ball,this.bricks,this.handleBallBrickColliders.bind(this),null,this);

      this.checkBallOut();
    }

  },


  handleTime: function () {

    var nycTime = WallTime.UTCToWallTime(new Date().getTime(),"America/New_York");

    if (nycTime.getHours() == 17 && nycTime.getMinutes() == 15 && !this.shownClosingMessage) {
      this.shownClosingMessage = true;
      this.closingMessage.visible = true;
      this.ball.pvx = this.ball.body.velocity.x;
      this.ball.pvy = this.ball.body.velocity.y;
      this.ball.body.velocity.x = 0;
      this.ball.body.velocity.y = 0;
      this.game.time.events.add(Phaser.Timer.SECOND * 5, this.hideClosingMessage, this);
    }
    else if (nycTime.getHours() == 17 && nycTime.getMinutes() == 30) {
      MUSEUM_JUST_CLOSED = true;
      this.game.state.start('TheArtistIsPresent');
    }

  },


  hideClosingMessage: function () {
    this.closingMessage.visible = false;
    this.ball.body.velocity.x = this.ball.pvx;
    this.ball.body.velocity.y = this.ball.pvy;
  },


  handleInput: function () {

    // You can always exit
    if (this.exitPressed()) {
      this.exitToMenu();
    }

    // You can't move the paddle unless you're playing or the ball is about to launch
    if (this.state == TheArtistIsPresent2State.GAME_OVER || this.state == TheArtistIsPresent2State.LOST_PADDLE || !this.paddle.visible) return;

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

    if (this.state != TheArtistIsPresent2State.PLAY) return;

    if (this.ball.visible && this.ball.y > this.game.canvas.height)
    {
      this.lostPaddle();
    }

  },


  lostPaddle: function () {

    this.updateScore(1);
    this.resetBall();
    this.state = TheArtistIsPresent2State.START;

  },


  gameOver: function () {

    this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
    this.paddle.body.velocity.x = this.paddle.body.velocity.y = 0;
    this.state = TheArtistIsPresent2State.GAME_OVER;

    this.game.time.events.add(Phaser.Timer.SECOND * 1, this.showGameOver, this);

  },


  showGameOver: function () {

    this.bricks.visible = false;
    this.ball.visible = false;
    this.paddle.visible = false;
    this.walls.visible = false;
    this.scoreText.visible = false;
    this.paddlesText.visible = false;

    this.gameOverBG.visible = true;
    this.gameOverText.visible = true;
    this.gameOverScoreText.visible = true;
    this.gameOverScoreNumberText.visible = true;

    this.gameOverScoreText.text = this.gameOverScoreString;
    this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    this.gameOverScoreNumberText.text = this.score.toString();

    this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    this.gameOverScoreNumberText.x = this.game.width/2 - this.gameOverScoreNumberText.width/2;
    this.gameOverScoreNumberText.y = this.gameOverScoreText.y + 2 * this.gameOverScoreText.height;

    this.state = TheArtistIsPresent2State.GAME_OVER_SCREEN;

    this.game.time.events.add(Phaser.Timer.SECOND * 3, this.exitToMenu, this);
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

      // Set the vertical speed according to time

      var timeInSeconds = SIT_TIMES[Math.floor(Math.random() * SIT_TIMES.length)] * 60;
      var pvy = -BALL_SPEED;
      this.ball.body.velocity.y = -((this.game.height / 2) / timeInSeconds);
      this.ball.body.velocity.x *= Math.abs(this.ball.body.velocity.y/pvy)
      this.ball.body.y = this.paddle.body.y - this.ball.height;
    },


    handleBallBrickColliders: function (ball,brick) {

      if (!ball.collides) {
        return;
      }

      // console.log("Playing sfx of brick " + brick + ", sfx is " + brick.sfx);
      // console.log("Context of sfx is " + brick.sfx.context);
      brick.sfx.play();

      ball.body.velocity.y *= -1;
      // if (this.ball.body.velocity.y > 0) this.ball.body.velocity.y = BALL_SPEED;
      // else if (this.ball.body.velocity.y < 0) this.ball.body.velocity.y = -BALL_SPEED;

      ball.collides = false;

      brick.disable();
      brick.alive = false;

    },


    handleBallWallColliders: function (ball,wall) {

      if (wall == this.topWall) {
        // Set the vertical speed according to time
        // var timeInSeconds = SIT_TIMES[Math.floor(Math.random() * SIT_TIMES.length)] * 60;
        // We'll use this as the time it need to take to get to the top of the screen (so it'll be a little 'fast')
        // this.ball.body.velocity.y = ((this.game.height / 2) / timeInSeconds);
        // this.ball.body.velocity.x *= Math.abs(this.ball.body.velocity.y/pvy)

        ball.collides = true;
      }

      this.launch_wall_sfx.play();

    },


    resetGame: function () {

      // Change tint of BG
      var newBGColor = '#' + ((this.game.stage.backgroundColor + 0x000001) % 0xffffff).toString (16);
      this.game.stage.backgroundColor = newBGColor;

      // Change tint of brick
      // this.brickColor = '#' + ((parseInt(this.brickColor.slice(1,this.brickColor.length), 16) + 0x000001) % 0xffffff).toString(16);

      this.resetBricks();
      this.resetBall();

    },


    resetBall: function () {

      this.ball.x = this.paddle.x + this.paddle.width/2 - this.ball.width/2;
      this.ball.y = this.paddle.y - 80;

      this.ball.body.velocity.x = 0;
      this.ball.body.velocity.y = 0;

      this.restartTimer = this.game.time.events.add(Phaser.Timer.SECOND * 2, this.restartBall, this, this.ball, this.paddle);
    },


    restartBall: function (ball,paddle) {

      this.ball.body.velocity.x = 20 - Math.random() * 40;
      this.ball.body.velocity.y = BALL_SPEED;


      // Set the vertical speed according to time
      var timeInSeconds = SIT_TIMES[Math.floor(Math.random() * SIT_TIMES.length)] * 60;
      var pvy = this.ball.body.velocity.y;
      this.ball.body.velocity.y = ((this.game.height / 2) / timeInSeconds);
      this.ball.body.velocity.x *= Math.abs(this.ball.body.velocity.y/pvy)

      this.launch_wall_sfx.play();

      this.state = TheArtistIsPresent2State.PLAY;

    },


    resetBricks: function () {
      // return;

      BRICKS = [];
      this.bricks.removeAll();

      for (var i = 0; i < 3; i++) {
        var xx = (i*14*4) + 7 - (Math.random() * 15)
        var brick = new Brick(this,xx,0,0,0,'#ffffff',0,this.BRICK_SFX["brick_oranger"],'person_' + (Math.floor(Math.random() * 3) + 1),4);
        this.game.physics.enable(brick, Phaser.Physics.ARCADE);
        brick.body.immovable = true;
        this.bricks.add(brick);
      }

      var startX = 40;
      var startY = 40;

      MAX_BRICK_ROWS = 2;

      var row = 0;
      for (var y = startY; row < MAX_BRICK_ROWS; y += 3*BRICK_HEIGHT) {
        for (var x = startX; x + 14*4 < this.game.width; x += 14*4) {
          var xx = x + 7 - (Math.random() * 15)
          var brick = new Brick(this,xx,y,0,0,'#ffffff',0,this.BRICK_SFX["brick_oranger"],'person_' + (Math.floor(Math.random() * 3) + 1),4);
          this.game.physics.enable(brick, Phaser.Physics.ARCADE);
          brick.body.immovable = true;
          if (row % 2 == 0) {
            brick.anchor.x = 0.5;
            brick.scale.x *= -1;
            // brick.anchor.x = 0;
          }
          this.bricks.add(brick);
          // console.log("brick")
        }
        row++;
        // console.log("row")
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

    }

  };


  BasicGame.TheArtistIsPresent2.prototype.constructor = BasicGame.TheArtistIsPresent2;
