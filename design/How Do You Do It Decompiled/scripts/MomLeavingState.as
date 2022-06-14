package
{
   import org.flixel.FlxSprite;
   import org.flixel.FlxPoint;
   import org.flixel.FlxState;
   import org.flixel.FlxG;
   
   public class MomLeavingState extends TimedState
   {
       
      private var SndBGM:Class;
      
      private var doorOpen:Class;
      
      private var doorClose:Class;
      
      private var garageOpen:Class;
      
      private var carDoor:Class;
      
      private var carLeave:Class;
      
      private var mom:Class;
      
      private var house:Class;
      
      private var girl1:Class;
      
      private var girl2:Class;
      
      private var girl3:Class;
      
      private var dolls:Class;
      
      private var car:Class;
      
      private var outside:Class;
      
      public var mom_sprite:FlxSprite;
      
      public var girl1_sprite:FlxSprite;
      
      public var scene_time:Number = 3;
      
      public var current_scene:Number = 1;
      
      public var cameraTrack:FlxSprite;
      
      public var cam_moving:Boolean = false;
      
      public var cam_target_point:FlxPoint;
      
      public var car_sprite:FlxSprite;
      
      public var girl2_sprite:FlxSprite;
      
      public var girl3_sprite:FlxSprite;
      
      public var dolls_sprite:FlxSprite;
      
      public var girlAnimLock:Boolean = false;
      
      public var sceneLock:Boolean = false;
      
      public var nextState:FlxState;
      
      public var time_frame:Number = 0;
      
      public function MomLeavingState(param1:FlxState)
      {
         SndBGM = bgm_mp3$64500554a3a3c96336b9da64b404346f982391180;
         doorOpen = dooropen_mp3$1d1ae692f87e58c26a9a52b2aab6dbb81286260950;
         doorClose = doorclose_mp3$e2036578db0a1edf29695d11a862aeb2252146830;
         garageOpen = garageopen_mp3$259549ab1b4154afd430f271a013a2421851703185;
         carDoor = cardoor_mp3$23c6b9a9ec1f444d2229e14021317f551009662550;
         carLeave = §carleave_mp3$01d707a2c21761c8bbe46a4609a7b02c-1711444509§;
         mom = §mom1_png$4eae2433be6a6307f5f3fd1e53049420-310075078§;
         house = §house_png$fb619b466943e3608b65dd92025f899d-1741343478§;
         girl1 = girl1_png$f982833dae204079c0f820508c9506f41763710455;
         girl2 = girl2_png$0eafb0d0b77a62dafcb594211d63680a1764912240;
         girl3 = girl3_png$6999783d53c7065c6bc718c2c93c86351761887473;
         dolls = §dolls_png$40cc66a056282870a11ac49023de279b-795166238§;
         car = §car_png$214856ceea33790710e852882a3a066e-2084792330§;
         outside = §outside_png$6ca9f971523e50bc50f02aa3451f2d6d-360763449§;
         super();
         this.nextState = param1;
      }
      
      override public function create() : void
      {
         endTime = 12;
         cam_target_point = new FlxPoint(FlxG.width / 2,FlxG.height / 2);
         cameraTrack = new FlxSprite(FlxG.width / 2,FlxG.height / 2);
         cameraTrack.visible = false;
         add(cameraTrack);
         FlxG.camera.target = cameraTrack;
         var _loc2_:FlxSprite = new FlxSprite(0,0);
         _loc2_.loadGraphic(outside,true,true,600,185,true);
         add(_loc2_);
         _loc2_.scrollFactor = new FlxPoint(0.5,0.5);
         car_sprite = new FlxSprite(250,69);
         car_sprite.loadGraphic(car,true,true,104,54,true);
         car_sprite.alpha = 0;
         add(car_sprite);
         car_sprite.scrollFactor = new FlxPoint(0.7,0.7);
         var _loc1_:FlxSprite = new FlxSprite(0,0);
         _loc1_.loadGraphic(house,true,true,750,360,true);
         _loc1_.addAnimation("closed",[0],1,false);
         _loc1_.addAnimation("open",[1],1,false);
         add(_loc1_);
         mom_sprite = new FlxSprite(22,49);
         mom_sprite.loadGraphic(mom,true,true,77,151,true);
         add(mom_sprite);
         girl1_sprite = new FlxSprite(110,98);
         girl1_sprite.loadGraphic(girl1,true,true,44,121,true);
         add(girl1_sprite);
         girl2_sprite = new FlxSprite(293,82);
         girl2_sprite.loadGraphic(girl2,true,true,54,99,true);
         girl2_sprite.addAnimation("run",[0,1,2,3],10,false);
         girl2_sprite.alpha = 0;
         add(girl2_sprite);
         girl3_sprite = new FlxSprite(525,174);
         girl3_sprite.loadGraphic(girl3,true,true,60,101,true);
         girl3_sprite.alpha = 0;
         add(girl3_sprite);
         dolls_sprite = new FlxSprite(598,178);
         dolls_sprite.loadGraphic(dolls,true,true,76,55,true);
         dolls_sprite.alpha = 0;
         add(dolls_sprite);
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
         FlxG.play(doorOpen);
      }
      
      override public function update() : void
      {
         super.update();
         if(timeFrame / 100 % 3 == 0)
         {
            current_scene = current_scene + 1;
            if(current_scene == 2)
            {
               FlxG.play(doorClose);
               cam_moving = true;
               cam_target_point = new FlxPoint(176 + FlxG.width / 2,FlxG.height / 2);
            }
            if(current_scene == 3)
            {
               cam_moving = true;
               cam_target_point = new FlxPoint(389 + FlxG.width / 2,52 + FlxG.height / 2);
            }
         }
         if(Math.abs(cameraTrack.x - cam_target_point.x) < 10 && Math.abs(cameraTrack.y - cam_target_point.y) < 10)
         {
            cam_moving = false;
            if(current_scene == 2)
            {
               car_sprite.alpha = car_sprite.alpha + 0.02;
               girl2_sprite.alpha = girl2_sprite.alpha + 0.02;
               if(!girlAnimLock && girl2_sprite.alpha >= 1)
               {
                  girl2_sprite.play("run");
                  FlxG.play(carLeave);
                  girlAnimLock = true;
               }
               if(!sceneLock)
               {
                  sceneLock = true;
                  FlxG.play(carDoor);
               }
            }
            if(current_scene == 3)
            {
               dolls_sprite.alpha = dolls_sprite.alpha + 0.02;
               girl3_sprite.alpha = girl3_sprite.alpha + 0.02;
            }
         }
         else
         {
            cameraTrack.velocity.x = cam_target_point.x - cameraTrack.x;
            cameraTrack.velocity.y = cam_target_point.y - cameraTrack.y;
         }
         if(current_scene == 2)
         {
            girl1_sprite.alpha = girl1_sprite.alpha - 0.02;
            mom_sprite.alpha = mom_sprite.alpha - 0.02;
         }
         if(current_scene == 3)
         {
            girl2_sprite.alpha = girl2_sprite.alpha - 0.02;
            car_sprite.alpha = car_sprite.alpha - 0.02;
         }
      }
      
      override public function endCallback() : void
      {
         FlxG.switchState(nextState);
      }
   }
}
