package Box2D.Dynamics.Contacts
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Mat22;
   
   use namespace b2internal;
   
   class b2PositionSolverManifold
   {
      
      private static var circlePointA:b2Vec2 = new b2Vec2();
      
      private static var circlePointB:b2Vec2 = new b2Vec2();
       
      public var m_normal:b2Vec2;
      
      public var m_points:Vector.<b2Vec2>;
      
      public var m_separations:Vector.<Number>;
      
      function b2PositionSolverManifold()
      {
         var _loc1_:* = 0;
         super();
         m_normal = new b2Vec2();
         m_separations = new Vector.<Number>(2);
         m_points = new Vector.<b2Vec2>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            m_points[_loc1_] = new b2Vec2();
            _loc1_++;
         }
      }
      
      public function Initialize(param1:b2ContactConstraint) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = NaN;
         var _loc7_:* = NaN;
         var _loc13_:* = null;
         var _loc9_:* = null;
         var _loc16_:* = NaN;
         var _loc15_:* = NaN;
         var _loc11_:* = NaN;
         var _loc10_:* = NaN;
         var _loc14_:* = NaN;
         var _loc12_:* = NaN;
         var _loc6_:* = NaN;
         var _loc8_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:* = NaN;
         b2Settings.b2Assert(param1.pointCount > 0);
         switch(param1.type - 1)
         {
            case 0:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc9_ = param1.localPoint;
               _loc11_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
               _loc10_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc9_ = param1.points[0].localPoint;
               _loc14_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
               _loc12_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
               _loc6_ = _loc14_ - _loc11_;
               _loc8_ = _loc12_ - _loc10_;
               _loc4_ = _loc6_ * _loc6_ + _loc8_ * _loc8_;
               if(_loc4_ > Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc2_ = Math.sqrt(_loc4_);
                  m_normal.x = _loc6_ / _loc2_;
                  m_normal.y = _loc8_ / _loc2_;
               }
               else
               {
                  m_normal.x = 1;
                  m_normal.y = 0;
               }
               m_points[0].x = 0.5 * (_loc11_ + _loc14_);
               m_points[0].y = 0.5 * (_loc10_ + _loc12_);
               m_separations[0] = _loc6_ * m_normal.x + _loc8_ * m_normal.y - param1.radius;
               break;
            case 1:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc9_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y;
               m_normal.y = _loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y;
               _loc13_ = param1.bodyA.m_xf.R;
               _loc9_ = param1.localPoint;
               _loc16_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
               _loc15_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc3_ = 0;
               while(_loc3_ < param1.pointCount)
               {
                  _loc9_ = param1.points[_loc3_].localPoint;
                  _loc5_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
                  _loc7_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
                  m_separations[_loc3_] = (_loc5_ - _loc16_) * m_normal.x + (_loc7_ - _loc15_) * m_normal.y - param1.radius;
                  m_points[_loc3_].x = _loc5_;
                  m_points[_loc3_].y = _loc7_;
                  _loc3_++;
               }
            case 3:
               _loc13_ = param1.bodyB.m_xf.R;
               _loc9_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y;
               m_normal.y = _loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y;
               _loc13_ = param1.bodyB.m_xf.R;
               _loc9_ = param1.localPoint;
               _loc16_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
               _loc15_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
               _loc13_ = param1.bodyA.m_xf.R;
               _loc3_ = 0;
               while(_loc3_ < param1.pointCount)
               {
                  _loc9_ = param1.points[_loc3_].localPoint;
                  _loc5_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
                  _loc7_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
                  m_separations[_loc3_] = (_loc5_ - _loc16_) * m_normal.x + (_loc7_ - _loc15_) * m_normal.y - param1.radius;
                  m_points[_loc3_].Set(_loc5_,_loc7_);
                  _loc3_++;
               }
               m_normal.x = m_normal.x * -1;
               m_normal.y = m_normal.y * -1;
               break;
            default:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc9_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y;
               m_normal.y = _loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y;
               _loc13_ = param1.bodyA.m_xf.R;
               _loc9_ = param1.localPoint;
               _loc16_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
               _loc15_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc3_ = 0;
               while(_loc3_ < param1.pointCount)
               {
                  _loc9_ = param1.points[_loc3_].localPoint;
                  _loc5_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
                  _loc7_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
                  m_separations[_loc3_] = (_loc5_ - _loc16_) * m_normal.x + (_loc7_ - _loc15_) * m_normal.y - param1.radius;
                  m_points[_loc3_].x = _loc5_;
                  m_points[_loc3_].y = _loc7_;
                  _loc3_++;
               }
         }
      }
   }
}
