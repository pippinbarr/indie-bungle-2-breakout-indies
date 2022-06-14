BasicGame.TheGraveyard2 = function (game) {
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


BasicGame.TheGraveyard2.prototype = new Phaser.State();

BasicGame.TheGraveyard2.prototype.parent = Phaser.State;

TheGraveyardState = {
  START: 'START',
  PLAY: 'PLAY',
  GAME_OVER: 'GAME_OVER',
  GAME_OVER_SCREEN: 'GAME_OVER_SCREEN',
  PAUSED: 'PAUSED',
  LOST_PADDLE: 'LOST_PADDLE'
};

BasicGame.TheGraveyard2.prototype = {

  create: function () {

    Phaser.State.prototype.create.call(this);

    // console.log("GraveyardDead = " + localStorage.getItem('GraveyardDead'));

    // this.game.sound.mute = true;

    PADDLE_SPEED = 600;
    PADDLE_WIDTH = 70;
    PADDLE_HEIGHT = 10;

    BALL_SPEED = 150;
    BALL_X_SPEED = 200;
    BALL_SIZE = 10;

    BRICKS = [];
    MAX_BRICK_ROWS = 12;
    BRICKS_Y_OFFSET = 110;
    BRICK_WIDTH = 30;
    BRICK_HEIGHT = 15;

    NUM_PADDLES = 5;

    SEEN_CONTROLS = false;
    CONTROLS_SEEN_THRESHOLD = 60;

    BG_START_COLOR = '#888888';
    BRICK_START_COLOR = '#444444';



    this.currentStateName = 'Breakout';

    this.game.stage.backgroundColor = BG_START_COLOR;
    this.brickColor = BRICK_START_COLOR;


    this.state = TheGraveyardState.START;

    this.physics.startSystem(Phaser.Physics.ARCADE);


    // PADDLE


    this.paddle = this.game.add.sprite(0,0,'white_pixel');
    this.paddle.tint = 0x111111;
    this.paddle.width = PADDLE_WIDTH;
    this.paddle.height = PADDLE_HEIGHT;
    this.paddle.x = this.game.canvas.width/2 - this.paddle.width/2;
    this.paddle.y = this.game.canvas.height - 3*this.paddle.height;
    this.game.physics.enable(this.paddle, Phaser.Physics.ARCADE);
    this.paddle.body.immovable = true;


    // BALL

    this.ball = this.game.add.sprite(0,0,'white_pixel');
    this.ball.tint = 0x111111;
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


    touchLeftPressed = false;
    touchRightPressed = false;

    document.addEventListener("touchstart", this.touchInputDown.bind(this), false);
    document.addEventListener("touchend", this.touchInputUp.bind(this), false);


    // Handle death

    if (localStorage.getItem('GraveyardDead') == 'true') {
      this.paddle.x = -1000;
      this.ball.x = 10000;
      this.setDeadBricks();

      newGameButton = this.add.sprite(0,0,'new_game');
      newGameButton.x = this.game.width/2 - newGameButton.width/2;
      newGameButton.y = this.game.height - 80;
      newGameButton.inputEnabled = true;
      newGameButton.events.onInputUp.add(this.newGameButtonUp.bind(this));

      return;
    }


    this.addSong();

    this.resetGame();

    if (Math.random() < 0.5) {
      // Will die in this game
      this.deathTimer = this.game.time.events.add(Phaser.Timer.SECOND * 10 + (Math.random() * Phaser.Timer.SECOND * 120), this.die.bind(this), this);
    }

  },


  newGameButtonUp: function () {
    // console.log("New game button up");
    localStorage.setItem('GraveyardDead','false');
    this.game.state.start('TheGraveyard');
  },


  die: function () {
    this.paddle.body.velocity.y = 100;
    this.state = TheGraveyardState.GAME_OVER;

    var bricksArray = [];
    this.bricks.forEachAlive(function (brick) {
      if (brick.visible) bricksArray.push({x: brick.x, y: brick.y, tint: brick.tint});
    });

    localStorage.setItem('GraveyardDead', 'true');
    localStorage.setItem('GraveyardBricks', JSON.stringify(bricksArray));

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

    this.handleInput();

    // PHYSICS

    this.physics.arcade.overlap(this.paddle,this.walls,this.handlePaddleWallColliders,null,this);
    // this.physics.arcade.overlap(this.paddle,this.rightGraves,this.handlePaddleWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.walls,this.handleBallWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.leftGraves,this.handleBallWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.rightGraves,this.handleBallWallColliders,null,this);

    if (this.state == TheGraveyardState.PLAY) {

      this.physics.arcade.collide(this.ball,this.paddle,this.handleBallPaddleColliders,null,this);
      this.physics.arcade.overlap(this.ball,this.bricks,this.handleBallBrickColliders.bind(this),null,this);
      this.physics.arcade.overlap(this.ball,this.bench,this.handleBallBenchColliders.bind(this),null,this);

      this.checkBallOut();
    }

  },


  handleInput: function () {

    // You can always exit
    if (this.exitPressed()) {
      this.exitToMenu();
    }

    // You can't move the paddle unless you're playing or the ball is about to launch
    if (this.state == TheGraveyardState.GAME_OVER || this.state == TheGraveyardState.LOST_PADDLE || !this.paddle.visible) return;

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

    if (this.state != TheGraveyardState.PLAY) return;

    if (this.ball.visible && this.ball.y > this.game.canvas.height)
    {
      this.lostPaddle();
    }

  },


  lostPaddle: function () {

    // this.updateScore(1);
    this.resetBall();
    if (this.state != TheGraveyardState.GAME_OVER) this.state = TheGraveyardState.START;

  },


  gameOver: function () {

    this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
    this.paddle.body.velocity.x = this.paddle.body.velocity.y = 0;
    this.state = TheGraveyardState.GAME_OVER;

    this.game.time.events.add(Phaser.Timer.SECOND * 1, this.showGameOver, this);

  },


  showGameOver: function () {

    this.bricks.visible = false;
    this.ball.visible = false;
    this.paddle.visible = false;
    this.walls.visible = false;
    // this.scoreText.visible = false;
    // this.paddlesText.visible = false;

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

    this.state = TheGraveyardState.GAME_OVER_SCREEN;

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
        paddle.body.x = this.leftWall.body.x + this.leftWall.width;
      }
      else if (wall == this.rightWall) {
        paddle.body.x = this.rightWall.body.x - paddle.width;
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
      this.ball.pvy *= -1;


    },


    handleBallBrickColliders: function (ball,brick) {

      if (!ball.collides) {
        return;
      }

      // brick.sfx.play();
      this.song.play('' + this.wordIndex);
      this.wordIndex++;

      ball.body.velocity.y *= -1;
      this.ball.pvy *= -1;


      ball.collides = false;

      brick.disable();
      brick.alive = false;


    },


    handleBallBenchColliders: function (ball,brick) {
      // Go to next screen (maybe just a new level altogether)
      this.game.state.start('TheGraveyard2')
    },


    handleBallWallColliders: function (ball,wall) {

      if (wall == this.topWall) ball.collides = true;

      this.launch_wall_sfx.play();

    },


    resetGame: function () {

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

      // this.limpTimer = this.game.time.events.add(Phaser.Timer.SECOND * 0.01, this.startLimp, this, this.ball);

      // this.startLimp();

      this.launch_wall_sfx.play();

      if (this.state != TheGraveyardState.GAME_OVER) this.state = TheGraveyardState.PLAY;

    },

    startLimp: function (ball) {
      this.ball.pvx = this.ball.body.velocity.x;
      this.ball.pvy = this.ball.body.velocity.y;

      this.limp();
    },


    limp: function (ball) {
      this.ball.body.velocity.x *= 0.5;
      this.ball.body.velocity.y *= 0.5;


      if (this.ball.body.velocity.y < 2 && this.ball.body.velocity.y > -2) {
        this.endLimp();
      }
      else {
        this.limpTimer = this.game.time.events.add(Phaser.Timer.SECOND * 0.1, this.limp, this, this.ball);
      }
    },


    endLimp: function (ball) {
      this.ball.body.velocity.x = this.ball.pvx;
      this.ball.body.velocity.y = this.ball.pvy;

      this.limpTimer = this.game.time.events.add(Phaser.Timer.SECOND * 0.3, this.startLimp, this, this.ball);
    },


    resetBricks: function () {


      BRICKS = [];
      this.bricks.removeAll();

      var numBricks = 0;

      var startX = BRICK_WIDTH/2;
      var startY = BRICK_WIDTH/2//BRICKS_Y_OFFSET;

      for (var y = startY; BRICKS_Y_OFFSET + MAX_BRICK_ROWS * BRICK_HEIGHT; y += BRICK_HEIGHT*1.5) {

        for (var x = startX; x + BRICK_WIDTH <= this.game.width; x += BRICK_WIDTH) {

          var tints = ['2','3','4','5'];
          var tintNum = tints[Math.floor(Math.random() * tints.length)];
          var brickColor = '#' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '';

          var brick = new Brick(this,x,y,0,0,brickColor,0,null);
          this.game.physics.enable(brick, Phaser.Physics.ARCADE);
          brick.body.immovable = true;
          this.bricks.add(brick);

          numBricks++;

          if (numBricks >= this.numWords) break;

        }

        if (numBricks >= this.numWords) break;

      }

    },



    setDeadBricks: function () {

      this.bricks.removeAll();

      var startX = BRICK_WIDTH/2;
      var startY = BRICK_WIDTH/2//BRICKS_Y_OFFSET;

      var deadBricks = JSON.parse(localStorage.getItem('GraveyardBricks'));

      for (var i = 0; i < deadBricks.length; i++) {
        var brick = new Brick(this,deadBricks[i].x,deadBricks[i].y,0,0,deadBricks[i].tint,null);
        this.bricks.add(brick);
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

    addSong: function () {
      this.wordIndex = 1;
      this.numWords = 223;

      this.song = this.game.add.audio('acid_on_granite',1);
      // this.song.addMarker("1",0.06,0.42);

      this.song.addMarker("1",0,0.44);
      this.song.addMarker("2",0.59,0.51);
      this.song.addMarker("3",1.26,0.45);
      this.song.addMarker("4",1.91,0.41);
      this.song.addMarker("5",2.47,0.52);
      this.song.addMarker("6",3.18,0.57);
      this.song.addMarker("7",3.93,0.55);
      this.song.addMarker("8",4.63,0.54);
      this.song.addMarker("9",5.32,0.54);
      this.song.addMarker("10",6.01,0.54);
      this.song.addMarker("11",6.71,0.51);
      this.song.addMarker("12",7.39,0.57);
      this.song.addMarker("13",8.12,0.41);
      this.song.addMarker("14",8.67,0.65);
      this.song.addMarker("15",9.46,0.5);
      this.song.addMarker("16",10.14,0.75);
      this.song.addMarker("17",11.12,0.44);
      this.song.addMarker("18",11.78,0.41);
      this.song.addMarker("19",12.33,0.4);
      this.song.addMarker("20",12.9,0.52);
      this.song.addMarker("21",13.63,0.45);
      this.song.addMarker("22",14.23,0.53);
      this.song.addMarker("23",14.91,0.4);
      this.song.addMarker("24",15.46,0.52);
      this.song.addMarker("25",16.48,0.56);
      this.song.addMarker("26",17.19,0.53);
      this.song.addMarker("27",17.89,0.49);
      this.song.addMarker("28",18.58,0.75);
      this.song.addMarker("29",19.49,0.64);
      this.song.addMarker("30",20.27,0.51);
      this.song.addMarker("31",20.93,0.57);
      this.song.addMarker("32",21.66,0.53);
      this.song.addMarker("33",22.34,0.54);
      this.song.addMarker("34",23.02,0.64);
      this.song.addMarker("35",23.84,0.52);
      this.song.addMarker("36",24.56,0.54);
      this.song.addMarker("37",25.24,0.52);
      this.song.addMarker("38",25.91,0.4);
      this.song.addMarker("39",26.5,0.54);
      this.song.addMarker("40",27.19,0.51);
      this.song.addMarker("41",27.85,0.55);
      this.song.addMarker("42",28.54,0.58);
      this.song.addMarker("43",29.31,0.44);
      this.song.addMarker("44",29.9,0.43);
      this.song.addMarker("45",30.48,0.57);
      this.song.addMarker("46",31.54,0.46);
      this.song.addMarker("47",32.22,0.52);
      this.song.addMarker("48",32.9,0.53);
      this.song.addMarker("49",33.58,0.72);
      this.song.addMarker("50",34.49,0.49);
      this.song.addMarker("51",35.17,0.49);
      this.song.addMarker("52",35.8,0.51);
      this.song.addMarker("53",36.46,0.5);
      this.song.addMarker("54",37.11,0.54);
      this.song.addMarker("55",37.78,0.47);
      this.song.addMarker("56",38.4,0.51);
      this.song.addMarker("57",39.05,0.51);
      this.song.addMarker("58",39.75,0.57);
      this.song.addMarker("59",40.51,0.45);
      this.song.addMarker("60",41.1,0.55);
      this.song.addMarker("61",41.79,0.57);
      this.song.addMarker("62",42.53,0.4);
      this.song.addMarker("63",43.09,0.48);
      this.song.addMarker("64",43.77,0.49);
      this.song.addMarker("65",44.44,0.57);
      this.song.addMarker("66",45.16,0.59);
      this.song.addMarker("67",45.95,0.7);
      this.song.addMarker("68",47.17,0.5);
      this.song.addMarker("69",47.83,0.61);
      this.song.addMarker("70",48.6,0.5);
      this.song.addMarker("71",49.27,0.54);
      this.song.addMarker("72",49.99,0.63);
      this.song.addMarker("73",50.76,0.54);
      this.song.addMarker("74",51.49,0.46);
      this.song.addMarker("75",52.1,0.49);
      this.song.addMarker("76",52.76,0.45);
      this.song.addMarker("77",53.4,0.45);
      this.song.addMarker("78",54.01,0.45);
      this.song.addMarker("79",54.62,0.48);
      this.song.addMarker("80",55.24,0.5);
      this.song.addMarker("81",55.86,0.58);
      this.song.addMarker("82",56.63,0.51);
      this.song.addMarker("83",57.34,0.45);
      this.song.addMarker("84",57.97,0.49);
      this.song.addMarker("85",58.61,0.57);
      this.song.addMarker("86",59.38,0.45);
      this.song.addMarker("87",59.98,0.51);
      this.song.addMarker("88",60.63,0.65);
      this.song.addMarker("89",61.47,0.56);
      this.song.addMarker("90",62.19,0.57);
      this.song.addMarker("91",63.26,0.55);
      this.song.addMarker("92",63.96,0.47);
      this.song.addMarker("93",64.59,0.59);
      this.song.addMarker("94",65.32,0.5);
      this.song.addMarker("95",65.98,0.61);
      this.song.addMarker("96",66.76,0.61);
      this.song.addMarker("97",67.55,0.53);
      this.song.addMarker("98",68.23,0.58);
      this.song.addMarker("99",68.95,0.52);
      this.song.addMarker("100",69.65,0.41);
      this.song.addMarker("101",70.24,0.54);
      this.song.addMarker("102",70.94,0.48);
      this.song.addMarker("103",71.57,0.54);
      this.song.addMarker("104",72.27,0.65);
      this.song.addMarker("105",73.08,0.57);
      this.song.addMarker("106",73.8,0.49);
      this.song.addMarker("107",74.43,0.53);
      this.song.addMarker("108",75.1,0.53);
      this.song.addMarker("109",75.79,0.51);
      this.song.addMarker("110",76.45,0.51);
      this.song.addMarker("111",77.11,0.4);
      this.song.addMarker("112",77.68,0.57);
      this.song.addMarker("113",78.42,0.45);
      this.song.addMarker("114",79.03,0.53);
      this.song.addMarker("115",79.7,0.45);
      this.song.addMarker("116",80.32,0.55);
      this.song.addMarker("117",81.05,0.44);
      this.song.addMarker("118",81.65,0.49);
      this.song.addMarker("119",82.27,0.51);
      this.song.addMarker("120",82.97,0.48);
      this.song.addMarker("121",83.64,0.39);
      this.song.addMarker("122",84.22,0.48);
      this.song.addMarker("123",85.2,0.47);
      this.song.addMarker("124",85.84,0.63);
      this.song.addMarker("125",86.63,0.75);
      this.song.addMarker("126",87.54,0.58);
      this.song.addMarker("127",88.26,0.53);
      this.song.addMarker("128",88.89,0.45);
      this.song.addMarker("129",89.49,0.46);
      this.song.addMarker("130",90.22,0.41);
      this.song.addMarker("131",90.8,0.55);
      this.song.addMarker("132",91.5,0.54);
      this.song.addMarker("133",92.21,0.57);
      this.song.addMarker("134",92.95,0.53);
      this.song.addMarker("135",93.55,0.52);
      this.song.addMarker("136",94.24,0.51);
      this.song.addMarker("137",94.9,0.58);
      this.song.addMarker("138",95.64,0.61);
      this.song.addMarker("139",96.41,0.49);
      this.song.addMarker("140",97.08,0.52);
      this.song.addMarker("141",97.78,0.39);
      this.song.addMarker("142",98.32,0.54);
      this.song.addMarker("143",98.94,0.47);
      this.song.addMarker("144",99.56,0.55);
      this.song.addMarker("145",100.26,0.56);
      this.song.addMarker("146",100.97,0.54);
      this.song.addMarker("147",101.78,0.53);
      this.song.addMarker("148",102.65,0.49);
      this.song.addMarker("149",103.29,0.41);
      this.song.addMarker("150",103.87,0.55);
      this.song.addMarker("151",104.59,0.5);
      this.song.addMarker("152",105.26,0.39);
      this.song.addMarker("153",105.81,0.61);
      this.song.addMarker("154",106.57,0.41);
      this.song.addMarker("155",107.13,0.55);
      this.song.addMarker("156",107.87,0.66);
      this.song.addMarker("157",108.7,0.69);
      this.song.addMarker("158",109.57,0.57);
      this.song.addMarker("159",110.31,0.66);
      this.song.addMarker("160",111.16,0.46);
      this.song.addMarker("161",111.77,0.7);
      this.song.addMarker("162",112.66,0.39);
      this.song.addMarker("163",113.22,0.51);
      this.song.addMarker("164",113.88,0.49);
      this.song.addMarker("165",114.52,0.55);
      this.song.addMarker("166",115.22,0.51);
      this.song.addMarker("167",115.88,0.57);
      this.song.addMarker("168",116.97,0.55);
      this.song.addMarker("169",117.67,0.47);
      this.song.addMarker("170",118.3,0.59);
      this.song.addMarker("171",119.04,0.53);
      this.song.addMarker("172",119.73,0.61);
      this.song.addMarker("173",120.48,0.53);
      this.song.addMarker("174",121.16,0.61);
      this.song.addMarker("175",121.95,0.54);
      this.song.addMarker("176",122.64,0.58);
      this.song.addMarker("177",123.37,0.52);
      this.song.addMarker("178",124.06,0.41);
      this.song.addMarker("179",124.66,0.54);
      this.song.addMarker("180",125.35,0.49);
      this.song.addMarker("181",125.98,0.55);
      this.song.addMarker("182",126.69,0.64);
      this.song.addMarker("183",127.49,0.57);
      this.song.addMarker("184",128.21,0.49);
      this.song.addMarker("185",128.85,0.53);
      this.song.addMarker("186",129.54,0.51);
      this.song.addMarker("187",130.23,0.47);
      this.song.addMarker("188",130.85,0.52);
      this.song.addMarker("189",131.51,0.4);
      this.song.addMarker("190",132.08,0.57);
      this.song.addMarker("191",132.83,0.44);
      this.song.addMarker("192",133.43,0.53);
      this.song.addMarker("193",134.11,0.44);
      this.song.addMarker("194",134.73,0.54);
      this.song.addMarker("195",135.45,0.45);
      this.song.addMarker("196",136.06,0.48);
      this.song.addMarker("197",136.68,0.51);
      this.song.addMarker("198",137.37,0.49);
      this.song.addMarker("199",138.04,0.39);
      this.song.addMarker("200",138.61,0.49);
      this.song.addMarker("201",139.61,0.47);
      this.song.addMarker("202",140.26,0.45);
      this.song.addMarker("203",140.89,0.51);
      this.song.addMarker("204",141.56,0.51);
      this.song.addMarker("205",142.21,0.45);
      this.song.addMarker("206",142.82,0.56);
      this.song.addMarker("207",143.54,0.61);
      this.song.addMarker("208",144.3,0.56);
      this.song.addMarker("209",145.07,0.53);
      this.song.addMarker("210",145.74,0.57);
      this.song.addMarker("211",146.51,0.54);
      this.song.addMarker("212",147.23,0.65);
      this.song.addMarker("213",148.07,0.53);
      this.song.addMarker("214",148.88,0.46);
      this.song.addMarker("215",149.64,0.58);
      this.song.addMarker("216",150.36,0.51);
      this.song.addMarker("217",151.03,0.57);
      this.song.addMarker("218",151.75,0.41);
      this.song.addMarker("219",152.34,0.51);
      this.song.addMarker("220",153,0.5);
      this.song.addMarker("221",153.65,0.54);
      this.song.addMarker("222",154.35,0.5);
      this.song.addMarker("223",155,0.54);
    }

  };


  BasicGame.TheGraveyard2.prototype.constructor = BasicGame.TheGraveyard2;
