package
{
   import org.flixel.FlxText;
   import org.flixel.FlxSprite;
   import org.flixel.FlxG;
   
   public class ScrollingText extends FlxText
   {
       
      private var bubble:Class;
      
      public var FontPix:String;
      
      public var thoughts:Array;
      
      public var thought_bubble:String = "";
      
      public var bubble_width:Number;
      
      public var pos_x:Number;
      
      public var pos_y:Number = 15;
      
      public var counter:Number = 0;
      
      public var frame_counter:Number = 0;
      
      public var paused:Boolean = true;
      
      public var thought_img:FlxSprite;
      
      public var c1:Number = 0;
      
      public function ScrollingText()
      {
         bubble = thoughts_png$6c3ba8c96e9da2380e1a0618f3c270a32147265702;
         FontPix = "Minecraftia2_ttf$49c00ae56efd9e4c195f97daaf6bb683488872850";
         thoughts = new Array("...she\'s gone.","Rose... Jack...","Why was it so cloudy in there?","In the car on the Titanic...","Clouds don\'t go in cars...","They were hugging all like...","I don\'t hug mommy like that.","I hope she doesn\'t see this...","Don\'t... people usually stand and hug?","What kind of a hug is a hug on the floor?","Like this...?","How many hugs are there?","There\'s a lot about hugging I don\'t know.","I hope she doesn\'t see this...","They kissed too...","Kissing seems nice.","Mimi said that grown-ups have sex and...","Maybe sex is lot of kissing and hugging.","Mom doesn\'t like that word...","Why doesn\'t she like it?","I hope she doesn\'t see this...","Why doesn\'t she like... sex?","I wish I knew what sex was.");
         bubble_width = FlxG.width / 2;
         pos_x = FlxG.width - 105;
         super(pos_x,pos_y,90,thoughts[counter]);
         this.setFormat("Minecraftia-Regular",8,4.27819008E9,"left");
         thought_img = new FlxSprite(178,3);
         thought_img.loadGraphic(bubble,true,true,140,114,true);
         thought_img.addAnimation("mid",[1],12,false);
         thought_img.addAnimation("small",[2],12,false);
         FlxG.state.add(thought_img);
         thought_img.play("mid");
         this.color = 4.28937489E9;
      }
      
      override public function update() : void
      {
         super.update();
         frame_counter = frame_counter + 1;
         c1 = c1 + 1;
         if(c1 > 200)
         {
            thought_img.play("mid");
         }
         if(c1 > 300)
         {
            thought_img.play("small");
         }
         if(c1 > 400)
         {
            thought_img.play("mid");
            c1 = 0;
         }
         if(frame_counter % 150 == 0 && !paused)
         {
            counter = counter + 1;
            if(counter >= thoughts.length)
            {
               counter = 0;
            }
            this.text = thoughts[counter];
         }
      }
   }
}
