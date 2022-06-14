package
{
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   import org.flixel.FlxG;
   import Box2D.Collision.b2AABB;
   import org.flixel.FlxPoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.b2DebugDraw;
   import flash.display.Sprite;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2BodyDef;
   
   public class PlayState extends TimedState
   {
      
      public static var mouseXWorldPhys:Number;
      
      public static var mouseYWorldPhys:Number;
      
      public static var mouseXWorld:Number;
      
      public static var mouseYWorld:Number;
       
      private var SndBGM:Class;
      
      private var ImgBody:Class;
      
      private var ImgBG:Class;
      
      private var garageOpen:Class;
      
      private var carDoor:Class;
      
      private var carArrive:Class;
      
      private var doorOpen:Class;
      
      public var FontPix:String;
      
      public var m_physScale:Number = 30;
      
      public var m_world:b2World;
      
      public var m_mouseJoint:b2MouseJoint;
      
      public var dollLGrabber:DollGrabber;
      
      public var dollRGrabber:DollGrabber;
      
      public var dollL:PhysicsDoll;
      
      public var dollR:PhysicsDoll;
      
      public var dollController:DollController;
      
      public var dollCollision:DollContactListener;
      
      public var thinking:ScrollingText;
      
      public var thinking_two:ScrollingText;
      
      public var thinking_counter:Number = 0;
      
      public var bubble_width:Number;
      
      public var face:Face;
      
      public var body:FlxSprite;
      
      public var lArm:Arm;
      
      public var rArm:Arm;
      
      public var debugText:FlxText;
      
      public var started:Boolean;
      
      public var smoke:FlxSprite;
      
      public var howText1:FlxText;
      
      public var howText2:FlxText;
      
      private var mousePVec:b2Vec2;
      
      public function PlayState()
      {
         SndBGM = bgm_mp3$64500554a3a3c96336b9da64b404346f982391180;
         ImgBody = §girl_body_png$a1d79fc6f15f17af32b255684ca3132a-247686969§;
         ImgBG = §mainbg_png$fa4686e394b58dd2e2827a2450cdaeb2-1795172062§;
         garageOpen = garageopen_mp3$259549ab1b4154afd430f271a013a2421851703185;
         carDoor = cardoor_mp3$23c6b9a9ec1f444d2229e14021317f551009662550;
         carArrive = cararrive_mp3$2086b695dad41f66aa8d80d7f3368da31016958817;
         doorOpen = dooropen_mp3$1d1ae692f87e58c26a9a52b2aab6dbb81286260950;
         FontPix = "Minecraftia2_ttf$49c00ae56efd9e4c195f97daaf6bb683488872850";
         bubble_width = FlxG.width / 2;
         mousePVec = new b2Vec2();
         super();
      }
      
      override public function create() : void
      {
         started = false;
         var _loc2_:FlxSprite = new FlxSprite(0,0);
         _loc2_.loadGraphic(ImgBG,true,true,320,240,true);
         add(_loc2_);
         debugText = new FlxText(10,30,FlxG.width,"");
         add(debugText);
         setupWorld();
         body = new FlxSprite(-70,56);
         body.loadGraphic(ImgBody,true,true,294,190,true);
         add(body);
         face = new Face(-10,-68);
         thinking = new ScrollingText();
         add(thinking);
         var _loc3_:Number = 200;
         var _loc4_:Number = 170;
         var _loc1_:b2AABB = new b2AABB();
         _loc1_.lowerBound.Set(0,220 / m_physScale);
         _loc1_.upperBound.Set(640 / m_physScale,480 / m_physScale);
         dollRGrabber = new DollGrabber();
         dollLGrabber = new DollGrabber();
         lArm = new Arm(50,dollLGrabber,false);
         rArm = new Arm(220,dollRGrabber,true);
         var _loc5_:FlxPoint = new FlxPoint(_loc4_,_loc3_);
         dollL = new PhysicsDoll();
         dollL.create(m_world,_loc5_,0);
         dollLGrabber.create(dollL,m_world,_loc1_);
         dollCollision = new DollContactListener(face);
         m_world.SetContactListener(dollCollision);
         _loc4_ = 510;
         _loc5_ = new FlxPoint(_loc4_,_loc3_);
         dollR = new PhysicsDoll();
         dollR.create(m_world,_loc5_,1);
         dollRGrabber.create(dollR,m_world,_loc1_);
         dollController = new DollController(dollRGrabber,dollLGrabber,rArm,lArm);
         smoke = new FlxSprite(0,0);
         smoke.makeGraphic(640,480);
         smoke.fill(1426063360);
         add(smoke);
         howText1 = new FlxText(FlxG.width - 200,FlxG.height / 2,FlxG.width,"Use WASD to move your arms.");
         howText1.setFormat("Minecraftia-Regular",8,4.294967295E9,"left");
         howText2 = new FlxText(FlxG.width - 200,FlxG.height / 2 + 20,FlxG.width,"Use J or K to rotate a doll.");
         howText2.setFormat("Minecraftia-Regular",8,4.294967295E9,"left");
         add(howText1);
         add(howText2);
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
         if(timeFrame % 100 == 0 && !started)
         {
            endTime = endTime + 1;
         }
         if(dollController.update(endTime - timeSec))
         {
            started = true;
         }
         if(started)
         {
            thinking.paused = false;
            FlxG.state.remove(smoke);
            FlxG.state.remove(howText1);
            FlxG.state.remove(howText2);
         }
         UpdateMouseWorld();
         MouseDrag();
         m_world.Step(0.03333333333333333,10,10);
         dollL.update();
         dollR.update();
         dollLGrabber.update();
         dollRGrabber.update();
         lArm.update();
         rArm.update();
         face.update();
         if(this.timeFrame == 2000)
         {
            FlxG.play(carArrive);
         }
         else if(this.timeFrame == 2200)
         {
            FlxG.play(garageOpen);
         }
         else if(this.timeFrame == 2500)
         {
            FlxG.play(carDoor);
         }
         else if(this.timeFrame == 2900)
         {
            FlxG.play(doorOpen);
         }
      }
      
      override public function endCallback() : void
      {
         FlxG.switchState(new MomReturningState(new EndState(dollCollision.sex,dollController.isClose),dollController.isClose));
      }
      
      public function UpdateMouseWorld() : void
      {
         mouseXWorldPhys = FlxG.mouse.screenX / m_physScale;
         mouseYWorldPhys = FlxG.mouse.screenY / m_physScale;
         mouseXWorld = FlxG.mouse.screenX;
         mouseYWorld = FlxG.mouse.screenY;
      }
      
      public function MouseDrag() : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(FlxG.mouse.pressed() && !m_mouseJoint)
         {
            _loc3_ = GetBodyAtMouse();
            if(_loc3_)
            {
               _loc2_ = new b2MouseJointDef();
               _loc2_.bodyA = m_world.GetGroundBody();
               _loc2_.bodyB = _loc3_;
               _loc2_.target.Set(mouseXWorldPhys,mouseYWorldPhys);
               _loc2_.collideConnected = true;
               _loc2_.maxForce = 300 * _loc3_.GetMass();
               m_mouseJoint = m_world.CreateJoint(_loc2_) as b2MouseJoint;
               _loc3_.SetAwake(true);
            }
         }
         if(!FlxG.mouse.pressed())
         {
            if(m_mouseJoint)
            {
               m_world.DestroyJoint(m_mouseJoint);
               m_mouseJoint = null;
            }
         }
         if(m_mouseJoint)
         {
            _loc1_ = new b2Vec2(mouseXWorldPhys,mouseYWorldPhys);
            m_mouseJoint.SetTarget(_loc1_);
         }
      }
      
      public function GetBodyAtMouse(param1:Boolean = false) : b2Body
      {
         includeStatic = param1;
         GetBodyCallback = function(param1:b2Fixture):Boolean
         {
            var _loc3_:* = false;
            var _loc2_:b2Shape = param1.GetShape();
            if(param1.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
            {
               _loc3_ = _loc2_.TestPoint(param1.GetBody().GetTransform(),mousePVec);
               if(_loc3_)
               {
                  body = param1.GetBody();
                  return false;
               }
            }
            return true;
         };
         mousePVec.Set(mouseXWorldPhys,mouseYWorldPhys);
         var aabb:b2AABB = new b2AABB();
         aabb.lowerBound.Set(mouseXWorldPhys - 0.001,mouseYWorldPhys - 0.001);
         aabb.upperBound.Set(mouseXWorldPhys + 0.001,mouseYWorldPhys + 0.001);
         var body:b2Body = null;
         m_world.QueryAABB(GetBodyCallback,aabb);
         return body;
      }
      
      private function setupWorld() : void
      {
         var _loc1_:* = null;
         var _loc2_:b2Vec2 = new b2Vec2(0,9.8);
         m_world = new b2World(_loc2_,true);
         var _loc4_:b2DebugDraw = new b2DebugDraw();
         var _loc5_:Sprite = new Sprite();
         FlxG.stage.addChild(_loc5_);
         _loc4_.SetSprite(_loc5_);
         _loc4_.SetDrawScale(30);
         _loc4_.SetFillAlpha(0.3);
         _loc4_.SetLineThickness(1);
         _loc4_.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
         m_world.SetDebugDraw(_loc4_);
         var _loc6_:b2PolygonShape = new b2PolygonShape();
         var _loc3_:b2BodyDef = new b2BodyDef();
         _loc3_.position.Set(-95 / m_physScale,480 / m_physScale / 2);
         _loc6_.SetAsBox(100 / m_physScale,480 / m_physScale / 2);
         _loc3_.position.Set(735 / m_physScale,480 / m_physScale / 2);
         _loc3_.position.Set(640 / m_physScale / 2,-95 / m_physScale);
         _loc6_.SetAsBox(680 / m_physScale / 2,100 / m_physScale);
         _loc3_.position.Set(640 / m_physScale / 2,575 / m_physScale);
      }
   }
}
