BasicGame.TheGraveyard = function (game) {
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


BasicGame.TheGraveyard.prototype = new Phaser.State();

BasicGame.TheGraveyard.prototype.parent = Phaser.State;

TheGraveyardState = {
  START: 'START',
  PLAY: 'PLAY',
  GAME_OVER: 'GAME_OVER',
  GAME_OVER_SCREEN: 'GAME_OVER_SCREEN',
  PAUSED: 'PAUSED',
  LOST_PADDLE: 'LOST_PADDLE'
};

BasicGame.TheGraveyard.prototype = {

  create: function () {

    Phaser.State.prototype.create.call(this);

    // console.log("GraveyardDead = " + localStorage.getItem('GraveyardDead'));

    if (localStorage.getItem('GraveyardDead') == 'true') {
      // console.log("... starting TheGraveyard2");
      this.game.state.start('TheGraveyard2');
    }

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

    this.limps = 0;

    // GRAVESTONES

    this.leftGraves = this.game.add.sprite(0,0,'gravestone');
    this.leftGraves.x = 7*BRICK_WIDTH - this.leftGraves.width;
    this.game.physics.enable(this.leftGraves, Phaser.Physics.ARCADE);
    this.leftGraves.body.immovable = true;

    this.rightGraves = this.game.add.sprite(this.game.width - 7*BRICK_WIDTH,0,'gravestone');
    this.game.physics.enable(this.rightGraves, Phaser.Physics.ARCADE);
    this.rightGraves.body.immovable = true;

    // BENCH

    this.bench = this.game.add.sprite(0,0,'bench');
    this.bench.x = this.game.width/2 - this.bench.width/2;
    this.bench.y = 20;
    this.game.physics.enable(this.bench, Phaser.Physics.ARCADE);
    this.bench.body.immovable = true;

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

    this.resetGame();

    this.clouds = this.game.add.sprite(0,0,'clouds');
    this.clouds.width *= 10;
    this.clouds.height *= 10;
    this.clouds.anchor.x = this.clouds.anchor.y = 0.5;
    this.clouds.x = this.game.width + this.clouds.width/2;
    this.clouds.y = this.game.height/2;
    this.game.physics.enable(this.clouds, Phaser.Physics.ARCADE);
    this.clouds.body.velocity.x = -50;

    this.clouds2 = this.game.add.sprite(0,0,'clouds');
    this.clouds2.width *= 10;
    this.clouds2.height *= 10;
    this.clouds2.anchor.x = this.clouds2.anchor.y = 0.5;
    this.clouds2.angle = 90;
    this.clouds2.x = this.game.width * 2 + this.clouds2.width/2;
    this.clouds2.y = this.game.height/2;
    this.game.physics.enable(this.clouds2, Phaser.Physics.ARCADE);
    this.clouds2.body.velocity.x = -60;

    this.clouds3 = this.game.add.sprite(0,0,'clouds');
    this.clouds3.width *= 10;
    this.clouds3.height *= 10;
    this.clouds3.anchor.x = this.clouds3.anchor.y = 0.5;
    this.clouds3.angle = 180;
    this.clouds3.x = this.game.width * 3 + this.clouds3.width/2;
    this.clouds3.y = this.game.height/2;
    this.game.physics.enable(this.clouds3, Phaser.Physics.ARCADE);
    this.clouds3.body.velocity.x = -70;


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

    this.physics.arcade.overlap(this.paddle,this.leftGraves,this.handlePaddleWallColliders,null,this);
    this.physics.arcade.overlap(this.paddle,this.rightGraves,this.handlePaddleWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.walls,this.handleBallWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.leftGraves,this.handleBallWallColliders,null,this);
    this.physics.arcade.collide(this.ball,this.rightGraves,this.handleBallWallColliders,null,this);

    if (this.state == TheGraveyardState.PLAY) {

      this.physics.arcade.collide(this.ball,this.paddle,this.handleBallPaddleColliders,null,this);
      this.physics.arcade.overlap(this.ball,this.bricks,this.handleBallBrickColliders.bind(this),null,this);
      this.physics.arcade.overlap(this.ball,this.bench,this.handleBallBenchColliders.bind(this),null,this);

      this.checkBallOut();
    }

    if (this.clouds.x + this.clouds.width/2 < 0) this.clouds.x = this.game.width + this.clouds.width/2;
    if (this.clouds2.x + this.clouds2.width/2 < 0) this.clouds2.x = this.game.width + this.clouds.width/2;
    if (this.clouds3.x + this.clouds3.width/2 < 0) this.clouds3.x = this.game.width + this.clouds.width/2;

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
    this.state = TheGraveyardState.START;

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

    if (wall == this.leftGraves) {
      paddle.body.x = this.leftGraves.body.x + this.leftGraves.width;
    }
    else if (wall == this.rightGraves) {
      paddle.body.x = this.rightGraves.body.x - paddle.width;
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

    brick.sfx.play();

    ball.body.velocity.y *= -1;


    ball.collides = false;

    brick.disable();
    brick.alive = false;


  },


  handleBallBenchColliders: function (ball,brick) {
    // Go to next screen (maybe just a new level altogether)
    // console.log("... ball hit bench.");
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
    this.ball.y = this.paddle.y - 70;

    this.ball.body.velocity.x = 0;
    this.ball.body.velocity.y = 0;

    this.resetLimp();
    if (this.limpTimer) this.limpTimer.timer.removeAll();


    this.restartTimer = this.game.time.events.add(Phaser.Timer.SECOND * 2, this.restartBall, this, this.ball, this.paddle);
  },


  restartBall: function (ball,paddle) {

    this.ball.body.velocity.x = 20 - Math.random() * 40;
    this.ball.body.velocity.y = BALL_SPEED;

    this.startLimp();

    this.launch_wall_sfx.play();

    this.state = TheGraveyardState.PLAY;

  },

  startLimp: function (ball) {
    this.limps = 0;

    this.limp();
  },


  limp: function (ball) {
    this.limps++;
    this.ball.body.velocity.y *= 0.5;
    this.ball.body.velocity.x *= 0.5;
    BALL_X_SPEED *= 0.5;

    if (this.ball.body.velocity.y < 2 && this.ball.body.velocity.y > -2) {
      this.endLimp();
    }
    else {
      this.limpTimer = this.game.time.events.add(Phaser.Timer.SECOND * 0.1, this.limp, this, this.ball);
    }

  },


  endLimp: function (ball) {
    this.resetLimp();
    this.limpTimer = this.game.time.events.add(Phaser.Timer.SECOND * 0.3, this.startLimp, this, this.ball);
  },


  resetLimp: function () {
    this.ball.body.velocity.x *= Math.pow(2,this.limps);
    this.ball.body.velocity.y *= Math.pow(2,this.limps);
    BALL_X_SPEED *= Math.pow(2,this.limps);
    this.limps = 0;
  },


  resetBricks: function () {

    BRICKS = [];
    this.bricks.removeAll();

    var startX = BRICK_WIDTH*7;
    var startY = BRICKS_Y_OFFSET;

    for (var x = startX; x < this.game.width - BRICK_WIDTH*7; x += BRICK_WIDTH) {
      for (var y = startY; y < BRICKS_Y_OFFSET + MAX_BRICK_ROWS*BRICK_HEIGHT; y += BRICK_HEIGHT) {
          var tints = ['9','A','B','C','D'];
          var tintNum = tints[Math.floor(Math.random() * tints.length)];
          var brickColor = '#' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '' + tintNum + '';
          var brick = new Brick(this,x,y,0,0,brickColor,0,this.BRICK_SFX["brick_oranger"]);
          this.game.physics.enable(brick, Phaser.Physics.ARCADE);
          brick.body.immovable = true;
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

  }

};


BasicGame.TheGraveyard.prototype.constructor = BasicGame.TheGraveyard;
