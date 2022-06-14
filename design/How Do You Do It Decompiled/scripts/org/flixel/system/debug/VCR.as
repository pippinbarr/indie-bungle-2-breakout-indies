package org.flixel.system.debug
{
   import flash.display.Sprite;
   import flash.net.FileFilter;
   import flash.display.Bitmap;
   import flash.net.FileReference;
   import flash.text.TextField;
   import org.flixel.FlxU;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.flixel.FlxG;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class VCR extends Sprite
   {
      
      protected static const FILE_TYPES:Array = [new FileFilter("Flixel Game Recording","*.fgr")];
      
      protected static const DEFAULT_FILE_NAME:String = "replay.fgr";
       
      protected var ImgOpen:Class;
      
      protected var ImgRecordOff:Class;
      
      protected var ImgRecordOn:Class;
      
      protected var ImgStop:Class;
      
      protected var ImgFlixel:Class;
      
      protected var ImgRestart:Class;
      
      protected var ImgPause:Class;
      
      protected var ImgPlay:Class;
      
      protected var ImgStep:Class;
      
      public var paused:Boolean;
      
      public var stepRequested:Boolean;
      
      protected var _open:Bitmap;
      
      protected var _recordOff:Bitmap;
      
      protected var _recordOn:Bitmap;
      
      protected var _stop:Bitmap;
      
      protected var _flixel:Bitmap;
      
      protected var _restart:Bitmap;
      
      protected var _pause:Bitmap;
      
      protected var _play:Bitmap;
      
      protected var _step:Bitmap;
      
      protected var _overOpen:Boolean;
      
      protected var _overRecord:Boolean;
      
      protected var _overRestart:Boolean;
      
      protected var _overPause:Boolean;
      
      protected var _overStep:Boolean;
      
      protected var _pressingOpen:Boolean;
      
      protected var _pressingRecord:Boolean;
      
      protected var _pressingRestart:Boolean;
      
      protected var _pressingPause:Boolean;
      
      protected var _pressingStep:Boolean;
      
      protected var _file:FileReference;
      
      protected var _runtimeDisplay:TextField;
      
      protected var _runtime:uint;
      
      public function VCR()
      {
         ImgOpen = open_png$a027a47a8bb7dc34c0cf2a2c879ba1b21405714434;
         ImgRecordOff = §record_off_png$68ad9f3570721aed98a68316e381e04f-2034136055§;
         ImgRecordOn = §record_on_png$5814c6b0f37e194417365d07fbf3e5f9-68880813§;
         ImgStop = §stop_png$2b58dc322d6a51fe3baab9c15ae149ec-283129270§;
         ImgFlixel = §flixel_png$3469cb29ba49c6951c2a09934bd8626e-1440441364§;
         ImgRestart = restart_png$b8749e33691d6f99e379ebc17c7ab0e7850741293;
         ImgPause = pause_png$86ffb7af3a7b50d728acc784d9af2ab2113976260;
         ImgPlay = §play_png$ade29599517449b4cfec59bac502f92e-438722444§;
         ImgStep = §step_png$410a6eb339db8729c438855bb38995a1-1072738148§;
         super();
         var _loc1_:uint = 7;
         _open = new ImgOpen();
         addChild(_open);
         _recordOff = new ImgRecordOff();
         _recordOff.x = _open.x + _open.width + _loc1_;
         addChild(_recordOff);
         _recordOn = new ImgRecordOn();
         _recordOn.x = _recordOff.x;
         _recordOn.visible = false;
         addChild(_recordOn);
         _stop = new ImgStop();
         _stop.x = _recordOff.x;
         _stop.visible = false;
         addChild(_stop);
         _flixel = new ImgFlixel();
         _flixel.x = _recordOff.x + _recordOff.width + _loc1_;
         addChild(_flixel);
         _restart = new ImgRestart();
         _restart.x = _flixel.x + _flixel.width + _loc1_;
         addChild(_restart);
         _pause = new ImgPause();
         _pause.x = _restart.x + _restart.width + _loc1_;
         addChild(_pause);
         _play = new ImgPlay();
         _play.x = _pause.x;
         _play.visible = false;
         addChild(_play);
         _step = new ImgStep();
         _step.x = _pause.x + _pause.width + _loc1_;
         addChild(_step);
         _runtimeDisplay = new TextField();
         _runtimeDisplay.width = width;
         _runtimeDisplay.x = width;
         _runtimeDisplay.y = -2;
         _runtimeDisplay.multiline = false;
         _runtimeDisplay.wordWrap = false;
         _runtimeDisplay.selectable = false;
         _runtimeDisplay.defaultTextFormat = new TextFormat("Courier",12,16777215,null,null,null,null,null,"center");
         _runtimeDisplay.visible = false;
         addChild(_runtimeDisplay);
         _runtime = 0;
         stepRequested = false;
         _file = null;
         unpress();
         checkOver();
         updateGUI();
         addEventListener("enterFrame",init);
      }
      
      public function destroy() : void
      {
         _file = null;
         removeChild(_open);
         _open = null;
         removeChild(_recordOff);
         _recordOff = null;
         removeChild(_recordOn);
         _recordOn = null;
         removeChild(_stop);
         _stop = null;
         removeChild(_flixel);
         _flixel = null;
         removeChild(_restart);
         _restart = null;
         removeChild(_pause);
         _pause = null;
         removeChild(_play);
         _play = null;
         removeChild(_step);
         _step = null;
         parent.removeEventListener("mouseMove",onMouseMove);
         parent.removeEventListener("mouseDown",onMouseDown);
         parent.removeEventListener("mouseUp",onMouseUp);
      }
      
      public function recording() : void
      {
         _stop.visible = false;
         _recordOff.visible = false;
         _recordOn.visible = true;
      }
      
      public function stopped() : void
      {
         _stop.visible = false;
         _recordOn.visible = false;
         _recordOff.visible = true;
      }
      
      public function playing() : void
      {
         _recordOff.visible = false;
         _recordOn.visible = false;
         _stop.visible = true;
      }
      
      public function updateRuntime(param1:uint) : void
      {
         _runtime = §§dup()._runtime + param1;
         _runtimeDisplay.text = FlxU.formatTime(_runtime / 1000,true);
         if(!_runtimeDisplay.visible)
         {
            _runtimeDisplay.visible = true;
         }
      }
      
      public function onOpen() : void
      {
         _file = new FileReference();
         _file.addEventListener("select",onOpenSelect);
         _file.addEventListener("cancel",onOpenCancel);
         _file.browse(FILE_TYPES);
      }
      
      protected function onOpenSelect(param1:Event = null) : void
      {
         _file.removeEventListener("select",onOpenSelect);
         _file.removeEventListener("cancel",onOpenCancel);
         _file.addEventListener("complete",onOpenComplete);
         _file.addEventListener("ioError",onOpenError);
         _file.load();
      }
      
      protected function onOpenComplete(param1:Event = null) : void
      {
         _file.removeEventListener("complete",onOpenComplete);
         _file.removeEventListener("ioError",onOpenError);
         var _loc3_:String = null;
         var _loc2_:ByteArray = _file.data;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.readUTFBytes(_loc2_.bytesAvailable);
         }
         _file = null;
         if(_loc3_ == null || _loc3_.length <= 0)
         {
            FlxG.log("ERROR: Empty flixel gameplay record.");
            return;
         }
         FlxG.loadReplay(_loc3_);
      }
      
      protected function onOpenCancel(param1:Event = null) : void
      {
         _file.removeEventListener("select",onOpenSelect);
         _file.removeEventListener("cancel",onOpenCancel);
         _file = null;
      }
      
      protected function onOpenError(param1:Event = null) : void
      {
         _file.removeEventListener("complete",onOpenComplete);
         _file.removeEventListener("ioError",onOpenError);
         _file = null;
         FlxG.log("ERROR: Unable to open flixel gameplay record.");
      }
      
      public function onRecord(param1:Boolean = false) : void
      {
         if(_play.visible)
         {
            onPlay();
         }
         FlxG.recordReplay(param1);
      }
      
      public function stopRecording() : void
      {
         var _loc1_:String = FlxG.stopRecording();
         if(_loc1_ != null && _loc1_.length > 0)
         {
            _file = new FileReference();
            _file.addEventListener("complete",onSaveComplete);
            _file.addEventListener("cancel",onSaveCancel);
            _file.addEventListener("ioError",onSaveError);
            _file.save(_loc1_,"replay.fgr");
         }
      }
      
      protected function onSaveComplete(param1:Event = null) : void
      {
         _file.removeEventListener("complete",onSaveComplete);
         _file.removeEventListener("cancel",onSaveCancel);
         _file.removeEventListener("ioError",onSaveError);
         _file = null;
         FlxG.log("FLIXEL: successfully saved flixel gameplay record.");
      }
      
      protected function onSaveCancel(param1:Event = null) : void
      {
         _file.removeEventListener("complete",onSaveComplete);
         _file.removeEventListener("cancel",onSaveCancel);
         _file.removeEventListener("ioError",onSaveError);
         _file = null;
      }
      
      protected function onSaveError(param1:Event = null) : void
      {
         _file.removeEventListener("complete",onSaveComplete);
         _file.removeEventListener("cancel",onSaveCancel);
         _file.removeEventListener("ioError",onSaveError);
         _file = null;
         FlxG.log("ERROR: problem saving flixel gameplay record.");
      }
      
      public function onStop() : void
      {
         FlxG.stopReplay();
      }
      
      public function onRestart(param1:Boolean = false) : void
      {
         if(FlxG.reloadReplay(param1))
         {
            _recordOff.visible = false;
            _recordOn.visible = false;
            _stop.visible = true;
         }
      }
      
      public function onPause() : void
      {
         paused = true;
         _pause.visible = false;
         _play.visible = true;
      }
      
      public function onPlay() : void
      {
         paused = false;
         _play.visible = false;
         _pause.visible = true;
      }
      
      public function onStep() : void
      {
         if(!paused)
         {
            onPause();
         }
         stepRequested = true;
      }
      
      protected function init(param1:Event = null) : void
      {
         if(root == null)
         {
            return;
         }
         removeEventListener("enterFrame",init);
         parent.addEventListener("mouseMove",onMouseMove);
         parent.addEventListener("mouseDown",onMouseDown);
         parent.addEventListener("mouseUp",onMouseUp);
      }
      
      protected function onMouseMove(param1:MouseEvent = null) : void
      {
         if(!checkOver())
         {
            unpress();
         }
         updateGUI();
      }
      
      protected function onMouseDown(param1:MouseEvent = null) : void
      {
         unpress();
         if(_overOpen)
         {
            _pressingOpen = true;
         }
         if(_overRecord)
         {
            _pressingRecord = true;
         }
         if(_overRestart)
         {
            _pressingRestart = true;
         }
         if(_overPause)
         {
            _pressingPause = true;
         }
         if(_overStep)
         {
            _pressingStep = true;
         }
      }
      
      protected function onMouseUp(param1:MouseEvent = null) : void
      {
         if(_overOpen && _pressingOpen)
         {
            onOpen();
         }
         else if(_overRecord && _pressingRecord)
         {
            if(_stop.visible)
            {
               onStop();
            }
            else if(_recordOn.visible)
            {
               stopRecording();
            }
            else
            {
               onRecord(!param1.altKey);
            }
         }
         else if(_overRestart && _pressingRestart)
         {
            onRestart(!param1.altKey);
         }
         else if(_overPause && _pressingPause)
         {
            if(_play.visible)
            {
               onPlay();
            }
            else
            {
               onPause();
            }
         }
         else if(_overStep && _pressingStep)
         {
            onStep();
         }
         unpress();
         checkOver();
         updateGUI();
      }
      
      protected function checkOver() : Boolean
      {
         _overStep = false;
         _overPause = false;
         _overRestart = false;
         _overRecord = false;
         _overOpen = false;
         if(mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > 15)
         {
            return false;
         }
         if(mouseX >= _recordOff.x && mouseX <= _recordOff.x + _recordOff.width)
         {
            _overRecord = true;
         }
         if(!_recordOn.visible && !_overRecord)
         {
            if(mouseX >= _open.x && mouseX <= _open.x + _open.width)
            {
               _overOpen = true;
            }
            else if(mouseX >= _restart.x && mouseX <= _restart.x + _restart.width)
            {
               _overRestart = true;
            }
            else if(mouseX >= _pause.x && mouseX <= _pause.x + _pause.width)
            {
               _overPause = true;
            }
            else if(mouseX >= _step.x && mouseX <= _step.x + _step.width)
            {
               _overStep = true;
            }
         }
         return true;
      }
      
      protected function unpress() : void
      {
         _pressingOpen = false;
         _pressingRecord = false;
         _pressingRestart = false;
         _pressingPause = false;
         _pressingStep = false;
      }
      
      protected function updateGUI() : void
      {
         if(_recordOn.visible)
         {
            var _loc1_:* = 0.35;
            _step.alpha = _loc1_;
            _loc1_ = _loc1_;
            _pause.alpha = _loc1_;
            _loc1_ = _loc1_;
            _restart.alpha = _loc1_;
            _open.alpha = _loc1_;
            _recordOn.alpha = 1;
            return;
         }
         if(_overOpen && _open.alpha != 1)
         {
            _open.alpha = 1;
         }
         else if(!_overOpen && _open.alpha != 0.8)
         {
            _open.alpha = 0.8;
         }
         if(_overRecord && _recordOff.alpha != 1)
         {
            _loc1_ = 1;
            _stop.alpha = _loc1_;
            _loc1_ = _loc1_;
            _recordOn.alpha = _loc1_;
            _recordOff.alpha = _loc1_;
         }
         else if(!_overRecord && _recordOff.alpha != 0.8)
         {
            _loc1_ = 0.8;
            _stop.alpha = _loc1_;
            _loc1_ = _loc1_;
            _recordOn.alpha = _loc1_;
            _recordOff.alpha = _loc1_;
         }
         if(_overRestart && _restart.alpha != 1)
         {
            _restart.alpha = 1;
         }
         else if(!_overRestart && _restart.alpha != 0.8)
         {
            _restart.alpha = 0.8;
         }
         if(_overPause && _pause.alpha != 1)
         {
            _loc1_ = 1;
            _play.alpha = _loc1_;
            _pause.alpha = _loc1_;
         }
         else if(!_overPause && _pause.alpha != 0.8)
         {
            _loc1_ = 0.8;
            _play.alpha = _loc1_;
            _pause.alpha = _loc1_;
         }
         if(_overStep && _step.alpha != 1)
         {
            _step.alpha = 1;
         }
         else if(!_overStep && _step.alpha != 0.8)
         {
            _step.alpha = 0.8;
         }
      }
   }
}
