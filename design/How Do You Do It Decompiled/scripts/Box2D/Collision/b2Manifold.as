package Box2D.Collision
{
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Vec2;
   
   use namespace b2internal;
   
   public class b2Manifold
   {
      
      public static const e_circles:int = 1;
      
      public static const e_faceA:int = 2;
      
      public static const e_faceB:int = 4;
       
      public var m_points:Vector.<Box2D.Collision.b2ManifoldPoint>;
      
      public var m_localPlaneNormal:b2Vec2;
      
      public var m_localPoint:b2Vec2;
      
      public var m_type:int;
      
      public var m_pointCount:int = 0;
      
      public function b2Manifold()
      {
         var _loc1_:* = 0;
         super();
         m_points = new Vector.<Box2D.Collision.b2ManifoldPoint>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            m_points[_loc1_] = new Box2D.Collision.b2ManifoldPoint();
            _loc1_++;
         }
         m_localPlaneNormal = new b2Vec2();
         m_localPoint = new b2Vec2();
      }
      
      public function Reset() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            (m_points[_loc1_] as Box2D.Collision.b2ManifoldPoint).Reset();
            _loc1_++;
         }
         m_localPlaneNormal.SetZero();
         m_localPoint.SetZero();
         m_type = 0;
         m_pointCount = 0;
      }
      
      public function Set(param1:b2Manifold) : void
      {
         var _loc2_:* = 0;
         m_pointCount = param1.m_pointCount;
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            (m_points[_loc2_] as Box2D.Collision.b2ManifoldPoint).Set(param1.m_points[_loc2_]);
            _loc2_++;
         }
         m_localPlaneNormal.SetV(param1.m_localPlaneNormal);
         m_localPoint.SetV(param1.m_localPoint);
         m_type = param1.m_type;
      }
      
      public function Copy() : b2Manifold
      {
         var _loc1_:b2Manifold = new b2Manifold();
         _loc1_.Set(this);
         return _loc1_;
      }
   }
}
