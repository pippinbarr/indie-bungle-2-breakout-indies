package Box2D.Collision.Shapes
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Collision.b2DistanceInput;
   import Box2D.Collision.b2DistanceProxy;
   import Box2D.Collision.b2SimplexCache;
   import Box2D.Collision.b2DistanceOutput;
   import Box2D.Collision.b2Distance;
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2AABB;
   
   use namespace b2internal;
   
   public class b2Shape
   {
      
      b2internal static const e_unknownShape:int = -1;
      
      b2internal static const e_circleShape:int = 0;
      
      b2internal static const e_polygonShape:int = 1;
      
      b2internal static const e_edgeShape:int = 2;
      
      b2internal static const e_shapeTypeCount:int = 3;
      
      public static const e_hitCollide:int = 1;
      
      public static const e_missCollide:int = 0;
      
      public static const e_startsInsideCollide:int = -1;
       
      b2internal var m_type:int;
      
      b2internal var m_radius:Number;
      
      public function b2Shape()
      {
         super();
         m_type = -1;
         m_radius = 0.005;
      }
      
      public static function TestOverlap(param1:b2Shape, param2:b2Transform, param3:b2Shape, param4:b2Transform) : Boolean
      {
         var _loc6_:b2DistanceInput = new b2DistanceInput();
         _loc6_.proxyA = new b2DistanceProxy();
         _loc6_.proxyA.Set(param1);
         _loc6_.proxyB = new b2DistanceProxy();
         _loc6_.proxyB.Set(param3);
         _loc6_.transformA = param2;
         _loc6_.transformB = param4;
         _loc6_.useRadii = true;
         var _loc7_:b2SimplexCache = new b2SimplexCache();
         _loc7_.count = 0;
         var _loc5_:b2DistanceOutput = new b2DistanceOutput();
         b2Distance.Distance(_loc5_,_loc7_,_loc6_);
         return _loc5_.distance < 10 * Number.MIN_VALUE;
      }
      
      public function Copy() : b2Shape
      {
         return null;
      }
      
      public function Set(param1:b2Shape) : void
      {
         m_radius = param1.m_radius;
      }
      
      public function GetType() : int
      {
         return m_type;
      }
      
      public function TestPoint(param1:b2Transform, param2:b2Vec2) : Boolean
      {
         return false;
      }
      
      public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput, param3:b2Transform) : Boolean
      {
         return false;
      }
      
      public function ComputeAABB(param1:b2AABB, param2:b2Transform) : void
      {
      }
      
      public function ComputeMass(param1:b2MassData, param2:Number) : void
      {
      }
      
      public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2Transform, param4:b2Vec2) : Number
      {
         return 0;
      }
   }
}
