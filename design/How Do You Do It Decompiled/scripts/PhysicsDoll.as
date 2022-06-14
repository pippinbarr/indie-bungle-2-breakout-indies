package
{
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import org.flixel.FlxSprite;
   import org.flixel.FlxPoint;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Common.Math.b2Vec2;
   import org.flixel.FlxG;
   
   public class PhysicsDoll
   {
      
      public static const ATYPE:int = 0;
      
      public static const BTYPE:int = 1;
      
      public static const COL_HEAD:String = "HEAD";
      
      public static const COL_L_HAND:String = "L_HAND";
      
      public static const COL_R_HAND:String = "R_HAND";
      
      public static const COL_GROIN:String = "GROIN";
       
      private var ImgFHead:Class;
      
      private var ImgFChest:Class;
      
      private var ImgFHips:Class;
      
      private var ImgFArmL:Class;
      
      private var ImgFArmR:Class;
      
      private var ImgFLegL:Class;
      
      private var ImgFLegR:Class;
      
      private var ImgFFootL:Class;
      
      private var ImgFFootR:Class;
      
      private var ImgMHead:Class;
      
      private var ImgMChest:Class;
      
      private var ImgMHips:Class;
      
      private var ImgMArmL:Class;
      
      private var ImgMArmR:Class;
      
      private var ImgMLegL:Class;
      
      private var ImgMLegR:Class;
      
      private var ImgMFootL:Class;
      
      private var ImgMFootR:Class;
      
      public var m_world:b2World;
      
      public var m_physScale:Number = 30;
      
      public var midriff:b2Body;
      
      public var torso3:b2Body;
      
      public var spriteType:Number;
      
      public var headSprite:FlxSprite;
      
      public var chestSprite:FlxSprite;
      
      public var hipsSprite:FlxSprite;
      
      public var armLSprite:FlxSprite;
      
      public var armRSprite:FlxSprite;
      
      public var legLSprite:FlxSprite;
      
      public var legRSprite:FlxSprite;
      
      public var footLSprite:FlxSprite;
      
      public var footRSprite:FlxSprite;
      
      public var head:b2Body;
      
      public var torso1:b2Body;
      
      public var upperArmL:b2Body;
      
      public var upperArmR:b2Body;
      
      public var l_hand:b2Body;
      
      public var r_hand:b2Body;
      
      public var upperLegL:b2Body;
      
      public var upperLegR:b2Body;
      
      public var lowerLegL:b2Body;
      
      public var lowerLegR:b2Body;
      
      private const LEGSPACING:Number = 18;
      
      private const LEGAMASK:uint = 2;
      
      private const LEGACAT:uint = 2;
      
      private const LEGBMASK:uint = 4;
      
      private const LEGBCAT:uint = 4;
      
      private const TORSOMASK:uint = 65535;
      
      private const TORSOCAT:uint = 16;
      
      private const ARMMASK:uint = 65535;
      
      private const ARMCAT:uint = 32;
      
      private const FOOTMASK:uint = 65519;
      
      private const FOOTCAT:uint = 8;
      
      public function PhysicsDoll()
      {
         ImgFHead = §barb_head_png$d6c3b955885b8c2cd23eed5f15f563b4-368809382§;
         ImgFChest = barb_chest_png$1ae4aab30bb6c8fe8434aa3c9517a7ba507810669;
         ImgFHips = §barb_hips_png$01f13c2cb3eed37f8943aa4edd1bc7b8-603886154§;
         ImgFArmL = §barb_armL_png$1e6aeb7fc7c18536173efa682c82e1d4-554357014§;
         ImgFArmR = §barb_armR_png$b6be7e12c1106c6507d04033dcf15cf5-570313760§;
         ImgFLegL = barb_legL_png$c9430bf6d885668fd6824d5f3cedd2c028834168;
         ImgFLegR = barb_legR_png$cb7a76bcda772f7bcc6611fbcd106c2829379190;
         ImgFFootL = §barb_footL_png$d7b28accadb0d5c361a7896099c987e4-1175347342§;
         ImgFFootR = §barb_footR_png$a3c023b6a94bb5b35c2a36157daf0da2-1190502392§;
         ImgMHead = ken_head_png$14a1b32879a53e90d6d2986b8c43dfb11838648215;
         ImgMChest = ken_chest_png$974d04838ecba15d2ae47b08fe9b7235681135024;
         ImgMHips = ken_hips_png$9d1ee6247debaeb21876228d4f0fb7b51603308275;
         ImgMArmL = ken_armL_png$ca5465a60ae2c72a48d7d707b43d447f1111772711;
         ImgMArmR = ken_armR_png$ab272fa1335d31f4e76f39786b8c971f1100010301;
         ImgMLegL = §ken_legL_png$c8709c3aa6bf86fc586f5ff8dfcc31cd-2063112523§;
         ImgMLegR = §ken_legR_png$e8188651690a54b27b1ba441e40defe7-2058097741§;
         ImgMFootL = ken_footL_png$398b6aa216c33823c784df2892d079301142052693;
         ImgMFootR = ken_footR_png$90d5fe782a6ba4542ad6e4251c56b99c1135532115;
         super();
      }
      
      public function create(param1:b2World, param2:FlxPoint, param3:int = 0) : void
      {
         var _loc10_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         m_world = param1;
         this.spriteType = param3;
         var _loc4_:b2BodyDef = new b2BodyDef();
         var _loc11_:b2RevoluteJointDef = new b2RevoluteJointDef();
         var _loc7_:b2FixtureDef = new b2FixtureDef();
         var _loc14_:Number = param2.x;
         var _loc12_:Number = param2.y;
         _loc4_.type = b2Body.b2_dynamicBody;
         _loc10_ = new b2CircleShape(20 / m_physScale);
         _loc7_.shape = _loc10_;
         _loc7_.density = 1;
         _loc7_.friction = 0.4;
         _loc7_.restitution = 0.3;
         var _loc8_:* = 10.0;
         if(param3 == 1)
         {
            _loc8_ = 30.0;
         }
         _loc4_.position.Set(_loc14_ / m_physScale,(_loc12_ - _loc8_) / m_physScale);
         head = m_world.CreateBody(_loc4_);
         _loc7_.isSensor = true;
         _loc7_.userData = "HEAD";
         head.CreateFixture(_loc7_);
         _loc7_.isSensor = false;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(30 / m_physScale,30 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc7_.density = 1;
         _loc7_.friction = 0.4;
         _loc7_.restitution = 0.1;
         _loc5_ = new b2FilterData();
         _loc5_.maskBits = 65535;
         _loc5_.categoryBits = 16;
         _loc7_.filter = _loc5_;
         _loc4_.position.Set(_loc14_ / m_physScale,(_loc12_ + 28) / m_physScale);
         torso1 = m_world.CreateBody(_loc4_);
         torso1.CreateFixture(_loc7_);
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(22 / m_physScale,22 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set(_loc14_ / m_physScale,(_loc12_ + 85) / m_physScale);
         _loc4_.fixedRotation = true;
         var _loc16_:b2Body = m_world.CreateBody(_loc4_);
         _loc16_.CreateFixture(_loc7_);
         _loc4_.fixedRotation = false;
         midriff = _loc16_;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(15 / m_physScale,10 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set(_loc14_ / m_physScale,(_loc12_ + 115) / m_physScale);
         torso3 = m_world.CreateBody(_loc4_);
         _loc7_.isSensor = true;
         _loc7_.userData = "GROIN";
         torso3.CreateFixture(_loc7_);
         _loc7_.isSensor = false;
         _loc4_.fixedRotation = false;
         _loc7_.density = 1;
         _loc7_.friction = 0.4;
         _loc7_.restitution = 0.1;
         _loc5_ = new b2FilterData();
         _loc5_.maskBits = 65535;
         _loc5_.categoryBits = 32;
         _loc7_.filter = _loc5_;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(56 / m_physScale,6.5 / m_physScale);
         _loc7_.shape = _loc6_;
         var _loc9_:* = 90.0;
         var _loc15_:* = 10.0;
         if(param3 == 0)
         {
            _loc9_ = 70.0;
            _loc15_ = 15.0;
         }
         _loc4_.position.Set((_loc14_ - _loc9_) / m_physScale,(_loc12_ + _loc15_) / m_physScale);
         upperArmL = m_world.CreateBody(_loc4_);
         upperArmL.CreateFixture(_loc7_);
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(10 / m_physScale,10 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ - 150) / m_physScale,(_loc12_ + _loc15_) / m_physScale);
         l_hand = m_world.CreateBody(_loc4_);
         _loc7_.isSensor = true;
         _loc7_.userData = "L_HAND";
         l_hand.CreateFixture(_loc7_);
         _loc7_.isSensor = false;
         _loc4_.fixedRotation = false;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(56 / m_physScale,6.5 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ + _loc9_) / m_physScale,(_loc12_ + _loc15_) / m_physScale);
         upperArmR = m_world.CreateBody(_loc4_);
         upperArmR.CreateFixture(_loc7_);
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(10 / m_physScale,10 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ + 150) / m_physScale,(_loc12_ + _loc15_) / m_physScale);
         r_hand = m_world.CreateBody(_loc4_);
         _loc7_.isSensor = true;
         _loc7_.userData = "R_HAND";
         r_hand.CreateFixture(_loc7_);
         _loc7_.isSensor = false;
         _loc4_.fixedRotation = false;
         _loc7_.density = 1;
         _loc7_.friction = 0.4;
         _loc7_.restitution = 0.1;
         _loc5_ = new b2FilterData();
         _loc5_.maskBits = 2;
         _loc5_.categoryBits = 2;
         if(param3 == 1)
         {
            _loc5_.maskBits = 4;
            _loc5_.categoryBits = 4;
         }
         _loc7_.filter = _loc5_;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(7.5 / m_physScale,66 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ - 18) / m_physScale,(_loc12_ + 170) / m_physScale);
         upperLegL = m_world.CreateBody(_loc4_);
         upperLegL.CreateFixture(_loc7_);
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(7.5 / m_physScale,66 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ + 18) / m_physScale,(_loc12_ + 170) / m_physScale);
         upperLegR = m_world.CreateBody(_loc4_);
         upperLegR.CreateFixture(_loc7_);
         _loc7_.density = 1;
         _loc7_.friction = 0.4;
         _loc7_.restitution = 0.1;
         _loc5_ = new b2FilterData();
         _loc5_.maskBits = 65519;
         _loc5_.categoryBits = 8;
         _loc7_.filter = _loc5_;
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(6 / m_physScale,10 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ - 18) / m_physScale,(_loc12_ + 247) / m_physScale);
         lowerLegL = m_world.CreateBody(_loc4_);
         lowerLegL.CreateFixture(_loc7_);
         _loc6_ = new b2PolygonShape();
         _loc6_.SetAsBox(6 / m_physScale,10 / m_physScale);
         _loc7_.shape = _loc6_;
         _loc4_.position.Set((_loc14_ + 18) / m_physScale,(_loc12_ + 247) / m_physScale);
         lowerLegR = m_world.CreateBody(_loc4_);
         lowerLegR.CreateFixture(_loc7_);
         _loc11_.enableLimit = true;
         _loc11_.lowerAngle = -0.17453292519943295;
         _loc11_.upperAngle = 0.17453292519943295;
         _loc11_.Initialize(torso1,head,new b2Vec2(_loc14_ / m_physScale,(_loc12_ - 3) / m_physScale));
         m_world.CreateJoint(_loc11_);
         var _loc13_:* = 32.0;
         if(param3 == 0)
         {
            _loc13_ = 22.0;
         }
         _loc11_.lowerAngle = -1.4835298641951802;
         _loc11_.upperAngle = 0.17453292519943295;
         _loc11_.Initialize(torso1,upperArmL,new b2Vec2((_loc14_ - _loc13_) / m_physScale,(_loc12_ + 10) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -2.181661564992912;
         _loc11_.upperAngle = 2.181661564992912;
         _loc11_.Initialize(upperArmL,l_hand,new b2Vec2((_loc14_ - 150) / m_physScale,(_loc12_ + _loc15_) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.17453292519943295;
         _loc11_.upperAngle = 1.4835298641951802;
         _loc11_.Initialize(torso1,upperArmR,new b2Vec2((_loc14_ + _loc13_) / m_physScale,(_loc12_ + 10) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -2.181661564992912;
         _loc11_.upperAngle = 2.181661564992912;
         _loc11_.Initialize(upperArmR,r_hand,new b2Vec2((_loc14_ + 150) / m_physScale,(_loc12_ + _loc15_) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.2617993877991494;
         _loc11_.upperAngle = 0.2617993877991494;
         _loc11_.Initialize(torso1,_loc16_,new b2Vec2(_loc14_ / m_physScale,(_loc12_ + 65) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.2617993877991494;
         _loc11_.upperAngle = 0.2617993877991494;
         _loc11_.Initialize(_loc16_,torso3,new b2Vec2(_loc14_ / m_physScale,(_loc12_ + 65) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.08726646259971647;
         _loc11_.upperAngle = 0.7853981633974483;
         _loc11_.Initialize(_loc16_,upperLegL,new b2Vec2((_loc14_ - 18) / m_physScale,(_loc12_ + 96) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.7853981633974483;
         _loc11_.upperAngle = 0.08726646259971647;
         _loc11_.Initialize(_loc16_,upperLegR,new b2Vec2((_loc14_ + 18) / m_physScale,(_loc12_ + 96) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = 0.17453292519943295;
         _loc11_.upperAngle = 0.6981317007977318;
         _loc11_.Initialize(upperLegL,lowerLegL,new b2Vec2((_loc14_ - 18) / m_physScale,(_loc12_ + 235) / m_physScale));
         m_world.CreateJoint(_loc11_);
         _loc11_.lowerAngle = -0.6981317007977318;
         _loc11_.upperAngle = 0.17453292519943295;
         _loc11_.Initialize(upperLegR,lowerLegR,new b2Vec2((_loc14_ + 18) / m_physScale,(_loc12_ + 235) / m_physScale));
         m_world.CreateJoint(_loc11_);
         setupSprites();
      }
      
      public function update() : void
      {
         headSprite.x = head.GetPosition().x * m_physScale / 2 - headSprite.width / 2;
         headSprite.y = head.GetPosition().y * m_physScale / 2 - headSprite.height / 2;
         headSprite.angle = head.GetAngle() * 180 / 3.141592653589793;
         chestSprite.x = torso1.GetPosition().x * m_physScale / 2 - chestSprite.width / 2;
         chestSprite.y = torso1.GetPosition().y * m_physScale / 2 - chestSprite.height / 2;
         chestSprite.angle = torso1.GetAngle() * 180 / 3.141592653589793;
         hipsSprite.x = midriff.GetPosition().x * m_physScale / 2 - hipsSprite.width / 2;
         hipsSprite.y = midriff.GetPosition().y * m_physScale / 2 - hipsSprite.height / 2;
         hipsSprite.angle = midriff.GetAngle() * 180 / 3.141592653589793;
         armLSprite.x = upperArmR.GetPosition().x * m_physScale / 2 - armLSprite.width / 2;
         if(spriteType == 0)
         {
            armLSprite.y = upperArmR.GetPosition().y * m_physScale / 2 - armLSprite.height / 2 - 3;
         }
         else if(spriteType == 1)
         {
            armLSprite.y = upperArmR.GetPosition().y * m_physScale / 2 - armLSprite.height / 2;
         }
         armLSprite.angle = upperArmR.GetAngle() * 180 / 3.141592653589793;
         armRSprite.x = upperArmL.GetPosition().x * m_physScale / 2 - armRSprite.width / 2;
         armRSprite.y = upperArmL.GetPosition().y * m_physScale / 2 - armRSprite.height / 2;
         armRSprite.angle = upperArmL.GetAngle() * 180 / 3.141592653589793;
         legRSprite.x = upperLegL.GetPosition().x * m_physScale / 2 - legRSprite.width / 2;
         legRSprite.y = upperLegL.GetPosition().y * m_physScale / 2 - legRSprite.height / 2;
         legRSprite.angle = upperLegL.GetAngle() * 180 / 3.141592653589793;
         legLSprite.x = upperLegR.GetPosition().x * m_physScale / 2 - legLSprite.width / 2;
         legLSprite.y = upperLegR.GetPosition().y * m_physScale / 2 - legLSprite.height / 2;
         legLSprite.angle = upperLegR.GetAngle() * 180 / 3.141592653589793;
         footLSprite.x = lowerLegR.GetPosition().x * m_physScale / 2 - footLSprite.width / 2;
         footLSprite.y = lowerLegR.GetPosition().y * m_physScale / 2 - footLSprite.height / 2;
         footLSprite.angle = lowerLegR.GetAngle() * 180 / 3.141592653589793;
         footRSprite.x = lowerLegL.GetPosition().x * m_physScale / 2 - footRSprite.width / 2;
         footRSprite.y = lowerLegL.GetPosition().y * m_physScale / 2 - footRSprite.height / 2;
         footRSprite.angle = lowerLegL.GetAngle() * 180 / 3.141592653589793;
      }
      
      public function setupSprites() : void
      {
         headSprite = new FlxSprite(0,0);
         chestSprite = new FlxSprite(0,0);
         hipsSprite = new FlxSprite(0,0);
         armLSprite = new FlxSprite(0,0);
         armRSprite = new FlxSprite(0,0);
         legLSprite = new FlxSprite(0,0);
         legRSprite = new FlxSprite(0,0);
         footLSprite = new FlxSprite(0,0);
         footRSprite = new FlxSprite(0,0);
         if(spriteType == 0)
         {
            headSprite.loadGraphic(ImgFHead,true,true,35,40,true);
            chestSprite.loadGraphic(ImgFChest,true,true,29,40,true);
            hipsSprite.loadGraphic(ImgFHips,true,true,28,24,true);
            armLSprite.loadGraphic(ImgFArmL,true,true,55,44,true);
            armRSprite.loadGraphic(ImgFArmR,true,true,55,44,true);
            legLSprite.loadGraphic(ImgFLegL,true,true,19,84,true);
            legRSprite.loadGraphic(ImgFLegR,true,true,19,84,true);
            footLSprite.loadGraphic(ImgFFootL,true,true,9,17,true);
            footRSprite.loadGraphic(ImgFFootR,true,true,9,17,true);
         }
         else if(spriteType == 1)
         {
            headSprite.loadGraphic(ImgMHead,true,true,28,30,true);
            chestSprite.loadGraphic(ImgMChest,true,true,47,47,true);
            hipsSprite.loadGraphic(ImgMHips,true,true,32,32,true);
            armLSprite.loadGraphic(ImgMArmL,true,true,66,14,true);
            armRSprite.loadGraphic(ImgMArmR,true,true,66,14,true);
            legLSprite.loadGraphic(ImgMLegL,true,true,19,82,true);
            legRSprite.loadGraphic(ImgMLegR,true,true,19,82,true);
            footLSprite.loadGraphic(ImgMFootL,true,true,23,14,true);
            footRSprite.loadGraphic(ImgMFootR,true,true,23,14,true);
         }
         FlxG.state.add(armLSprite);
         FlxG.state.add(armRSprite);
         FlxG.state.add(hipsSprite);
         FlxG.state.add(legLSprite);
         FlxG.state.add(legRSprite);
         FlxG.state.add(footLSprite);
         FlxG.state.add(footRSprite);
         FlxG.state.add(chestSprite);
         FlxG.state.add(headSprite);
      }
   }
}
