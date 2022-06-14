package
{
   import org.flixel.FlxState;
   import org.flixel.FlxSprite;
   import org.flixel.FlxPoint;
   import org.flixel.FlxG;
   
   public class MomReturningState extends TimedState
   {
       
      private var SndBGM:Class;
      
      private var doorClose:Class;
      
      private var house:Class;
      
      private var outside:Class;
      
      private var girl3:Class;
      
      private var girl_caught:Class;
      
      private var girl_notcaught:Class;
      
      private var dolls:Class;
      
      private var mom:Class;
      
      private var mom_shock:Class;
      
      public var nextState:FlxState;
      
      public var time_frame:Number = 0;
      
      public var cameraTrack:FlxSprite;
      
      public var cam_moving:Boolean = false;
      
      public var cam_target_point:FlxPoint;
      
      public var scene_time:Number = 1;
      
      public var current_scene:Number = 1;
      
      public var girl3_sprite:FlxSprite;
      
      public var mom_sprite:FlxSprite;
      
      public var caught:Boolean;
      
      public function MomReturningState(param1:EndState, param2:Boolean)
      {
         SndBGM = bgm_mp3$64500554a3a3c96336b9da64b404346f982391180;
         doorClose = doorclose_mp3$e2036578db0a1edf29695d11a862aeb2252146830;
         house = §house_png$fb619b466943e3608b65dd92025f899d-1741343478§;
         outside = §outside_png$6ca9f971523e50bc50f02aa3451f2d6d-360763449§;
         girl3 = girl3_png$6999783d53c7065c6bc718c2c93c86351761887473;
         girl_caught = §girl_caught_png$fa7a155234fccef07bd4ed33d1c49132-1545533783§;
         girl_notcaught = girl_notcaught_png$881c6db27522ce519892f946c3fa3c27228437392;
         dolls = §dolls_png$40cc66a056282870a11ac49023de279b-795166238§;
         mom = §mom1_png$4eae2433be6a6307f5f3fd1e53049420-310075078§;
         mom_shock = mom_shock_png$f99b5dfcd28ff5acadbda8383b9848a72053899864;
         super();
         this.nextState = param1;
         this.caught = param2;
      }
      
      override public function create() : void
      {
         endTime = 7;
         cam_target_point = new FlxPoint(389 + FlxG.width / 2,52 + FlxG.height / 2);
         cameraTrack = new FlxSprite(389 + FlxG.width / 2,52 + FlxG.height / 2);
         cameraTrack.visible = false;
         add(cameraTrack);
         FlxG.camera.target = cameraTrack;
         var _loc2_:FlxSprite = new FlxSprite(0,0);
         _loc2_.loadGraphic(outside,true,true,600,185,true);
         add(_loc2_);
         _loc2_.scrollFactor = new FlxPoint(0.5,0.5);
         var _loc1_:FlxSprite = new FlxSprite(0,0);
         _loc1_.loadGraphic(house,true,true,750,360,true);
         _loc1_.addAnimation("closed",[0],1,false);
         _loc1_.addAnimation("open",[1],1,false);
         add(_loc1_);
         if(this.caught)
         {
            girl3_sprite = new FlxSprite(525,174);
            girl3_sprite.loadGraphic(girl_caught,true,true,59,95,true);
         }
         else
         {
            girl3_sprite = new FlxSprite(554,171);
            girl3_sprite.loadGraphic(girl_notcaught,true,true,108,102,true);
         }
         add(girl3_sprite);
         if(this.caught)
         {
            mom_sprite = new FlxSprite(22,29);
            mom_sprite.loadGraphic(mom_shock,true,true,101,174,true);
            mom_sprite.addAnimation("run",[0,1],3,true);
            mom_sprite.play("run");
         }
         else
         {
            mom_sprite = new FlxSprite(22,49);
            mom_sprite.loadGraphic(mom,true,true,77,151,true);
         }
         add(mom_sprite);
         mom_sprite.alpha = 0;
         if(FlxG.music == null)
         {
            FlxG.playMusic(SndBGM,0.4);
         }
         else
         {
            FlxG.music.resume();
            if(!FlxG.music.active)
            {
               FlxG.playMusic(SndBGM,0.4);
            }
         }
      }
      
      override public function update() : void
      {
         super.update();
         time_frame = time_frame + 1;
         if(time_frame == 50)
         {
            FlxG.play(doorClose);
         }
         if(timeFrame / 100 % 3 == 0)
         {
            current_scene = current_scene + 1;
            if(current_scene == 2)
            {
               cam_moving = true;
               cam_target_point = new FlxPoint(FlxG.width / 2,FlxG.height / 2);
            }
         }
         if(Math.abs(cameraTrack.x - cam_target_point.x) < 10 && Math.abs(cameraTrack.y - cam_target_point.y) < 10)
         {
            cam_moving = false;
            if(current_scene == 2)
            {
               mom_sprite.alpha = mom_sprite.alpha + 0.02;
            }
         }
         else
         {
            cameraTrack.velocity.x = cam_target_point.x - cameraTrack.x;
            cameraTrack.velocity.y = cam_target_point.y - cameraTrack.y;
         }
         if(current_scene == 2)
         {
            girl3_sprite.alpha = girl3_sprite.alpha - 0.02;
         }
      }
      
      override public function endCallback() : void
      {
         FlxG.switchState(nextState);
      }
   }
}
