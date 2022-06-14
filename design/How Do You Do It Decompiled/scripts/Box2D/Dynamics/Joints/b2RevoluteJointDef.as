package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   public class b2RevoluteJointDef extends b2JointDef
   {
       
      public var localAnchorA:b2Vec2;
      
      public var localAnchorB:b2Vec2;
      
      public var referenceAngle:Number;
      
      public var enableLimit:Boolean;
      
      public var lowerAngle:Number;
      
      public var upperAngle:Number;
      
      public var enableMotor:Boolean;
      
      public var motorSpeed:Number;
      
      public var maxMotorTorque:Number;
      
      public function b2RevoluteJointDef()
      {
         localAnchorA = new b2Vec2();
         localAnchorB = new b2Vec2();
         super();
         type = 1;
         localAnchorA.Set(0,0);
         localAnchorB.Set(0,0);
         referenceAngle = 0;
         lowerAngle = 0;
         upperAngle = 0;
         maxMotorTorque = 0;
         motorSpeed = 0;
         enableLimit = false;
         enableMotor = false;
      }
      
      public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2) : void
      {
         bodyA = param1;
         bodyB = param2;
         localAnchorA = bodyA.GetLocalPoint(param3);
         localAnchorB = bodyB.GetLocalPoint(param3);
         referenceAngle = bodyB.GetAngle() - bodyA.GetAngle();
      }
   }
}
