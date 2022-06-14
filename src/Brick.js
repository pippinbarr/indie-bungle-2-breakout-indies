var Brick = function (game, x, y, row, col, tint, value, sfx, sprite_name, zoom) {

	this.row = row;
	this.col = col;

	this.score = value;// 7 - 3*Math.floor(row / 2);

	this.sfx = sfx;

	if (sprite_name) {
		Phaser.Sprite.call(this, game, x, y, sprite_name);
		this.width *= zoom;
		this.height *= zoom;
	}
	else {
		Phaser.Sprite.call(this, game, x, y, "white_pixel");
		if (typeof tint == "string") this.tint = parseInt(tint.slice(1,tint.length),16);
		else this.tint = tint;
	}


	this.game.physics.enable(this, Phaser.Physics.ARCADE);
	game.add.existing(this);
};


Brick.prototype = Object.create(Phaser.Sprite.prototype);



Brick.prototype.constructor = Brick;



Brick.prototype.update = function () {

};


Brick.prototype.destroy = function () {

	Phaser.Sprite.call(this);

};


Brick.prototype.disable = function () {

	this.body.enable = false;
	this.visible = false;
	// this.alive = false;

};


Brick.prototype.enable = function () {

	this.body.enable = true;
	this.visible = true;
	// this.alive = true;

};
