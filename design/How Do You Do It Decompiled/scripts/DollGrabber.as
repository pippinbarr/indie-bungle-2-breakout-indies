package
{
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   
   public class DollGrabber
   {
       
      public var m_mouseJoint:b2MouseJoint;
      
      public var doll:PhysicsDoll;
      
      public var worldBounds:b2AABB;
      
      public var pos:b2Vec2;
      
      public function DollGrabber()
      {
         super();
      }
      
      public function create(param1:PhysicsDoll, param2:b2World, param3:b2AABB) : void
      {
         this.doll = param1;
         this.worldBounds = param3;
         var _loc4_:b2MouseJointDef = new b2MouseJointDef();
         _loc4_.bodyA = param2.GetGroundBody();
         _loc4_.bodyB = param1.midriff;
         _loc4_.target.Set(param1.midriff.GetPosition().x,param1.midriff.GetPosition().y);
         _loc4_.collideConnected = true;
         _loc4_.maxForce = 3000 * param1.midriff.GetMass();
         m_mouseJoint = param2.CreateJoint(_loc4_) as b2MouseJoint;
      }
      
      public function update() : void
      {
      }
      
      public function SetTransform(param1:b2Vec2, param2:Number, param3:Boolean = false) : void
      {
         var _loc7_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc4_:b2AABB = new b2AABB();
         _loc4_.lowerBound.Set(param1.x,param1.y);
         _loc4_.upperBound.Set(param1.x,param1.y);
         if(worldBounds.Contains(_loc4_) || param3)
         {
            _loc7_ = worldBounds.upperBound.x / 2;
            _loc5_ = _loc7_ - 1;
            _loc6_ = _loc7_ + 1;
            if(m_mouseJoint.GetTarget().x < _loc7_ && param1.x < _loc5_ || m_mouseJoint.GetTarget().x > _loc7_ && param1.x > _loc6_)
            {
               m_mouseJoint.SetTarget(param1);
               this.pos = param1;
            }
         }
         doll.midriff.SetAngle(param2);
      }
   }
}
