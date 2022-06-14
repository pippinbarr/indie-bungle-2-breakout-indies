package
{
   import org.flixel.FlxSprite;
   import org.flixel.FlxG;
   
   public class Face extends FlxSprite
   {
       
      private var ImgFace:Class;
      
      private var ImgBlush:Class;
      
      public var blush:FlxSprite;
      
      public function Face(param1:Number, param2:Number)
      {
         ImgFace = faces_strip_png$795a1ea2cdcab0ac0b72b5a5e3af87c21062894329;
         ImgBlush = blush_png$d54fdb292d8c6e2b99bc5f1afceb5fe01775837034;
         super(param1,param2);
         loadGraphic(ImgFace,true,true,205,202,true);
         addAnimation("neutral",[0],1,false);
         addAnimation("blink",[2,3,2,0],12,false);
         addAnimation("lookaside",[1,0],2,false);
         addAnimation("excited",[4]);
         addAnimation("disgusted",[5]);
         addAnimation("confused",[6]);
         addAnimation("surprised",[7]);
         play("neutral");
         FlxG.state.add(this);
         blush = new FlxSprite(param1,param2);
         blush.loadGraphic(ImgBlush,true,true,205,202,true);
         FlxG.state.add(blush);
         blush.alpha = 0;
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:Number = FlxG.random() * 400;
         if(_loc1_ < 1)
         {
            play("lookaside");
         }
         else if(_loc1_ < 2)
         {
            play("blink");
         }
         decreaseBlush();
      }
      
      public function increaseBlush() : void
      {
         if(blush.alpha < 1)
         {
            blush.alpha = blush.alpha + 0.2;
         }
      }
      
      public function decreaseBlush() : void
      {
         if(blush.alpha > 0)
         {
            blush.alpha = blush.alpha - 0.002;
         }
      }
   }
}
