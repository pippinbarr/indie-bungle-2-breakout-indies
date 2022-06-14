package Box2D.Dynamics
{
   import flash.display.Sprite;
   import Box2D.Common.b2internal;
   import Box2D.Common.b2Color;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Transform;
   
   use namespace b2internal;
   
   public class b2DebugDraw
   {
      
      public static var e_shapeBit:uint = 1;
      
      public static var e_jointBit:uint = 2;
      
      public static var e_aabbBit:uint = 4;
      
      public static var e_pairBit:uint = 8;
      
      public static var e_centerOfMassBit:uint = 16;
      
      public static var e_controllerBit:uint = 32;
       
      private var m_drawFlags:uint;
      
      b2internal var m_sprite:Sprite;
      
      private var m_drawScale:Number = 1.0;
      
      private var m_lineThickness:Number = 1.0;
      
      private var m_alpha:Number = 1.0;
      
      private var m_fillAlpha:Number = 1.0;
      
      private var m_xformScale:Number = 1.0;
      
      public function b2DebugDraw()
      {
         super();
         m_drawFlags = 0;
      }
      
      public function SetFlags(param1:uint) : void
      {
         m_drawFlags = param1;
      }
      
      public function GetFlags() : uint
      {
         return m_drawFlags;
      }
      
      public function AppendFlags(param1:uint) : void
      {
         m_drawFlags = §§dup().m_drawFlags | param1;
      }
      
      public function ClearFlags(param1:uint) : void
      {
         m_drawFlags = §§dup().m_drawFlags & ~param1;
      }
      
      public function SetSprite(param1:Sprite) : void
      {
         m_sprite = param1;
      }
      
      public function GetSprite() : Sprite
      {
         return m_sprite;
      }
      
      public function SetDrawScale(param1:Number) : void
      {
         m_drawScale = param1;
      }
      
      public function GetDrawScale() : Number
      {
         return m_drawScale;
      }
      
      public function SetLineThickness(param1:Number) : void
      {
         m_lineThickness = param1;
      }
      
      public function GetLineThickness() : Number
      {
         return m_lineThickness;
      }
      
      public function SetAlpha(param1:Number) : void
      {
         m_alpha = param1;
      }
      
      public function GetAlpha() : Number
      {
         return m_alpha;
      }
      
      public function SetFillAlpha(param1:Number) : void
      {
         m_fillAlpha = param1;
      }
      
      public function GetFillAlpha() : Number
      {
         return m_fillAlpha;
      }
      
      public function SetXFormScale(param1:Number) : void
      {
         m_xformScale = param1;
      }
      
      public function GetXFormScale() : Number
      {
         return m_xformScale;
      }
      
      public function DrawPolygon(param1:Array, param2:int, param3:b2Color) : void
      {
         var _loc4_:* = 0;
         m_sprite.graphics.lineStyle(m_lineThickness,param3.color,m_alpha);
         m_sprite.graphics.moveTo(param1[0].x * m_drawScale,param1[0].y * m_drawScale);
         _loc4_ = 1;
         while(_loc4_ < param2)
         {
            m_sprite.graphics.lineTo(param1[_loc4_].x * m_drawScale,param1[_loc4_].y * m_drawScale);
            _loc4_++;
         }
         m_sprite.graphics.lineTo(param1[0].x * m_drawScale,param1[0].y * m_drawScale);
      }
      
      public function DrawSolidPolygon(param1:Vector.<b2Vec2>, param2:int, param3:b2Color) : void
      {
         var _loc4_:* = 0;
         m_sprite.graphics.lineStyle(m_lineThickness,param3.color,m_alpha);
         m_sprite.graphics.moveTo(param1[0].x * m_drawScale,param1[0].y * m_drawScale);
         m_sprite.graphics.beginFill(param3.color,m_fillAlpha);
         _loc4_ = 1;
         while(_loc4_ < param2)
         {
            m_sprite.graphics.lineTo(param1[_loc4_].x * m_drawScale,param1[_loc4_].y * m_drawScale);
            _loc4_++;
         }
         m_sprite.graphics.lineTo(param1[0].x * m_drawScale,param1[0].y * m_drawScale);
         m_sprite.graphics.endFill();
      }
      
      public function DrawCircle(param1:b2Vec2, param2:Number, param3:b2Color) : void
      {
         m_sprite.graphics.lineStyle(m_lineThickness,param3.color,m_alpha);
         m_sprite.graphics.drawCircle(param1.x * m_drawScale,param1.y * m_drawScale,param2 * m_drawScale);
      }
      
      public function DrawSolidCircle(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:b2Color) : void
      {
         m_sprite.graphics.lineStyle(m_lineThickness,param4.color,m_alpha);
         m_sprite.graphics.moveTo(0,0);
         m_sprite.graphics.beginFill(param4.color,m_fillAlpha);
         m_sprite.graphics.drawCircle(param1.x * m_drawScale,param1.y * m_drawScale,param2 * m_drawScale);
         m_sprite.graphics.endFill();
         m_sprite.graphics.moveTo(param1.x * m_drawScale,param1.y * m_drawScale);
         m_sprite.graphics.lineTo((param1.x + param3.x * param2) * m_drawScale,(param1.y + param3.y * param2) * m_drawScale);
      }
      
      public function DrawSegment(param1:b2Vec2, param2:b2Vec2, param3:b2Color) : void
      {
         m_sprite.graphics.lineStyle(m_lineThickness,param3.color,m_alpha);
         m_sprite.graphics.moveTo(param1.x * m_drawScale,param1.y * m_drawScale);
         m_sprite.graphics.lineTo(param2.x * m_drawScale,param2.y * m_drawScale);
      }
      
      public function DrawTransform(param1:b2Transform) : void
      {
         m_sprite.graphics.lineStyle(m_lineThickness,16711680,m_alpha);
         m_sprite.graphics.moveTo(param1.position.x * m_drawScale,param1.position.y * m_drawScale);
         m_sprite.graphics.lineTo((param1.position.x + m_xformScale * param1.R.col1.x) * m_drawScale,(param1.position.y + m_xformScale * param1.R.col1.y) * m_drawScale);
         m_sprite.graphics.lineStyle(m_lineThickness,65280,m_alpha);
         m_sprite.graphics.moveTo(param1.position.x * m_drawScale,param1.position.y * m_drawScale);
         m_sprite.graphics.lineTo((param1.position.x + m_xformScale * param1.R.col2.x) * m_drawScale,(param1.position.y + m_xformScale * param1.R.col2.y) * m_drawScale);
      }
   }
}
