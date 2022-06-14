package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   public class b2PulleyJointDef extends b2JointDef
   {
       
      public var groundAnchorA:b2Vec2;
      
      public var groundAnchorB:b2Vec2;
      
      public var localAnchorA:b2Vec2;
      
      public var localAnchorB:b2Vec2;
      
      public var lengthA:Number;
      
      public var maxLengthA:Number;
      
      public var lengthB:Number;
      
      public var maxLengthB:Number;
      
      public var ratio:Number;
      
      public function b2PulleyJointDef()
      {
         groundAnchorA = new b2Vec2();
         groundAnchorB = new b2Vec2();
         localAnchorA = new b2Vec2();
         localAnchorB = new b2Vec2();
         super();
         type = 4;
         groundAnchorA.Set(-1,1);
         groundAnchorB.Set(1,1);
         localAnchorA.Set(-1,0);
         localAnchorB.Set(1,0);
         lengthA = 0;
         maxLengthA = 0;
         lengthB = 0;
         maxLengthB = 0;
         ratio = 1;
         collideConnected = true;
      }
      
      public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:b2Vec2, param6:b2Vec2, param7:Number) : void
      {
         bodyA = param1;
         bodyB = param2;
         groundAnchorA.SetV(param3);
         groundAnchorB.SetV(param4);
         localAnchorA = bodyA.GetLocalPoint(param5);
         localAnchorB = bodyB.GetLocalPoint(param6);
         var _loc9_:Number = param5.x - param3.x;
         var _loc12_:Number = param5.y - param3.y;
         lengthA = Math.sqrt(_loc9_ * _loc9_ + _loc12_ * _loc12_);
         var _loc11_:Number = param6.x - param4.x;
         var _loc10_:Number = param6.y - param4.y;
         lengthB = Math.sqrt(_loc11_ * _loc11_ + _loc10_ * _loc10_);
         ratio = param7;
         var _loc8_:Number = lengthA + ratio * lengthB;
         maxLengthA = _loc8_ - ratio * 2;
         maxLengthB = (_loc8_ - 2) / ratio;
      }
   }
}
