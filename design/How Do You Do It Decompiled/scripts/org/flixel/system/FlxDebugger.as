package org.flixel.system
{
   import flash.display.Sprite;
   import org.flixel.system.debug.Perf;
   import org.flixel.system.debug.Log;
   import org.flixel.system.debug.Watch;
   import org.flixel.system.debug.VCR;
   import org.flixel.system.debug.Vis;
   import flash.geom.Point;
   import flash.events.MouseEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.flixel.FlxG;
   import flash.geom.Rectangle;
   
   public class FlxDebugger extends Sprite
   {
       
      public var perf:Perf;
      
      public var log:Log;
      
      public var watch:Watch;
      
      public var vcr:VCR;
      
      public var vis:Vis;
      
      public var hasMouse:Boolean;
      
      protected var _layout:uint;
      
      protected var _screen:Point;
      
      protected var _gutter:uint;
      
      public function FlxDebugger(param1:Number, param2:Number)
      {
         super();
         visible = false;
         hasMouse = false;
         _screen = new Point(param1,param2);
         addChild(new Bitmap(new BitmapData(param1,15,true,2130706432)));
         var _loc4_:TextField = new TextField();
         _loc4_.x = 2;
         _loc4_.width = 160;
         _loc4_.height = 16;
         _loc4_.selectable = false;
         _loc4_.multiline = false;
         _loc4_.defaultTextFormat = new TextFormat("Courier",12,16777215);
         var _loc3_:String = FlxG.getLibraryName();
         if(FlxG.debug)
         {
            _loc3_ = _loc3_ + " [debug]";
         }
         else
         {
            _loc3_ = _loc3_ + " [release]";
         }
         _loc4_.text = _loc3_;
         addChild(_loc4_);
         _gutter = 8;
         var _loc5_:Rectangle = new Rectangle(_gutter,15 + _gutter / 2,_screen.x - _gutter * 2,_screen.y - _gutter * 1.5 - 15);
         log = new Log("log",0,0,true,_loc5_);
         addChild(log);
         watch = new Watch("watch",0,0,true,_loc5_);
         addChild(watch);
         perf = new Perf("stats",0,0,false,_loc5_);
         addChild(perf);
         vcr = new VCR();
         vcr.x = (param1 - vcr.width / 2) / 2;
         vcr.y = 2;
         addChild(vcr);
         vis = new Vis();
         vis.x = param1 - vis.width - 4;
         vis.y = 2;
         addChild(vis);
         setLayout(0);
         addEventListener("mouseOver",onMouseOver);
         addEventListener("mouseOut",onMouseOut);
      }
      
      public function destroy() : void
      {
         _screen = null;
         removeChild(log);
         log.destroy();
         log = null;
         removeChild(watch);
         watch.destroy();
         watch = null;
         removeChild(perf);
         perf.destroy();
         perf = null;
         removeChild(vcr);
         vcr.destroy();
         vcr = null;
         removeChild(vis);
         vis.destroy();
         vis = null;
         removeEventListener("mouseOver",onMouseOver);
         removeEventListener("mouseOut",onMouseOut);
      }
      
      protected function onMouseOver(param1:MouseEvent = null) : void
      {
         hasMouse = true;
      }
      
      protected function onMouseOut(param1:MouseEvent = null) : void
      {
         hasMouse = false;
      }
      
      public function setLayout(param1:uint) : void
      {
         _layout = param1;
         resetLayout();
      }
      
      public function resetLayout() : void
      {
         switch(_layout)
         {
            case 1:
               log.resize(_screen.x / 4,68);
               log.reposition(0,_screen.y);
               watch.resize(_screen.x / 4,68);
               watch.reposition(_screen.x,_screen.y);
               perf.reposition(_screen.x,0);
               break;
            case 2:
               log.resize((_screen.x - _gutter * 3) / 2,_screen.y / 2);
               log.reposition(0,_screen.y);
               watch.resize((_screen.x - _gutter * 3) / 2,_screen.y / 2);
               watch.reposition(_screen.x,_screen.y);
               perf.reposition(_screen.x,0);
               break;
            case 3:
               log.resize((_screen.x - _gutter * 3) / 2,_screen.y / 4);
               log.reposition(0,0);
               watch.resize((_screen.x - _gutter * 3) / 2,_screen.y / 4);
               watch.reposition(_screen.x,0);
               perf.reposition(_screen.x,_screen.y);
               break;
            case 4:
               log.resize(_screen.x / 3,(_screen.y - 15 - _gutter * 2.5) / 2);
               log.reposition(0,0);
               watch.resize(_screen.x / 3,(_screen.y - 15 - _gutter * 2.5) / 2);
               watch.reposition(0,_screen.y);
               perf.reposition(_screen.x,0);
               break;
            case 5:
               log.resize(_screen.x / 3,(_screen.y - 15 - _gutter * 2.5) / 2);
               log.reposition(_screen.x,0);
               watch.resize(_screen.x / 3,(_screen.y - 15 - _gutter * 2.5) / 2);
               watch.reposition(_screen.x,_screen.y);
               perf.reposition(0,0);
               break;
            default:
               log.resize((_screen.x - _gutter * 3) / 2,_screen.y / 4);
               log.reposition(0,_screen.y);
               watch.resize((_screen.x - _gutter * 3) / 2,_screen.y / 4);
               watch.reposition(_screen.x,_screen.y);
               perf.reposition(_screen.x,0);
         }
      }
   }
}
