package
{
   import org.flixel.FlxSprite;
   import org.flixel.FlxPoint;
   import org.flixel.FlxText;
   import org.flixel.FlxG;
   
   public class Arm
   {
       
      private var ImgForearm:Class;
      
      private var ImgHandL:Class;
      
      private var ImgHandR:Class;
      
      private var ImgFingersL:Class;
      
      private var ImgFingersR:Class;
      
      public var m_physScale:Number = 30;
      
      public var forearm:FlxSprite;
      
      public var hand:FlxSprite;
      
      public var fingers:FlxSprite;
      
      public var heldDoll:DollGrabber;
      
      public var armBase:FlxPoint;
      
      public var debugText:FlxText;
      
      public function Arm(param1:Number, param2:DollGrabber, param3:Boolean = false)
      {
         ImgForearm = §girl_forearm_png$63b65a6c2fd59420aa3d51bcbd038587-138270559§;
         ImgHandL = §girl_handL_png$a40ebefa2778efd7f8586c5d2cb4de62-2128717626§;
         ImgHandR = §girl_handR_png$642491c001ddcfb81e795aa4eae0061b-2136265252§;
         ImgFingersL = §girl_fingersL_png$af042f95cecd9254adbbaea33a776872-1765204473§;
         ImgFingersR = §girl_fingersR_png$7e0fde500b1ab20f5ad4eb35f24947ff-1771707619§;
         super();
         debugText = new FlxText(0,30,FlxG.width,"");
         if(param3)
         {
            FlxG.state.add(debugText);
         }
         this.heldDoll = param2;
         forearm = new FlxSprite(param1,180);
         forearm.loadGraphic(ImgForearm,true,true,81,524,true);
         FlxG.state.add(forearm);
         hand = new FlxSprite(param1,120);
         if(param3)
         {
            hand.loadGraphic(ImgHandL,true,true,88,89,true);
         }
         else
         {
            hand.loadGraphic(ImgHandR,true,true,88,89,true);
         }
         FlxG.state.add(hand);
         fingers = new FlxSprite(param1,120);
         if(param3)
         {
            fingers.loadGraphic(ImgFingersL,true,true,88,89,true);
         }
         else
         {
            fingers.loadGraphic(ImgFingersR,true,true,88,89,true);
         }
         FlxG.state.add(fingers);
         this.armBase = new FlxPoint(forearm.x + forearm.width / 2,forearm.y + forearm.height / 2);
      }
      
      public function turn(param1:Boolean) : void
      {
         var _loc2_:* = 10.0;
         if(param1)
         {
            hand.angle = _loc2_;
            fingers.angle = _loc2_;
         }
         else
         {
            hand.angle = -_loc2_;
            fingers.angle = -_loc2_;
         }
      }
      
      public function stopTurning() : void
      {
         hand.angle = 0;
         fingers.angle = 0;
      }
      
      public function update() : void
      {
         var _loc1_:FlxPoint = this.armBase;
         var _loc2_:FlxPoint = new FlxPoint(this.heldDoll.pos.x * m_physScale / 2,this.heldDoll.pos.y * m_physScale / 2);
         var _loc5_:Number = _loc2_.y - _loc1_.y;
         var _loc4_:Number = _loc2_.x - _loc1_.x;
         var _loc6_:Number = Math.atan2(_loc5_,_loc4_);
         var _loc3_:Number = _loc6_ * 180 / 3.141592653589793;
         forearm.angle = _loc3_ + 90;
         hand.x = this.heldDoll.pos.x * m_physScale / 2 - hand.width / 2;
         hand.y = this.heldDoll.pos.y * m_physScale / 2 - hand.height / 2;
         fingers.x = this.heldDoll.pos.x * m_physScale / 2 - fingers.width / 2;
         fingers.y = this.heldDoll.pos.y * m_physScale / 2 - fingers.height / 2;
         forearm.y = this.heldDoll.pos.y * m_physScale / 2;
      }
   }
}
