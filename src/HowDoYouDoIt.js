BasicGame.HowDoYouDoIt = function (game) {
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


BasicGame.HowDoYouDoIt.prototype = new Phaser.State();

BasicGame.HowDoYouDoIt.prototype.parent = Phaser.State;

HowDoYouDoItState = {
  START: 'START',
  PLAY: 'PLAY',
  GAME_OVER: 'GAME_OVER',
  GAME_OVER_SCREEN: 'GAME_OVER_SCREEN',
  PAUSED: 'PAUSED',
  LOST_PADDLE: 'LOST_PADDLE'
};

BasicGame.HowDoYouDoIt.prototype = {

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

    NUM_PADDLES = 1; //5;

    SEEN_CONTROLS = false;
    CONTROLS_SEEN_THRESHOLD = 60;

    BRICK_START_COLOR = '#CB7735';



    this.currentStateName = 'Breakout';

    this.brickColor = BRICK_START_COLOR;

    this.brickColors = ['#FDB0A1','#CD8373','#FEC7BC'];


    this.state = HowDoYouDoItState.START;

    this.physics.startSystem(Phaser.Physics.ARCADE);


    this.bg = this.game.add.sprite(0,0,'hdydi_bg');
    this.bg.width = this.game.width;
    this.bg.height = this.game.height;

    this.girl_body = this.game.add.sprite(0,0,'hdydi_girl_body');
    this.girl_body.width *= 1.5;
    this.girl_body.height *= 1.5;
    this.girl_body.x = 0;
    this.girl_body.y = this.game.height - this.girl_body.height;

    this.girl_head = this.game.add.sprite(0,0,'hdydi_faces');
    this.girl_head.width *= 1.5;
    this.girl_head.height *= 1.5;
    this.girl_head.x = 80;
    this.girl_head.y = -60;

    this.girl_sounds = [];
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_1'));
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_2'));
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_3'));
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_4'));
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_5'));
    this.girl_sounds.push(this.game.add.audio('hdydi_girl_6'));

    this.click_sounds = [];
    this.click_sounds.push(this.game.add.audio('hdydi_click_1'));
    this.click_sounds.push(this.game.add.audio('hdydi_click_2'));
    this.click_sounds.push(this.game.add.audio('hdydi_click_3'));

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

    this.sex = 0;

    this.updateScore(this.score);

    this.paddles = NUM_PADDLES;
    this.paddlesText = this.game.add.bitmapText(0, 8, 'atari', '' + this.paddles, 120);
    this.paddlesText.tint = 0x888888;
    this.paddlesText.scale.x = 0.75;
    this.paddlesText.scale.y = 0.25;

    this.updatePaddles(this.paddles);


    // Game Over

    this.gameOverBG = this.game.add.sprite(0,0,'white_pixel');
    this.gameOverBG.width = this.game.canvas.width;
    this.gameOverBG.height = this.game.canvas.height;
    this.gameOverBG.tint = 0x000000;
    this.gameOverBG.visible = false;

    this.gameOverText = this.game.add.bitmapText(100, 100, 'atari','',18);
    this.gameOverText.x = this.game.width/2 - this.gameOverText.width/2;
    this.gameOverText.y = this.game.height/2;
    this.gameOverText.visible = false;

    // this.gameOverScoreText = this.game.add.bitmapText(100, 100, 'atari','',24);
    // this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    // this.gameOverScoreText.y = this.gameOverText.y + 2 * this.gameOverText.height;
    // this.gameOverScoreText.visible = false;
    //
    // this.gameOverScoreString = 'FINAL SCORE';
    //
    // this.gameOverScoreNumberText = this.game.add.bitmapText(100, 100, 'atari',this.gameOverScoreString,24);
    // this.gameOverScoreNumberText.x = this.game.width/2 - this.gameOverScoreNumberText.width/2;
    // this.gameOverScoreNumberText.y = this.gameOverScoreText.y + 1.2 * this.gameOverScoreText.height;
    // this.gameOverScoreNumberText.visible = false;


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

    this.handleInput();

    // PHYSICS

    this.physics.arcade.overlap(this.paddle,this.walls,this.handlePaddleWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.walls,this.handleBallWallColliders,null,this);

    if (this.state == HowDoYouDoItState.PLAY) {

      this.physics.arcade.collide(this.ball,this.paddle,this.handleBallPaddleColliders,null,this);
      this.physics.arcade.overlap(this.ball,this.bricks,this.handleBallBrickColliders.bind(this),null,this);

      this.checkBallOut();
    }

  },


  handleInput: function () {

    // You can always exit
    if (this.exitPressed()) {
      this.exitToMenu();
    }

    // You can't move the paddle unless you're playing or the ball is about to launch
    if (this.state == HowDoYouDoItState.GAME_OVER || this.state == HowDoYouDoItState.LOST_PADDLE || !this.paddle.visible) return;

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

    if (this.state != HowDoYouDoItState.PLAY) return;

    if (this.ball.visible && this.ball.y > this.game.canvas.height)
    {
      this.lostPaddle();
    }

  },


  lostPaddle: function () {

    // this.updateScore(1);

    this.paddles--;
    this.updatePaddles(this.paddles);

    if (this.paddles > 0) {
      this.resetBall();
      this.state = GameState.START;
      // this.game.time.events.add(Phaser.Timer.SECOND * 1, this.restartBall, this, this.ball, this.paddle);
    }
    else {
      this.gameOver();
    }

  },


  updatePaddles: function (paddles) {

    this.paddlesText.text = paddles.toString();
    this.paddlesText.x = this.game.canvas.width - 160 - this.paddlesText.width;

  },



  gameOver: function () {

    this.ball.body.velocity.x = this.ball.body.velocity.y = 0;
    this.paddle.body.velocity.x = this.paddle.body.velocity.y = 0;
    this.state = HowDoYouDoItState.GAME_OVER;

    this.game.time.events.add(Phaser.Timer.SECOND * 1, this.showGameOver, this);

  },


  showGameOver: function () {

    this.bricks.visible = false;
    this.ball.visible = false;
    this.paddle.visible = false;
    this.walls.visible = false;
    this.scoreText.visible = false;
    this.paddlesText.visible = false;

    this.gameOverText.text = "YOU MIGHT HAVE DONE SEX\n" + this.sex + " TIMES..."

    this.gameOverBG.visible = true;
    this.gameOverText.visible = true;
    // this.gameOverScoreText.visible = true;
    // this.gameOverScoreNumberText.visible = true;

    // this.gameOverScoreText.text = "You maybe did sex " + this.sex + "times.";
    // this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    // this.gameOverScoreNumberText.text = this.score.toString();

    // this.gameOverScoreText.x = this.game.width/2 - this.gameOverScoreText.width/2;
    // this.gameOverScoreNumberText.x = this.game.width/2 - this.gameOverScoreNumberText.width/2;
    // this.gameOverScoreNumberText.y = this.gameOverScoreText.y + 2 * this.gameOverScoreText.height;

    this.state = HowDoYouDoItState.GAME_OVER_SCREEN;

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

  },


  handleBallBrickColliders: function (ball,brick) {

    if (!ball.collides) {
      return;
    }

    ball.body.velocity.y *= -1;

    ball.collides = false;

    brick.disable();
    brick.alive = false;

    if (Math.random() < 0.4) {
      this.girl_head.frame = Math.floor(Math.random() * 8);
      this.girl_sounds[Math.floor(Math.random() * this.girl_sounds.length)].play();
    }
    // play a click
    this.click_sounds[Math.floor(Math.random() * this.click_sounds.length)].play();

    this.sex++;

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
    this.ball.y = this.paddle.y - 100;

    this.ball.body.velocity.x = 0;
    this.ball.body.velocity.y = 0;

    this.restartTimer = this.game.time.events.add(Phaser.Timer.SECOND * 2, this.restartBall, this, this.ball, this.paddle);
  },


  restartBall: function (ball,paddle) {

    this.ball.body.velocity.x = 20 - Math.random() * 40;
    this.ball.body.velocity.y = BALL_SPEED;

    this.launch_wall_sfx.play();

    this.state = HowDoYouDoItState.PLAY;

  },


  resetBricks: function () {

    BRICKS = [];
    this.bricks.removeAll();

    var startX = 0;
    var startY = BRICKS_Y_OFFSET + Math.floor(Math.random() * MAX_BRICK_ROWS/2)*BRICK_HEIGHT;
    var endY = BRICKS_Y_OFFSET + (MAX_BRICK_ROWS)*BRICK_HEIGHT;

    for (var x = startX; x < this.game.width; x += BRICK_WIDTH) {
      for (var y = startY; y < endY; y += BRICK_HEIGHT) {
          var brick = new Brick(this,x,y,0,0,this.brickColors[Math.floor(Math.random() * this.brickColors.length)],0,this.BRICK_SFX["brick_oranger"]);
          this.game.physics.enable(brick, Phaser.Physics.ARCADE);
          brick.body.immovable = true;
          this.bricks.add(brick);
      }

      startY = Math.random() < 0.5 ? startY + BRICK_HEIGHT : startY - BRICK_HEIGHT;
      if (startY >= BRICKS_Y_OFFSET + Math.floor(MAX_BRICK_ROWS/3)*BRICK_HEIGHT) {
        startY -= BRICK_HEIGHT;
      }
      else if (startY < BRICKS_Y_OFFSET) {
        startY += BRICK_HEIGHT;
      }

      endY = Math.random() < 0.5 ? endY + BRICK_HEIGHT : endY - BRICK_HEIGHT;
      if (endY >= BRICKS_Y_OFFSET + MAX_BRICK_ROWS*BRICK_HEIGHT) {
        endY -= BRICK_HEIGHT;
      }
      else if (endY < BRICKS_Y_OFFSET + Math.floor(2*MAX_BRICK_ROWS/3)*BRICK_HEIGHT) {
        endY += BRICK_HEIGHT;
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
    // this.gameOverScoreText.destroy();
    // this.gameOverScoreNumberText.destroy();

  }

};


BasicGame.HowDoYouDoIt.prototype.constructor = BasicGame.HowDoYouDoIt;
