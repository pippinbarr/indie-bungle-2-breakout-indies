package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Sweep;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Math;
   
   public class b2TimeOfImpact
   {
      
      private static var b2_toiCalls:int = 0;
      
      private static var b2_toiIters:int = 0;
      
      private static var b2_toiMaxIters:int = 0;
      
      private static var b2_toiRootIters:int = 0;
      
      private static var b2_toiMaxRootIters:int = 0;
      
      private static var s_cache:Box2D.Collision.b2SimplexCache = new Box2D.Collision.b2SimplexCache();
      
      private static var s_distanceInput:Box2D.Collision.b2DistanceInput = new Box2D.Collision.b2DistanceInput();
      
      private static var s_xfA:b2Transform = new b2Transform();
      
      private static var s_xfB:b2Transform = new b2Transform();
      
      private static var s_fcn:Box2D.Collision.b2SeparationFunction = new Box2D.Collision.b2SeparationFunction();
      
      private static var s_distanceOutput:Box2D.Collision.b2DistanceOutput = new Box2D.Collision.b2DistanceOutput();
       
      public function b2TimeOfImpact()
      {
         super();
      }
      
      public static function TimeOfImpact(param1:b2TOIInput) : Number
      {
         var _loc19_:* = 0;
         _loc19_ = 1000;
         var _loc13_:* = NaN;
         var _loc12_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:* = NaN;
         var _loc5_:* = NaN;
         var _loc8_:* = NaN;
         var _loc6_:* = 0;
         var _loc15_:* = NaN;
         var _loc2_:* = NaN;
         b2_toiCalls = b2_toiCalls + 1;
         var _loc4_:b2DistanceProxy = param1.proxyA;
         var _loc9_:b2DistanceProxy = param1.proxyB;
         var _loc7_:b2Sweep = param1.sweepA;
         var _loc10_:b2Sweep = param1.sweepB;
         b2Settings.b2Assert(_loc7_.t0 == _loc10_.t0);
         b2Settings.b2Assert(1 - _loc7_.t0 > Number.MIN_VALUE);
         var _loc18_:Number = _loc4_.m_radius + _loc9_.m_radius;
         var _loc20_:Number = param1.tolerance;
         var _loc14_:* = 0.0;
         var _loc3_:* = 0;
         var _loc11_:* = 0.0;
         s_cache.count = 0;
         s_distanceInput.useRadii = false;
         while(true)
         {
            _loc7_.GetTransform(s_xfA,_loc14_);
            _loc10_.GetTransform(s_xfB,_loc14_);
            s_distanceInput.proxyA = _loc4_;
            s_distanceInput.proxyB = _loc9_;
            s_distanceInput.transformA = s_xfA;
            s_distanceInput.transformB = s_xfB;
            b2Distance.Distance(s_distanceOutput,s_cache,s_distanceInput);
            if(s_distanceOutput.distance <= 0)
            {
               _loc14_ = 1.0;
               break;
            }
            s_fcn.Initialize(s_cache,_loc4_,s_xfA,_loc9_,s_xfB);
            _loc13_ = s_fcn.Evaluate(s_xfA,s_xfB);
            if(_loc13_ <= 0)
            {
               _loc14_ = 1.0;
               break;
            }
            if(_loc3_ == 0)
            {
               if(_loc13_ > _loc18_)
               {
                  _loc11_ = b2Math.Max(_loc18_ - _loc20_,0.75 * _loc18_);
               }
               else
               {
                  _loc11_ = b2Math.Max(_loc13_ - _loc20_,0.02 * _loc18_);
               }
            }
            if(_loc13_ - _loc11_ < 0.5 * _loc20_)
            {
               if(_loc3_ == 0)
               {
                  _loc14_ = 1.0;
                  break;
               }
               break;
            }
            _loc12_ = _loc14_;
            _loc16_ = _loc14_;
            _loc17_ = 1.0;
            _loc5_ = _loc13_;
            _loc7_.GetTransform(s_xfA,_loc17_);
            _loc10_.GetTransform(s_xfB,_loc17_);
            _loc8_ = s_fcn.Evaluate(s_xfA,s_xfB);
            if(_loc8_ >= _loc11_)
            {
               _loc14_ = 1.0;
               break;
            }
            _loc6_ = 0;
            while(true)
            {
               if(_loc6_ & 1)
               {
                  _loc15_ = _loc16_ + (_loc11_ - _loc5_) * (_loc17_ - _loc16_) / (_loc8_ - _loc5_);
               }
               else
               {
                  _loc15_ = 0.5 * (_loc16_ + _loc17_);
               }
               _loc7_.GetTransform(s_xfA,_loc15_);
               _loc10_.GetTransform(s_xfB,_loc15_);
               _loc2_ = s_fcn.Evaluate(s_xfA,s_xfB);
               if(b2Math.Abs(_loc2_ - _loc11_) < 0.025 * _loc20_)
               {
                  _loc12_ = _loc15_;
                  break;
               }
               if(_loc2_ > _loc11_)
               {
                  _loc16_ = _loc15_;
                  _loc5_ = _loc2_;
               }
               else
               {
                  _loc17_ = _loc15_;
                  _loc8_ = _loc2_;
               }
               _loc6_++;
               b2_toiRootIters = b2_toiRootIters + 1;
               if(_loc6_ != 50)
               {
                  continue;
               }
               break;
            }
            b2_toiMaxRootIters = b2Math.Max(b2_toiMaxRootIters,_loc6_);
            if(_loc12_ >= (1 + 100 * Number.MIN_VALUE) * _loc14_)
            {
               _loc14_ = _loc12_;
               _loc3_++;
               b2_toiIters = b2_toiIters + 1;
               if(_loc3_ != 1000)
               {
                  continue;
               }
               break;
            }
            break;
         }
         b2_toiMaxIters = b2Math.Max(b2_toiMaxIters,_loc3_);
         return _loc14_;
      }
   }
}
