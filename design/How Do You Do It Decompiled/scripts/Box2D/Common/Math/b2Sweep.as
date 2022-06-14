package Box2D.Common.Math
{
   public class b2Sweep
   {
       
      public var localCenter:Box2D.Common.Math.b2Vec2;
      
      public var c0:Box2D.Common.Math.b2Vec2;
      
      public var c:Box2D.Common.Math.b2Vec2;
      
      public var a0:Number;
      
      public var a:Number;
      
      public var t0:Number;
      
      public function b2Sweep()
      {
         localCenter = new Box2D.Common.Math.b2Vec2();
         c0 = new Box2D.Common.Math.b2Vec2();
         c = new Box2D.Common.Math.b2Vec2();
         super();
      }
      
      public function Set(param1:b2Sweep) : void
      {
         localCenter.SetV(param1.localCenter);
         c0.SetV(param1.c0);
         c.SetV(param1.c);
         a0 = param1.a0;
         a = param1.a;
         t0 = param1.t0;
      }
      
      public function Copy() : b2Sweep
      {
         var _loc1_:b2Sweep = new b2Sweep();
         _loc1_.localCenter.SetV(localCenter);
         _loc1_.c0.SetV(c0);
         _loc1_.c.SetV(c);
         _loc1_.a0 = a0;
         _loc1_.a = a;
         _loc1_.t0 = t0;
         return _loc1_;
      }
      
      public function GetTransform(param1:b2Transform, param2:Number) : void
      {
         param1.position.x = (1 - param2) * c0.x + param2 * c.x;
         param1.position.y = (1 - param2) * c0.y + param2 * c.y;
         var _loc3_:Number = (1 - param2) * a0 + param2 * a;
         param1.R.Set(_loc3_);
         var _loc4_:b2Mat22 = param1.R;
         param1.position.x = param1.position.x - (_loc4_.col1.x * localCenter.x + _loc4_.col2.x * localCenter.y);
         param1.position.y = param1.position.y - (_loc4_.col1.y * localCenter.x + _loc4_.col2.y * localCenter.y);
      }
      
      public function Advance(param1:Number) : void
      {
         var _loc2_:* = NaN;
         if(t0 < param1 && 1 - t0 > Number.MIN_VALUE)
         {
            _loc2_ = (param1 - t0) / (1 - t0);
            c0.x = (1 - _loc2_) * c0.x + _loc2_ * c.x;
            c0.y = (1 - _loc2_) * c0.y + _loc2_ * c.y;
            a0 = (1 - _loc2_) * a0 + _loc2_ * a;
            t0 = param1;
         }
      }
   }
}
