package
{
   import org.flixel.FlxText;
   import Box2D.Common.Math.b2Vec2;
   import org.flixel.FlxG;
   
   public class DollController
   {
      
      public static var dollTranslateSpeed:Number;
      
      public static var dollRotateSpeed:Number;
       
      public var doll1:DollGrabber;
      
      public var doll2:DollGrabber;
      
      public var arm1:Arm;
      
      public var arm2:Arm;
      
      public var speed:Number = 0.055;
      
      public var speed_up:Number = 0.5;
      
      public var t:FlxText;
      
      public var rotateMirror:Boolean = false;
      
      public var isClose:Boolean;
      
      public var timeFrame:Number = 0;
      
      public var timeSec:Number = 0;
      
      public function DollController(param1:DollGrabber, param2:DollGrabber, param3:Arm, param4:Arm)
      {
         super();
         dollRotateSpeed = speed;
         dollTranslateSpeed = speed;
         this.doll1 = param1;
         this.doll2 = param2;
         this.arm1 = param3;
         this.arm2 = param4;
         t = new FlxText(100,100,100,"");
         FlxG.state.add(t);
      }
      
      public function update(param1:Number) : Boolean
      {
         timeFrame = timeFrame + 1;
         if(timeFrame % 500 == 0)
         {
            rotateMirror = rotateMirror?false:true;
         }
         var _loc9_:* = false;
         if(param1 < 2)
         {
            _loc9_ = true;
         }
         var _loc2_:* = false;
         var _loc3_:Number = dollProximity(_loc9_);
         if(_loc3_ < 7.5)
         {
            this.isClose = true;
         }
         else
         {
            this.isClose = false;
         }
         var _loc12_:b2Vec2 = doll1.m_mouseJoint.GetTarget().Copy();
         var _loc11_:b2Vec2 = doll2.m_mouseJoint.GetTarget().Copy();
         var _loc5_:Number = doll1.doll.midriff.GetAngle();
         var _loc6_:Number = doll2.doll.midriff.GetAngle();
         var _loc4_:* = false;
         var _loc7_:* = false;
         var _loc8_:* = false;
         var _loc10_:* = false;
         if(FlxG.keys.D || _loc9_ && _loc3_ > 7.5)
         {
            _loc7_ = true;
            _loc4_ = false;
            _loc2_ = true;
         }
         else if(FlxG.keys.A)
         {
            _loc7_ = false;
            _loc4_ = true;
            _loc2_ = true;
         }
         if(FlxG.keys.S)
         {
            _loc8_ = false;
            _loc10_ = true;
            _loc2_ = true;
         }
         else if(FlxG.keys.W)
         {
            _loc8_ = true;
            _loc10_ = false;
            _loc2_ = true;
         }
         if(FlxG.keys.J)
         {
            _loc2_ = true;
            if(rotateMirror)
            {
               _loc5_ = _loc5_ + dollRotateSpeed;
               arm1.turn(true);
            }
            else
            {
               _loc6_ = _loc6_ - dollRotateSpeed;
               arm2.turn(false);
            }
         }
         else if(FlxG.keys.K)
         {
            _loc2_ = true;
            if(rotateMirror)
            {
               _loc6_ = _loc6_ - dollRotateSpeed;
               arm2.turn(false);
            }
            else
            {
               _loc5_ = _loc5_ + dollRotateSpeed;
               arm1.turn(true);
            }
         }
         else
         {
            arm1.stopTurning();
            arm2.stopTurning();
         }
         if(_loc9_)
         {
            dollTranslateSpeed = 1;
         }
         if(_loc4_)
         {
            _loc12_.x = _loc12_.x - dollTranslateSpeed;
            _loc11_.x = _loc11_.x + dollTranslateSpeed;
         }
         if(_loc7_)
         {
            _loc12_.x = _loc12_.x + dollTranslateSpeed;
            _loc11_.x = _loc11_.x - dollTranslateSpeed;
         }
         if(_loc8_)
         {
            _loc12_.y = _loc12_.y - dollTranslateSpeed;
            _loc11_.y = _loc11_.y - dollTranslateSpeed;
         }
         if(_loc10_)
         {
            _loc12_.y = _loc12_.y + dollTranslateSpeed;
            _loc11_.y = _loc11_.y + dollTranslateSpeed;
         }
         doll1.SetTransform(_loc12_,_loc5_,_loc9_);
         doll2.SetTransform(_loc11_,_loc6_,_loc9_);
         return _loc2_;
      }
      
      public function dollProximity(param1:Boolean) : Number
      {
         var _loc2_:Number = Math.abs(doll1.doll.midriff.GetPosition().x - doll2.doll.midriff.GetPosition().y);
         var _loc3_:Number = Math.abs(doll1.doll.midriff.GetPosition().y - doll2.doll.midriff.GetPosition().x);
         var _loc4_:Number = Math.sqrt(Math.pow(_loc2_,2) + Math.pow(_loc3_,2));
         if(param1)
         {
            return _loc4_;
         }
         if(_loc4_ < 7.5)
         {
            dollTranslateSpeed = speed_up;
            this.isClose == true;
         }
         else
         {
            dollTranslateSpeed = speed;
            this.isClose == false;
         }
         return _loc4_;
      }
   }
}
