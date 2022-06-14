package Box2D.Dynamics.Contacts
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Dynamics.b2Body;
   import Box2D.Collision.b2Manifold;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2ContactConstraint
   {
       
      public var points:Vector.<Box2D.Dynamics.Contacts.b2ContactConstraintPoint>;
      
      public var localPlaneNormal:b2Vec2;
      
      public var localPoint:b2Vec2;
      
      public var normal:b2Vec2;
      
      public var normalMass:b2Mat22;
      
      public var K:b2Mat22;
      
      public var bodyA:b2Body;
      
      public var bodyB:b2Body;
      
      public var type:int;
      
      public var radius:Number;
      
      public var friction:Number;
      
      public var restitution:Number;
      
      public var pointCount:int;
      
      public var manifold:b2Manifold;
      
      public function b2ContactConstraint()
      {
         var _loc1_:* = 0;
         localPlaneNormal = new b2Vec2();
         localPoint = new b2Vec2();
         normal = new b2Vec2();
         normalMass = new b2Mat22();
         K = new b2Mat22();
         super();
         points = new Vector.<Box2D.Dynamics.Contacts.b2ContactConstraintPoint>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            points[_loc1_] = new Box2D.Dynamics.Contacts.b2ContactConstraintPoint();
            _loc1_++;
         }
      }
   }
}
