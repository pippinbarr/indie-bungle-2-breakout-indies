package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   public class b2PrismaticJointDef extends b2JointDef
   {
       
      public var localAnchorA:b2Vec2;
      
      public var localAnchorB:b2Vec2;
      
      public var localAxisA:b2Vec2;
      
      public var referenceAngle:Number;
      
      public var enableLimit:Boolean;
      
      public var lowerTranslation:Number;
      
      public var upperTranslation:Number;
      
      public var enableMotor:Boolean;
      
      public var maxMotorForce:Number;
      
      public var motorSpeed:Number;
      
      public function b2PrismaticJointDef()
      {
         localAnchorA = new b2Vec2();
         localAnchorB = new b2Vec2();
         localAxisA = new b2Vec2();
         super();
         type = 2;
         localAxisA.Set(1,0);
         referenceAngle = 0;
         enableLimit = false;
         lowerTranslation = 0;
         upperTranslation = 0;
         enableMotor = false;
         maxMotorForce = 0;
         motorSpeed = 0;
      }
      
      public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2) : void
      {
         bodyA = param1;
         bodyB = param2;
         localAnchorA = bodyA.GetLocalPoint(param3);
         localAnchorB = bodyB.GetLocalPoint(param3);
         localAxisA = bodyA.GetLocalVector(param4);
         referenceAngle = bodyB.GetAngle() - bodyA.GetAngle();
      }
   }
}
