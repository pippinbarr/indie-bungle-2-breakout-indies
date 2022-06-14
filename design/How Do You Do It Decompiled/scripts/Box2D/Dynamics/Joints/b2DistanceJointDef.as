package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   public class b2DistanceJointDef extends b2JointDef
   {
       
      public var localAnchorA:b2Vec2;
      
      public var localAnchorB:b2Vec2;
      
      public var length:Number;
      
      public var frequencyHz:Number;
      
      public var dampingRatio:Number;
      
      public function b2DistanceJointDef()
      {
         localAnchorA = new b2Vec2();
         localAnchorB = new b2Vec2();
         super();
         type = 3;
         length = 1;
         frequencyHz = 0;
         dampingRatio = 0;
      }
      
      public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2) : void
      {
         bodyA = param1;
         bodyB = param2;
         localAnchorA.SetV(bodyA.GetLocalPoint(param3));
         localAnchorB.SetV(bodyB.GetLocalPoint(param4));
         var _loc5_:Number = param4.x - param3.x;
         var _loc6_:Number = param4.y - param3.y;
         length = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
         frequencyHz = 0;
         dampingRatio = 0;
      }
   }
}
