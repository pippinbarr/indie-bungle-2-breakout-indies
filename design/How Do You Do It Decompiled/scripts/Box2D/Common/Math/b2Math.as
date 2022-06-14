package Box2D.Common.Math
{
   public class b2Math
   {
      
      public static const b2Vec2_zero:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(0,0);
      
      public static const b2Mat22_identity:Box2D.Common.Math.b2Mat22 = Box2D.Common.Math.b2Mat22.FromVV(new Box2D.Common.Math.b2Vec2(1,0),new Box2D.Common.Math.b2Vec2(0,1));
      
      public static const b2Transform_identity:Box2D.Common.Math.b2Transform = new Box2D.Common.Math.b2Transform(b2Vec2_zero,b2Mat22_identity);
       
      public function b2Math()
      {
         super();
      }
      
      public static function IsValid(param1:Number) : Boolean
      {
         return isFinite(param1);
      }
      
      public static function Dot(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function CrossVV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function CrossVF(param1:Box2D.Common.Math.b2Vec2, param2:Number) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(param2 * param1.y,-param2 * param1.x);
         return _loc3_;
      }
      
      public static function CrossFV(param1:Number, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(-param1 * param2.y,param1 * param2.x);
         return _loc3_;
      }
      
      public static function MulMV(param1:Box2D.Common.Math.b2Mat22, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(param1.col1.x * param2.x + param1.col2.x * param2.y,param1.col1.y * param2.x + param1.col2.y * param2.y);
         return _loc3_;
      }
      
      public static function MulTMV(param1:Box2D.Common.Math.b2Mat22, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Dot(param2,param1.col1),Dot(param2,param1.col2));
         return _loc3_;
      }
      
      public static function MulX(param1:Box2D.Common.Math.b2Transform, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = MulMV(param1.R,param2);
         _loc3_.x = _loc3_.x + param1.position.x;
         _loc3_.y = _loc3_.y + param1.position.y;
         return _loc3_;
      }
      
      public static function MulXT(param1:Box2D.Common.Math.b2Transform, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = SubtractVV(param2,param1.position);
         var _loc4_:Number = _loc3_.x * param1.R.col1.x + _loc3_.y * param1.R.col1.y;
         _loc3_.y = _loc3_.x * param1.R.col2.x + _loc3_.y * param1.R.col2.y;
         _loc3_.x = _loc4_;
         return _loc3_;
      }
      
      public static function AddVV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(param1.x + param2.x,param1.y + param2.y);
         return _loc3_;
      }
      
      public static function SubtractVV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(param1.x - param2.x,param1.y - param2.y);
         return _loc3_;
      }
      
      public static function Distance(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public static function DistanceSquared(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      public static function MulFV(param1:Number, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(param1 * param2.x,param1 * param2.y);
         return _loc3_;
      }
      
      public static function AddMM(param1:Box2D.Common.Math.b2Mat22, param2:Box2D.Common.Math.b2Mat22) : Box2D.Common.Math.b2Mat22
      {
         var _loc3_:Box2D.Common.Math.b2Mat22 = Box2D.Common.Math.b2Mat22.FromVV(AddVV(param1.col1,param2.col1),AddVV(param1.col2,param2.col2));
         return _loc3_;
      }
      
      public static function MulMM(param1:Box2D.Common.Math.b2Mat22, param2:Box2D.Common.Math.b2Mat22) : Box2D.Common.Math.b2Mat22
      {
         var _loc3_:Box2D.Common.Math.b2Mat22 = Box2D.Common.Math.b2Mat22.FromVV(MulMV(param1,param2.col1),MulMV(param1,param2.col2));
         return _loc3_;
      }
      
      public static function MulTMM(param1:Box2D.Common.Math.b2Mat22, param2:Box2D.Common.Math.b2Mat22) : Box2D.Common.Math.b2Mat22
      {
         var _loc4_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Dot(param1.col1,param2.col1),Dot(param1.col2,param2.col1));
         var _loc5_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Dot(param1.col1,param2.col2),Dot(param1.col2,param2.col2));
         var _loc3_:Box2D.Common.Math.b2Mat22 = Box2D.Common.Math.b2Mat22.FromVV(_loc4_,_loc5_);
         return _loc3_;
      }
      
      public static function Abs(param1:Number) : Number
      {
         return param1 > 0?param1:-param1;
      }
      
      public static function AbsV(param1:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc2_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Abs(param1.x),Abs(param1.y));
         return _loc2_;
      }
      
      public static function AbsM(param1:Box2D.Common.Math.b2Mat22) : Box2D.Common.Math.b2Mat22
      {
         var _loc2_:Box2D.Common.Math.b2Mat22 = Box2D.Common.Math.b2Mat22.FromVV(AbsV(param1.col1),AbsV(param1.col2));
         return _loc2_;
      }
      
      public static function Min(param1:Number, param2:Number) : Number
      {
         return param1 < param2?param1:param2;
      }
      
      public static function MinV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Min(param1.x,param2.x),Min(param1.y,param2.y));
         return _loc3_;
      }
      
      public static function Max(param1:Number, param2:Number) : Number
      {
         return param1 > param2?param1:param2;
      }
      
      public static function MaxV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         var _loc3_:Box2D.Common.Math.b2Vec2 = new Box2D.Common.Math.b2Vec2(Max(param1.x,param2.x),Max(param1.y,param2.y));
         return _loc3_;
      }
      
      public static function Clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 < param2?param2:param1 > param3?param3:param1;
      }
      
      public static function ClampV(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Vec2, param3:Box2D.Common.Math.b2Vec2) : Box2D.Common.Math.b2Vec2
      {
         return MaxV(param2,MinV(param1,param3));
      }
      
      public static function Swap(param1:Array, param2:Array) : void
      {
         var _loc3_:* = param1[0];
         param1[0] = param2[0];
         param2[0] = _loc3_;
      }
      
      public static function Random() : Number
      {
         return Math.random() * 2 - 1;
      }
      
      public static function RandomRange(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.random();
         _loc3_ = (param2 - param1) * _loc3_ + param1;
         return _loc3_;
      }
      
      public static function NextPowerOfTwo(param1:uint) : uint
      {
         var param1:uint = param1 | param1 >> 1 & 2147483647;
         param1 = param1 | param1 >> 2 & 1073741823;
         param1 = param1 | param1 >> 4 & 268435455;
         param1 = param1 | param1 >> 8 & 16777215;
         param1 = param1 | param1 >> 16 & 65535;
         return param1 + 1;
      }
      
      public static function IsPowerOfTwo(param1:uint) : Boolean
      {
         var _loc2_:Boolean = param1 > 0 && (param1 & param1 - 1) == 0;
         return _loc2_;
      }
   }
}
