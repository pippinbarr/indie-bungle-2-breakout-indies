package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Math;
   
   public class b2DynamicTree
   {
       
      private var m_root:Box2D.Collision.b2DynamicTreeNode;
      
      private var m_freeList:Box2D.Collision.b2DynamicTreeNode;
      
      private var m_path:uint;
      
      private var m_insertionCount:int;
      
      public function b2DynamicTree()
      {
         super();
         m_root = null;
         m_freeList = null;
         m_path = 0;
         m_insertionCount = 0;
      }
      
      public function CreateProxy(param1:b2AABB, param2:*) : Box2D.Collision.b2DynamicTreeNode
      {
         var _loc3_:Box2D.Collision.b2DynamicTreeNode = AllocateNode();
         var _loc5_:* = 0.1;
         var _loc4_:* = 0.1;
         _loc3_.aabb.lowerBound.x = param1.lowerBound.x - _loc5_;
         _loc3_.aabb.lowerBound.y = param1.lowerBound.y - _loc4_;
         _loc3_.aabb.upperBound.x = param1.upperBound.x + _loc5_;
         _loc3_.aabb.upperBound.y = param1.upperBound.y + _loc4_;
         _loc3_.userData = param2;
         InsertLeaf(_loc3_);
         return _loc3_;
      }
      
      public function DestroyProxy(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         RemoveLeaf(param1);
         FreeNode(param1);
      }
      
      public function MoveProxy(param1:Box2D.Collision.b2DynamicTreeNode, param2:b2AABB, param3:b2Vec2) : Boolean
      {
         b2Settings.b2Assert(param1.IsLeaf());
         if(param1.aabb.Contains(param2))
         {
            return false;
         }
         RemoveLeaf(param1);
         var _loc5_:Number = 0.1 + 2 * (param3.x > 0?param3.x:-param3.x);
         var _loc4_:Number = 0.1 + 2 * (param3.y > 0?param3.y:-param3.y);
         param1.aabb.lowerBound.x = param2.lowerBound.x - _loc5_;
         param1.aabb.lowerBound.y = param2.lowerBound.y - _loc4_;
         param1.aabb.upperBound.x = param2.upperBound.x + _loc5_;
         param1.aabb.upperBound.y = param2.upperBound.y + _loc4_;
         InsertLeaf(param1);
         return true;
      }
      
      public function Rebalance(param1:int) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = 0;
         if(m_root == null)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = m_root;
            _loc4_ = 0;
            while(_loc2_.IsLeaf() == false)
            {
               _loc2_ = m_path >> _loc4_ & 1?_loc2_.child2:_loc2_.child1;
               _loc4_ = _loc4_ + 1 & 31;
            }
            m_path = m_path + 1;
            RemoveLeaf(_loc2_);
            InsertLeaf(_loc2_);
            _loc3_++;
         }
      }
      
      public function GetFatAABB(param1:Box2D.Collision.b2DynamicTreeNode) : b2AABB
      {
         return param1.aabb;
      }
      
      public function GetUserData(param1:Box2D.Collision.b2DynamicTreeNode) : *
      {
         return param1.userData;
      }
      
      public function Query(param1:Function, param2:b2AABB) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = false;
         if(m_root == null)
         {
            return;
         }
         var _loc4_:Vector.<Box2D.Collision.b2DynamicTreeNode> = new Vector.<Box2D.Collision.b2DynamicTreeNode>();
         var _loc6_:* = 0;
         _loc6_++;
         _loc4_[_loc6_] = m_root;
         while(_loc6_ > 0)
         {
            _loc6_--;
            _loc3_ = _loc4_[_loc6_];
            if(_loc3_.aabb.TestOverlap(param2))
            {
               if(_loc3_.IsLeaf())
               {
                  _loc5_ = param1(_loc3_);
                  if(!_loc5_)
                  {
                     return;
                  }
               }
               else
               {
                  _loc6_++;
                  _loc4_[_loc6_] = _loc3_.child1;
                  _loc6_++;
                  _loc4_[_loc6_] = _loc3_.child2;
               }
            }
         }
      }
      
      public function RayCast(param1:Function, param2:b2RayCastInput) : void
      {
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc12_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = null;
         var _loc14_:* = NaN;
         var _loc18_:* = null;
         if(m_root == null)
         {
            return;
         }
         var _loc3_:b2Vec2 = param2.p1;
         var _loc4_:b2Vec2 = param2.p2;
         var _loc13_:b2Vec2 = b2Math.SubtractVV(_loc3_,_loc4_);
         _loc13_.Normalize();
         var _loc15_:b2Vec2 = b2Math.CrossFV(1,_loc13_);
         var _loc11_:b2Vec2 = b2Math.AbsV(_loc15_);
         var _loc16_:Number = param2.maxFraction;
         var _loc17_:b2AABB = new b2AABB();
         _loc7_ = _loc3_.x + _loc16_ * (_loc4_.x - _loc3_.x);
         _loc8_ = _loc3_.y + _loc16_ * (_loc4_.y - _loc3_.y);
         _loc17_.lowerBound.x = Math.min(_loc3_.x,_loc7_);
         _loc17_.lowerBound.y = Math.min(_loc3_.y,_loc8_);
         _loc17_.upperBound.x = Math.max(_loc3_.x,_loc7_);
         _loc17_.upperBound.y = Math.max(_loc3_.y,_loc8_);
         var _loc5_:Vector.<Box2D.Collision.b2DynamicTreeNode> = new Vector.<Box2D.Collision.b2DynamicTreeNode>();
         var _loc9_:* = 0;
         _loc9_++;
         _loc5_[_loc9_] = m_root;
         while(_loc9_ > 0)
         {
            _loc9_--;
            _loc12_ = _loc5_[_loc9_];
            if(_loc12_.aabb.TestOverlap(_loc17_) != false)
            {
               _loc6_ = _loc12_.aabb.GetCenter();
               _loc10_ = _loc12_.aabb.GetExtents();
               _loc14_ = Math.abs(_loc15_.x * (_loc3_.x - _loc6_.x) + _loc15_.y * (_loc3_.y - _loc6_.y)) - _loc11_.x * _loc10_.x - _loc11_.y * _loc10_.y;
               if(_loc14_ <= 0)
               {
                  if(_loc12_.IsLeaf())
                  {
                     _loc18_ = new b2RayCastInput();
                     _loc18_.p1 = param2.p1;
                     _loc18_.p2 = param2.p2;
                     _loc18_.maxFraction = param2.maxFraction;
                     _loc16_ = param1(_loc18_,_loc12_);
                     if(_loc16_ == 0)
                     {
                        return;
                     }
                     _loc7_ = _loc3_.x + _loc16_ * (_loc4_.x - _loc3_.x);
                     _loc8_ = _loc3_.y + _loc16_ * (_loc4_.y - _loc3_.y);
                     _loc17_.lowerBound.x = Math.min(_loc3_.x,_loc7_);
                     _loc17_.lowerBound.y = Math.min(_loc3_.y,_loc8_);
                     _loc17_.upperBound.x = Math.max(_loc3_.x,_loc7_);
                     _loc17_.upperBound.y = Math.max(_loc3_.y,_loc8_);
                  }
                  else
                  {
                     _loc9_++;
                     _loc5_[_loc9_] = _loc12_.child1;
                     _loc9_++;
                     _loc5_[_loc9_] = _loc12_.child2;
                  }
               }
            }
         }
      }
      
      private function AllocateNode() : Box2D.Collision.b2DynamicTreeNode
      {
         var _loc1_:* = null;
         if(m_freeList)
         {
            _loc1_ = m_freeList;
            m_freeList = _loc1_.parent;
            _loc1_.parent = null;
            _loc1_.child1 = null;
            _loc1_.child2 = null;
            return _loc1_;
         }
         return new Box2D.Collision.b2DynamicTreeNode();
      }
      
      private function FreeNode(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         param1.parent = m_freeList;
         m_freeList = param1;
      }
      
      private function InsertLeaf(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         var _loc9_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = NaN;
         var _loc4_:* = NaN;
         m_insertionCount = m_insertionCount + 1;
         if(m_root == null)
         {
            m_root = param1;
            m_root.parent = null;
            return;
         }
         var _loc5_:b2Vec2 = param1.aabb.GetCenter();
         var _loc3_:Box2D.Collision.b2DynamicTreeNode = m_root;
         if(_loc3_.IsLeaf() == false)
         {
            do
            {
               _loc9_ = _loc3_.child1;
               _loc7_ = _loc3_.child2;
               _loc6_ = Math.abs((_loc9_.aabb.lowerBound.x + _loc9_.aabb.upperBound.x) / 2 - _loc5_.x) + Math.abs((_loc9_.aabb.lowerBound.y + _loc9_.aabb.upperBound.y) / 2 - _loc5_.y);
               _loc4_ = Math.abs((_loc7_.aabb.lowerBound.x + _loc7_.aabb.upperBound.x) / 2 - _loc5_.x) + Math.abs((_loc7_.aabb.lowerBound.y + _loc7_.aabb.upperBound.y) / 2 - _loc5_.y);
               if(_loc6_ < _loc4_)
               {
                  _loc3_ = _loc9_;
               }
               else
               {
                  _loc3_ = _loc7_;
               }
            }
            while(_loc3_.IsLeaf() == false);
            
         }
         var _loc8_:Box2D.Collision.b2DynamicTreeNode = _loc3_.parent;
         var _loc2_:Box2D.Collision.b2DynamicTreeNode = AllocateNode();
         _loc2_.parent = _loc8_;
         _loc2_.userData = null;
         _loc2_.aabb.Combine(param1.aabb,_loc3_.aabb);
         if(_loc8_)
         {
            if(_loc3_.parent.child1 == _loc3_)
            {
               _loc8_.child1 = _loc2_;
            }
            else
            {
               _loc8_.child2 = _loc2_;
            }
            _loc2_.child1 = _loc3_;
            _loc2_.child2 = param1;
            _loc3_.parent = _loc2_;
            param1.parent = _loc2_;
            while(!_loc8_.aabb.Contains(_loc2_.aabb))
            {
               _loc8_.aabb.Combine(_loc8_.child1.aabb,_loc8_.child2.aabb);
               _loc2_ = _loc8_;
               _loc8_ = _loc8_.parent;
               if(!_loc8_)
               {
                  break;
               }
            }
         }
         else
         {
            _loc2_.child1 = _loc3_;
            _loc2_.child2 = param1;
            _loc3_.parent = _loc2_;
            param1.parent = _loc2_;
            m_root = _loc2_;
         }
      }
      
      private function RemoveLeaf(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param1 == m_root)
         {
            m_root = null;
            return;
         }
         var _loc2_:Box2D.Collision.b2DynamicTreeNode = param1.parent;
         var _loc5_:Box2D.Collision.b2DynamicTreeNode = _loc2_.parent;
         if(_loc2_.child1 == param1)
         {
            _loc3_ = _loc2_.child2;
         }
         else
         {
            _loc3_ = _loc2_.child1;
         }
         if(_loc5_)
         {
            if(_loc5_.child1 == _loc2_)
            {
               _loc5_.child1 = _loc3_;
            }
            else
            {
               _loc5_.child2 = _loc3_;
            }
            _loc3_.parent = _loc5_;
            FreeNode(_loc2_);
            while(_loc5_)
            {
               _loc4_ = _loc5_.aabb;
               _loc5_.aabb = b2AABB.Combine(_loc5_.child1.aabb,_loc5_.child2.aabb);
               if(!_loc4_.Contains(_loc5_.aabb))
               {
                  _loc5_ = _loc5_.parent;
                  continue;
               }
               break;
            }
         }
         else
         {
            m_root = _loc3_;
            _loc3_.parent = null;
            FreeNode(_loc2_);
         }
      }
   }
}
