package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Collision.Shapes.b2CircleShape;
   
   use namespace b2internal;
   
   public class b2Collision
   {
      
      public static const b2_nullFeature:uint = 255;
      
      private static var s_incidentEdge:Vector.<Box2D.Collision.ClipVertex> = MakeClipPointVector();
      
      private static var s_clipPoints1:Vector.<Box2D.Collision.ClipVertex> = MakeClipPointVector();
      
      private static var s_clipPoints2:Vector.<Box2D.Collision.ClipVertex> = MakeClipPointVector();
      
      private static var s_edgeAO:Vector.<int> = new Vector.<int>(1);
      
      private static var s_edgeBO:Vector.<int> = new Vector.<int>(1);
      
      private static var s_localTangent:b2Vec2 = new b2Vec2();
      
      private static var s_localNormal:b2Vec2 = new b2Vec2();
      
      private static var s_planePoint:b2Vec2 = new b2Vec2();
      
      private static var s_normal:b2Vec2 = new b2Vec2();
      
      private static var s_tangent:b2Vec2 = new b2Vec2();
      
      private static var s_tangent2:b2Vec2 = new b2Vec2();
      
      private static var s_v11:b2Vec2 = new b2Vec2();
      
      private static var s_v12:b2Vec2 = new b2Vec2();
      
      private static var b2CollidePolyTempVec:b2Vec2 = new b2Vec2();
       
      public function b2Collision()
      {
         super();
      }
      
      public static function ClipSegmentToLine(param1:Vector.<Box2D.Collision.ClipVertex>, param2:Vector.<Box2D.Collision.ClipVertex>, param3:b2Vec2, param4:Number) : int
      {
         var _loc11_:* = null;
         var _loc9_:* = NaN;
         var _loc12_:* = null;
         var _loc13_:* = null;
         var _loc10_:* = 0;
         _loc11_ = param2[0];
         var _loc6_:b2Vec2 = _loc11_.v;
         _loc11_ = param2[1];
         var _loc5_:b2Vec2 = _loc11_.v;
         var _loc8_:Number = param3.x * _loc6_.x + param3.y * _loc6_.y - param4;
         var _loc7_:Number = param3.x * _loc5_.x + param3.y * _loc5_.y - param4;
         if(_loc8_ <= 0)
         {
            _loc10_++;
            param1[_loc10_].Set(param2[0]);
         }
         if(_loc7_ <= 0)
         {
            _loc10_++;
            param1[_loc10_].Set(param2[1]);
         }
         if(_loc8_ * _loc7_ < 0)
         {
            _loc9_ = _loc8_ / (_loc8_ - _loc7_);
            _loc11_ = param1[_loc10_];
            _loc12_ = _loc11_.v;
            _loc12_.x = _loc6_.x + _loc9_ * (_loc5_.x - _loc6_.x);
            _loc12_.y = _loc6_.y + _loc9_ * (_loc5_.y - _loc6_.y);
            _loc11_ = param1[_loc10_];
            if(_loc8_ > 0)
            {
               _loc13_ = param2[0];
               _loc11_.id = _loc13_.id;
            }
            else
            {
               _loc13_ = param2[1];
               _loc11_.id = _loc13_.id;
            }
            _loc10_++;
         }
         return _loc10_;
      }
      
      public static function EdgeSeparation(param1:b2PolygonShape, param2:b2Transform, param3:int, param4:b2PolygonShape, param5:b2Transform) : Number
      {
         var _loc23_:* = null;
         var _loc22_:* = null;
         var _loc20_:* = 0;
         var _loc9_:* = NaN;
         var _loc6_:int = param1.m_vertexCount;
         var _loc8_:Vector.<b2Vec2> = param1.m_vertices;
         var _loc11_:Vector.<b2Vec2> = param1.m_normals;
         var _loc7_:int = param4.m_vertexCount;
         var _loc10_:Vector.<b2Vec2> = param4.m_vertices;
         _loc23_ = param2.R;
         _loc22_ = _loc11_[param3];
         var _loc17_:Number = _loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y;
         var _loc15_:Number = _loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y;
         _loc23_ = param5.R;
         var _loc18_:Number = _loc23_.col1.x * _loc17_ + _loc23_.col1.y * _loc15_;
         var _loc16_:Number = _loc23_.col2.x * _loc17_ + _loc23_.col2.y * _loc15_;
         var _loc19_:* = 0;
         var _loc21_:* = 1.7976931348623157E308;
         _loc20_ = 0;
         while(_loc20_ < _loc7_)
         {
            _loc22_ = _loc10_[_loc20_];
            _loc9_ = _loc22_.x * _loc18_ + _loc22_.y * _loc16_;
            if(_loc9_ < _loc21_)
            {
               _loc21_ = _loc9_;
               _loc19_ = _loc20_;
            }
            _loc20_++;
         }
         _loc22_ = _loc8_[param3];
         _loc23_ = param2.R;
         var _loc24_:Number = param2.position.x + (_loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y);
         var _loc25_:Number = param2.position.y + (_loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y);
         _loc22_ = _loc10_[_loc19_];
         _loc23_ = param5.R;
         var _loc14_:Number = param5.position.x + (_loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y);
         var _loc13_:Number = param5.position.y + (_loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y);
         _loc14_ = _loc14_ - _loc24_;
         _loc13_ = _loc13_ - _loc25_;
         var _loc12_:Number = _loc14_ * _loc17_ + _loc13_ * _loc15_;
         return _loc12_;
      }
      
      public static function FindMaxSeparation(param1:Vector.<int>, param2:b2PolygonShape, param3:b2Transform, param4:b2PolygonShape, param5:b2Transform) : Number
      {
         var _loc20_:* = null;
         var _loc23_:* = null;
         var _loc16_:* = 0;
         var _loc7_:* = NaN;
         var _loc8_:* = 0;
         var _loc15_:* = NaN;
         var _loc9_:* = 0;
         var _loc6_:int = param2.m_vertexCount;
         var _loc11_:Vector.<b2Vec2> = param2.m_normals;
         _loc23_ = param5.R;
         _loc20_ = param4.m_centroid;
         var _loc18_:Number = param5.position.x + (_loc23_.col1.x * _loc20_.x + _loc23_.col2.x * _loc20_.y);
         var _loc19_:Number = param5.position.y + (_loc23_.col1.y * _loc20_.x + _loc23_.col2.y * _loc20_.y);
         _loc23_ = param3.R;
         _loc20_ = param2.m_centroid;
         _loc18_ = _loc18_ - (param3.position.x + (_loc23_.col1.x * _loc20_.x + _loc23_.col2.x * _loc20_.y));
         _loc19_ = _loc19_ - (param3.position.y + (_loc23_.col1.y * _loc20_.x + _loc23_.col2.y * _loc20_.y));
         var _loc22_:Number = _loc18_ * param3.R.col1.x + _loc19_ * param3.R.col1.y;
         var _loc21_:Number = _loc18_ * param3.R.col2.x + _loc19_ * param3.R.col2.y;
         var _loc13_:* = 0;
         var _loc10_:* = -1.7976931348623157E308;
         _loc16_ = 0;
         while(_loc16_ < _loc6_)
         {
            _loc20_ = _loc11_[_loc16_];
            _loc7_ = _loc20_.x * _loc22_ + _loc20_.y * _loc21_;
            if(_loc7_ > _loc10_)
            {
               _loc10_ = _loc7_;
               _loc13_ = _loc16_;
            }
            _loc16_++;
         }
         var _loc17_:Number = EdgeSeparation(param2,param3,_loc13_,param4,param5);
         var _loc14_:int = _loc13_ - 1 >= 0?_loc13_ - 1:_loc6_ - 1;
         var _loc24_:Number = EdgeSeparation(param2,param3,_loc14_,param4,param5);
         var _loc12_:int = _loc13_ + 1 < _loc6_?_loc13_ + 1:0.0;
         var _loc25_:Number = EdgeSeparation(param2,param3,_loc12_,param4,param5);
         if(_loc24_ > _loc17_ && _loc24_ > _loc25_)
         {
            _loc9_ = -1;
            _loc8_ = _loc14_;
            _loc15_ = _loc24_;
         }
         else if(_loc25_ > _loc17_)
         {
            _loc9_ = 1;
            _loc8_ = _loc12_;
            _loc15_ = _loc25_;
         }
         else
         {
            param1[0] = _loc13_;
            return _loc17_;
         }
         while(true)
         {
            if(_loc9_ == -1)
            {
               _loc13_ = _loc8_ - 1 >= 0?_loc8_ - 1:_loc6_ - 1;
            }
            else
            {
               _loc13_ = _loc8_ + 1 < _loc6_?_loc8_ + 1:0.0;
            }
            _loc17_ = EdgeSeparation(param2,param3,_loc13_,param4,param5);
            if(_loc17_ > _loc15_)
            {
               _loc8_ = _loc13_;
               _loc15_ = _loc17_;
               continue;
            }
            break;
         }
         param1[0] = _loc8_;
         return _loc15_;
      }
      
      public static function FindIncidentEdge(param1:Vector.<Box2D.Collision.ClipVertex>, param2:b2PolygonShape, param3:b2Transform, param4:int, param5:b2PolygonShape, param6:b2Transform) : void
      {
         var _loc23_:* = null;
         var _loc22_:* = null;
         var _loc17_:* = 0;
         var _loc13_:* = NaN;
         var _loc12_:* = null;
         var _loc7_:int = param2.m_vertexCount;
         var _loc21_:Vector.<b2Vec2> = param2.m_normals;
         var _loc8_:int = param5.m_vertexCount;
         var _loc15_:Vector.<b2Vec2> = param5.m_vertices;
         var _loc19_:Vector.<b2Vec2> = param5.m_normals;
         _loc23_ = param3.R;
         _loc22_ = _loc21_[param4];
         var _loc11_:Number = _loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y;
         var _loc9_:Number = _loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y;
         _loc23_ = param6.R;
         var _loc10_:Number = _loc23_.col1.x * _loc11_ + _loc23_.col1.y * _loc9_;
         _loc9_ = _loc23_.col2.x * _loc11_ + _loc23_.col2.y * _loc9_;
         _loc11_ = _loc10_;
         var _loc16_:* = 0;
         var _loc20_:* = 1.7976931348623157E308;
         _loc17_ = 0;
         while(_loc17_ < _loc8_)
         {
            _loc22_ = _loc19_[_loc17_];
            _loc13_ = _loc11_ * _loc22_.x + _loc9_ * _loc22_.y;
            if(_loc13_ < _loc20_)
            {
               _loc20_ = _loc13_;
               _loc16_ = _loc17_;
            }
            _loc17_++;
         }
         var _loc14_:* = _loc16_;
         var _loc18_:int = _loc14_ + 1 < _loc8_?_loc14_ + 1:0.0;
         _loc12_ = param1[0];
         _loc22_ = _loc15_[_loc14_];
         _loc23_ = param6.R;
         _loc12_.v.x = param6.position.x + (_loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y);
         _loc12_.v.y = param6.position.y + (_loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y);
         _loc12_.id.features.referenceEdge = param4;
         _loc12_.id.features.incidentEdge = _loc14_;
         _loc12_.id.features.incidentVertex = 0;
         _loc12_ = param1[1];
         _loc22_ = _loc15_[_loc18_];
         _loc23_ = param6.R;
         _loc12_.v.x = param6.position.x + (_loc23_.col1.x * _loc22_.x + _loc23_.col2.x * _loc22_.y);
         _loc12_.v.y = param6.position.y + (_loc23_.col1.y * _loc22_.x + _loc23_.col2.y * _loc22_.y);
         _loc12_.id.features.referenceEdge = param4;
         _loc12_.id.features.incidentEdge = _loc18_;
         _loc12_.id.features.incidentVertex = 1;
      }
      
      private static function MakeClipPointVector() : Vector.<Box2D.Collision.ClipVertex>
      {
         var _loc1_:Vector.<Box2D.Collision.ClipVertex> = new Vector.<Box2D.Collision.ClipVertex>(2);
         _loc1_[0] = new Box2D.Collision.ClipVertex();
         _loc1_[1] = new Box2D.Collision.ClipVertex();
         return _loc1_;
      }
      
      public static function CollidePolygons(param1:b2Manifold, param2:b2PolygonShape, param3:b2Transform, param4:b2PolygonShape, param5:b2Transform) : void
      {
         var _loc40_:* = null;
         var _loc44_:* = null;
         var _loc42_:* = null;
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc33_:* = 0;
         var _loc21_:* = 0;
         var _loc11_:* = NaN;
         _loc11_ = 0.98;
         var _loc31_:* = NaN;
         _loc31_ = 0.001;
         var _loc43_:* = null;
         var _loc34_:* = null;
         var _loc8_:* = 0;
         var _loc32_:* = 0;
         var _loc13_:* = NaN;
         var _loc37_:* = null;
         var _loc26_:* = NaN;
         var _loc28_:* = NaN;
         param1.m_pointCount = 0;
         var _loc15_:Number = param2.m_radius + param4.m_radius;
         var _loc18_:* = 0;
         s_edgeAO[0] = _loc18_;
         var _loc24_:Number = FindMaxSeparation(s_edgeAO,param2,param3,param4,param5);
         _loc18_ = s_edgeAO[0];
         if(_loc24_ > _loc15_)
         {
            return;
         }
         var _loc19_:* = 0;
         s_edgeBO[0] = _loc19_;
         var _loc27_:Number = FindMaxSeparation(s_edgeBO,param4,param5,param2,param3);
         _loc19_ = s_edgeBO[0];
         if(_loc27_ > _loc15_)
         {
            return;
         }
         if(_loc27_ > 0.98 * _loc24_ + 0.001)
         {
            _loc44_ = param4;
            _loc42_ = param2;
            _loc7_ = param5;
            _loc9_ = param3;
            _loc33_ = _loc19_;
            param1.m_type = 4;
            _loc21_ = 1;
         }
         else
         {
            _loc44_ = param2;
            _loc42_ = param4;
            _loc7_ = param3;
            _loc9_ = param5;
            _loc33_ = _loc18_;
            param1.m_type = 2;
            _loc21_ = 0;
         }
         var _loc38_:Vector.<Box2D.Collision.ClipVertex> = s_incidentEdge;
         FindIncidentEdge(_loc38_,_loc44_,_loc7_,_loc33_,_loc42_,_loc9_);
         var _loc6_:int = _loc44_.m_vertexCount;
         var _loc10_:Vector.<b2Vec2> = _loc44_.m_vertices;
         var _loc36_:b2Vec2 = _loc10_[_loc33_];
         if(_loc33_ + 1 < _loc6_)
         {
            _loc34_ = _loc10_[_loc33_ + 1];
         }
         else
         {
            _loc34_ = _loc10_[0];
         }
         var _loc25_:b2Vec2 = s_localTangent;
         _loc25_.Set(_loc34_.x - _loc36_.x,_loc34_.y - _loc36_.y);
         _loc25_.Normalize();
         var _loc20_:b2Vec2 = s_localNormal;
         _loc20_.x = _loc25_.y;
         _loc20_.y = -_loc25_.x;
         var _loc22_:b2Vec2 = s_planePoint;
         _loc22_.Set(0.5 * (_loc36_.x + _loc34_.x),0.5 * (_loc36_.y + _loc34_.y));
         var _loc12_:b2Vec2 = s_tangent;
         _loc43_ = _loc7_.R;
         _loc12_.x = _loc43_.col1.x * _loc25_.x + _loc43_.col2.x * _loc25_.y;
         _loc12_.y = _loc43_.col1.y * _loc25_.x + _loc43_.col2.y * _loc25_.y;
         var _loc17_:b2Vec2 = s_tangent2;
         _loc17_.x = -_loc12_.x;
         _loc17_.y = -_loc12_.y;
         var _loc23_:b2Vec2 = s_normal;
         _loc23_.x = _loc12_.y;
         _loc23_.y = -_loc12_.x;
         var _loc16_:b2Vec2 = s_v11;
         var _loc14_:b2Vec2 = s_v12;
         _loc16_.x = _loc7_.position.x + (_loc43_.col1.x * _loc36_.x + _loc43_.col2.x * _loc36_.y);
         _loc16_.y = _loc7_.position.y + (_loc43_.col1.y * _loc36_.x + _loc43_.col2.y * _loc36_.y);
         _loc14_.x = _loc7_.position.x + (_loc43_.col1.x * _loc34_.x + _loc43_.col2.x * _loc34_.y);
         _loc14_.y = _loc7_.position.y + (_loc43_.col1.y * _loc34_.x + _loc43_.col2.y * _loc34_.y);
         var _loc35_:Number = _loc23_.x * _loc16_.x + _loc23_.y * _loc16_.y;
         var _loc45_:Number = -_loc12_.x * _loc16_.x - _loc12_.y * _loc16_.y + _loc15_;
         var _loc41_:Number = _loc12_.x * _loc14_.x + _loc12_.y * _loc14_.y + _loc15_;
         var _loc30_:Vector.<Box2D.Collision.ClipVertex> = s_clipPoints1;
         var _loc29_:Vector.<Box2D.Collision.ClipVertex> = s_clipPoints2;
         _loc8_ = ClipSegmentToLine(_loc30_,_loc38_,_loc17_,_loc45_);
         if(_loc8_ < 2)
         {
            return;
         }
         _loc8_ = ClipSegmentToLine(_loc29_,_loc30_,_loc12_,_loc41_);
         if(_loc8_ < 2)
         {
            return;
         }
         param1.m_localPlaneNormal.SetV(_loc20_);
         param1.m_localPoint.SetV(_loc22_);
         var _loc39_:* = 0;
         _loc32_ = 0;
         while(_loc32_ < 2)
         {
            _loc40_ = _loc29_[_loc32_];
            _loc13_ = _loc23_.x * _loc40_.v.x + _loc23_.y * _loc40_.v.y - _loc35_;
            if(_loc13_ <= _loc15_)
            {
               _loc37_ = param1.m_points[_loc39_];
               _loc43_ = _loc9_.R;
               _loc26_ = _loc40_.v.x - _loc9_.position.x;
               _loc28_ = _loc40_.v.y - _loc9_.position.y;
               _loc37_.m_localPoint.x = _loc26_ * _loc43_.col1.x + _loc28_ * _loc43_.col1.y;
               _loc37_.m_localPoint.y = _loc26_ * _loc43_.col2.x + _loc28_ * _loc43_.col2.y;
               _loc37_.m_id.Set(_loc40_.id);
               _loc37_.m_id.features.flip = _loc21_;
               _loc39_++;
            }
            _loc32_++;
         }
         param1.m_pointCount = _loc39_;
      }
      
      public static function CollideCircles(param1:b2Manifold, param2:b2CircleShape, param3:b2Transform, param4:b2CircleShape, param5:b2Transform) : void
      {
         var _loc13_:* = null;
         var _loc9_:* = null;
         param1.m_pointCount = 0;
         _loc13_ = param3.R;
         _loc9_ = param2.m_p;
         var _loc10_:Number = param3.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
         var _loc14_:Number = param3.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
         _loc13_ = param5.R;
         _loc9_ = param4.m_p;
         var _loc12_:Number = param5.position.x + (_loc13_.col1.x * _loc9_.x + _loc13_.col2.x * _loc9_.y);
         var _loc11_:Number = param5.position.y + (_loc13_.col1.y * _loc9_.x + _loc13_.col2.y * _loc9_.y);
         var _loc7_:Number = _loc12_ - _loc10_;
         var _loc8_:Number = _loc11_ - _loc14_;
         var _loc6_:Number = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc15_:Number = param2.m_radius + param4.m_radius;
         if(_loc6_ > _loc15_ * _loc15_)
         {
            return;
         }
         param1.m_type = 1;
         param1.m_localPoint.SetV(param2.m_p);
         param1.m_localPlaneNormal.SetZero();
         param1.m_pointCount = 1;
         param1.m_points[0].m_localPoint.SetV(param4.m_p);
         param1.m_points[0].m_id.key = 0;
      }
      
      public static function CollidePolygonAndCircle(param1:b2Manifold, param2:b2PolygonShape, param3:b2Transform, param4:b2CircleShape, param5:b2Transform) : void
      {
         var _loc24_:* = null;
         var _loc27_:* = NaN;
         var _loc28_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc29_:* = null;
         var _loc30_:* = null;
         var _loc7_:* = NaN;
         var _loc21_:* = 0;
         var _loc26_:* = NaN;
         var _loc19_:* = NaN;
         var _loc20_:* = NaN;
         param1.m_pointCount = 0;
         _loc30_ = param5.R;
         _loc29_ = param4.m_p;
         var _loc12_:Number = param5.position.x + (_loc30_.col1.x * _loc29_.x + _loc30_.col2.x * _loc29_.y);
         var _loc14_:Number = param5.position.y + (_loc30_.col1.y * _loc29_.x + _loc30_.col2.y * _loc29_.y);
         _loc27_ = _loc12_ - param3.position.x;
         _loc28_ = _loc14_ - param3.position.y;
         _loc30_ = param3.R;
         var _loc11_:Number = _loc27_ * _loc30_.col1.x + _loc28_ * _loc30_.col1.y;
         var _loc10_:Number = _loc27_ * _loc30_.col2.x + _loc28_ * _loc30_.col2.y;
         var _loc17_:* = 0;
         var _loc13_:* = -1.7976931348623157E308;
         var _loc15_:Number = param2.m_radius + param4.m_radius;
         var _loc22_:int = param2.m_vertexCount;
         var _loc6_:Vector.<b2Vec2> = param2.m_vertices;
         var _loc32_:Vector.<b2Vec2> = param2.m_normals;
         _loc21_ = 0;
         while(_loc21_ < _loc22_)
         {
            _loc29_ = _loc6_[_loc21_];
            _loc27_ = _loc11_ - _loc29_.x;
            _loc28_ = _loc10_ - _loc29_.y;
            _loc29_ = _loc32_[_loc21_];
            _loc26_ = _loc29_.x * _loc27_ + _loc29_.y * _loc28_;
            if(_loc26_ > _loc15_)
            {
               return;
            }
            if(_loc26_ > _loc13_)
            {
               _loc13_ = _loc26_;
               _loc17_ = _loc21_;
            }
            _loc21_++;
         }
         var _loc25_:* = _loc17_;
         var _loc23_:int = _loc25_ + 1 < _loc22_?_loc25_ + 1:0.0;
         var _loc31_:b2Vec2 = _loc6_[_loc25_];
         var _loc33_:b2Vec2 = _loc6_[_loc23_];
         if(_loc13_ < Number.MIN_VALUE)
         {
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.SetV(_loc32_[_loc17_]);
            param1.m_localPoint.x = 0.5 * (_loc31_.x + _loc33_.x);
            param1.m_localPoint.y = 0.5 * (_loc31_.y + _loc33_.y);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
            return;
         }
         var _loc16_:Number = (_loc11_ - _loc31_.x) * (_loc33_.x - _loc31_.x) + (_loc10_ - _loc31_.y) * (_loc33_.y - _loc31_.y);
         var _loc18_:Number = (_loc11_ - _loc33_.x) * (_loc31_.x - _loc33_.x) + (_loc10_ - _loc33_.y) * (_loc31_.y - _loc33_.y);
         if(_loc16_ <= 0)
         {
            if((_loc11_ - _loc31_.x) * (_loc11_ - _loc31_.x) + (_loc10_ - _loc31_.y) * (_loc10_ - _loc31_.y) > _loc15_ * _loc15_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc11_ - _loc31_.x;
            param1.m_localPlaneNormal.y = _loc10_ - _loc31_.y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.SetV(_loc31_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
         else if(_loc18_ <= 0)
         {
            if((_loc11_ - _loc33_.x) * (_loc11_ - _loc33_.x) + (_loc10_ - _loc33_.y) * (_loc10_ - _loc33_.y) > _loc15_ * _loc15_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc11_ - _loc33_.x;
            param1.m_localPlaneNormal.y = _loc10_ - _loc33_.y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.SetV(_loc33_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
         else
         {
            _loc19_ = 0.5 * (_loc31_.x + _loc33_.x);
            _loc20_ = 0.5 * (_loc31_.y + _loc33_.y);
            _loc13_ = (_loc11_ - _loc19_) * _loc32_[_loc25_].x + (_loc10_ - _loc20_) * _loc32_[_loc25_].y;
            if(_loc13_ > _loc15_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc32_[_loc25_].x;
            param1.m_localPlaneNormal.y = _loc32_[_loc25_].y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.Set(_loc19_,_loc20_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
      }
      
      public static function TestOverlap(param1:b2AABB, param2:b2AABB) : Boolean
      {
         var _loc6_:b2Vec2 = param2.lowerBound;
         var _loc8_:b2Vec2 = param1.upperBound;
         var _loc3_:Number = _loc6_.x - _loc8_.x;
         var _loc7_:Number = _loc6_.y - _loc8_.y;
         _loc6_ = param1.lowerBound;
         _loc8_ = param2.upperBound;
         var _loc5_:Number = _loc6_.x - _loc8_.x;
         var _loc4_:Number = _loc6_.y - _loc8_.y;
         if(_loc3_ > 0 || _loc7_ > 0)
         {
            return false;
         }
         if(_loc5_ > 0 || _loc4_ > 0)
         {
            return false;
         }
         return true;
      }
   }
}
