package org.flixel
{
   import flash.display.Sprite;
   import org.flixel.system.FlxDebugger;
   import org.flixel.system.FlxReplay;
   import flash.events.KeyboardEvent;
   import flash.ui.Mouse;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import org.flixel.plugin.TimerManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.display.Graphics;
   
   public class FlxGame extends Sprite
   {
       
      protected var junk:String;
      
      protected var SndBeep:Class;
      
      protected var ImgLogo:Class;
      
      public var useSoundHotKeys:Boolean;
      
      public var useSystemCursor:Boolean;
      
      public var forceDebugger:Boolean;
      
      var _state:FlxState;
      
      var _mouse:Sprite;
      
      protected var _iState:Class;
      
      protected var _created:Boolean;
      
      protected var _total:uint;
      
      protected var _accumulator:int;
      
      protected var _lostFocus:Boolean;
      
      var _step:uint;
      
      var _flashFramerate:uint;
      
      var _maxAccumulation:uint;
      
      var _requestedState:FlxState;
      
      var _requestedReset:Boolean;
      
      protected var _focus:Sprite;
      
      protected var _soundTray:Sprite;
      
      protected var _soundTrayTimer:Number;
      
      protected var _soundTrayBars:Array;
      
      var _debugger:FlxDebugger;
      
      var _debuggerUp:Boolean;
      
      var _replay:FlxReplay;
      
      var _replayRequested:Boolean;
      
      var _recordingRequested:Boolean;
      
      var _replaying:Boolean;
      
      var _recording:Boolean;
      
      var _replayCancelKeys:Array;
      
      var _replayTimer:int;
      
      var _replayCallback:Function;
      
      public function FlxGame(param1:uint, param2:uint, param3:Class, param4:Number = 1, param5:uint = 60, param6:uint = 30, param7:Boolean = false)
      {
         junk = "nokiafc22_ttf$4e74f092958ce7371348b185333c92d84928941";
         SndBeep = beep_mp3$791275df815e4dde11207d984b3b4381450704118;
         ImgLogo = §logo_png$2e96c2ab26dd81051161800807250a85-348389623§;
         super();
         _lostFocus = false;
         _focus = new Sprite();
         _focus.visible = false;
         _soundTray = new Sprite();
         _mouse = new Sprite();
         FlxG.init(this,param1,param2,param4);
         FlxG.framerate = param5;
         FlxG.flashFramerate = param6;
         _accumulator = _step;
         _total = 0;
         _state = null;
         useSoundHotKeys = true;
         useSystemCursor = param7;
         if(!useSystemCursor)
         {
            Mouse.hide();
         }
         forceDebugger = false;
         _debuggerUp = false;
         _replay = new FlxReplay();
         _replayRequested = false;
         _recordingRequested = false;
         _replaying = false;
         _recording = false;
         _iState = param3;
         _requestedState = null;
         _requestedReset = true;
         _created = false;
         addEventListener("enterFrame",create);
      }
      
      function showSoundTray(param1:Boolean = false) : void
      {
         var _loc2_:* = 0;
         if(!param1)
         {
            FlxG.play(SndBeep);
         }
         _soundTrayTimer = 1;
         _soundTray.y = 0;
         _soundTray.visible = true;
         var _loc3_:uint = Math.round(FlxG.volume * 10);
         if(FlxG.mute)
         {
            _loc3_ = 0;
         }
         _loc2_ = 0;
         while(_loc2_ < _soundTrayBars.length)
         {
            if(_loc2_ < _loc3_)
            {
               _soundTrayBars[_loc2_].alpha = 1;
            }
            else
            {
               _soundTrayBars[_loc2_].alpha = 0.5;
            }
            _loc2_++;
         }
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         if(_debuggerUp && _debugger.watch.editing)
         {
            return;
         }
         if(!FlxG.mobile)
         {
            if(_debugger != null && (param1.keyCode == 192 || param1.keyCode == 220))
            {
               _debugger.visible = !_debugger.visible;
               _debuggerUp = _debugger.visible;
               if(_debugger.visible)
               {
                  Mouse.show();
               }
               else if(!useSystemCursor)
               {
                  Mouse.hide();
               }
               return;
            }
            if(useSoundHotKeys)
            {
               _loc2_ = param1.keyCode;
               _loc3_ = String.fromCharCode(param1.charCode);
               var _loc4_:* = _loc2_;
               if(48 !== _loc4_)
               {
                  if(96 !== _loc4_)
                  {
                     if(109 !== _loc4_)
                     {
                        if(189 !== _loc4_)
                        {
                           if(107 !== _loc4_)
                           {
                              if(187 !== _loc4_)
                              {
                              }
                           }
                           FlxG.mute = false;
                           FlxG.volume = FlxG.volume + 0.1;
                           showSoundTray();
                           return;
                        }
                     }
                     FlxG.mute = false;
                     FlxG.volume = FlxG.volume - 0.1;
                     showSoundTray();
                     return;
                  }
               }
               FlxG.mute = !FlxG.mute;
               if(FlxG.volumeHandler != null)
               {
                  FlxG.volumeHandler(FlxG.mute?0:FlxG.volume);
               }
               showSoundTray();
               return;
            }
         }
         if(_replaying)
         {
            return;
         }
         FlxG.keys.handleKeyUp(param1);
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:* = false;
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         if(_debuggerUp && _debugger.watch.editing)
         {
            return;
         }
         if(_replaying && _replayCancelKeys != null && _debugger == null && param1.keyCode != 192 && param1.keyCode != 220)
         {
            _loc2_ = false;
            _loc3_ = 0;
            _loc5_ = _replayCancelKeys.length;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = _replayCancelKeys[_loc3_++];
               if(_loc4_ == "ANY" || FlxG.keys.getKeyCode(_loc4_) == param1.keyCode)
               {
                  if(_replayCallback != null)
                  {
                     _replayCallback();
                     _replayCallback = null;
                  }
                  else
                  {
                     FlxG.stopReplay();
                  }
                  break;
               }
            }
            return;
         }
         FlxG.keys.handleKeyDown(param1);
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         if(_debuggerUp)
         {
            if(_debugger.hasMouse)
            {
               return;
            }
            if(_debugger.watch.editing)
            {
               _debugger.watch.submit();
            }
         }
         if(_replaying && _replayCancelKeys != null)
         {
            _loc2_ = 0;
            _loc4_ = _replayCancelKeys.length;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = _replayCancelKeys[_loc2_++] as String;
               if(_loc3_ == "MOUSE" || _loc3_ == "ANY")
               {
                  if(_replayCallback != null)
                  {
                     _replayCallback();
                     _replayCallback = null;
                  }
                  else
                  {
                     FlxG.stopReplay();
                  }
                  break;
               }
            }
            return;
         }
         FlxG.mouse.handleMouseDown(param1);
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         if(_debuggerUp && _debugger.hasMouse || _replaying)
         {
            return;
         }
         FlxG.mouse.handleMouseUp(param1);
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         if(_debuggerUp && _debugger.hasMouse || _replaying)
         {
            return;
         }
         FlxG.mouse.handleMouseWheel(param1);
      }
      
      protected function onFocus(param1:Event = null) : void
      {
         if(!_debuggerUp && !useSystemCursor)
         {
            Mouse.hide();
         }
         FlxG.resetInput();
         var _loc2_:* = false;
         _focus.visible = _loc2_;
         _lostFocus = _loc2_;
         stage.frameRate = _flashFramerate;
         FlxG.resumeSounds();
      }
      
      protected function onFocusLost(param1:Event = null) : void
      {
         if(x != 0 || y != 0)
         {
            x = 0;
            y = 0;
         }
         Mouse.show();
         var _loc2_:* = true;
         _focus.visible = _loc2_;
         _lostFocus = _loc2_;
         stage.frameRate = 10;
         FlxG.pauseSounds();
      }
      
      protected function onEnterFrame(param1:Event = null) : void
      {
         var _loc2_:uint = getTimer();
         var _loc3_:uint = _loc2_ - _total;
         _total = _loc2_;
         updateSoundTray(_loc3_);
         if(!_lostFocus)
         {
            if(_debugger != null && _debugger.vcr.paused)
            {
               if(_debugger.vcr.stepRequested)
               {
                  _debugger.vcr.stepRequested = false;
                  step();
               }
            }
            else
            {
               _accumulator = §§dup()._accumulator + _loc3_;
               if(_accumulator > _maxAccumulation)
               {
                  _accumulator = _maxAccumulation;
               }
               while(_accumulator >= _step)
               {
                  step();
                  _accumulator = _accumulator - _step;
               }
            }
            FlxBasic._VISIBLECOUNT = 0;
            draw();
            if(_debuggerUp)
            {
               _debugger.perf.flash(_loc3_);
               _debugger.perf.visibleObjects(FlxBasic._VISIBLECOUNT);
               _debugger.perf.update();
               _debugger.watch.update();
            }
         }
      }
      
      protected function switchState() : void
      {
         FlxG.resetCameras();
         FlxG.resetInput();
         FlxG.destroySounds();
         FlxG.clearBitmapCache();
         if(_debugger != null)
         {
            _debugger.watch.removeAll();
         }
         var _loc1_:TimerManager = FlxTimer.manager;
         if(_loc1_ != null)
         {
            _loc1_.clear();
         }
         if(_state != null)
         {
            _state.destroy();
         }
         _state = _requestedState;
         _state.create();
      }
      
      protected function step() : void
      {
         if(_requestedReset)
         {
            _requestedReset = false;
            _requestedState = new _iState();
            _replayTimer = 0;
            _replayCancelKeys = null;
            FlxG.reset();
         }
         if(_recordingRequested)
         {
            _recordingRequested = false;
            _replay.create(FlxG.globalSeed);
            _recording = true;
            if(_debugger != null)
            {
               _debugger.vcr.recording();
               FlxG.log("FLIXEL: starting new flixel gameplay record.");
            }
         }
         else if(_replayRequested)
         {
            _replayRequested = false;
            _replay.rewind();
            FlxG.globalSeed = _replay.seed;
            if(_debugger != null)
            {
               _debugger.vcr.playing();
            }
            _replaying = true;
         }
         if(_state != _requestedState)
         {
            switchState();
         }
         FlxBasic._ACTIVECOUNT = 0;
         if(_replaying)
         {
            _replay.playNextFrame();
            if(_replayTimer > 0)
            {
               _replayTimer = §§dup()._replayTimer - _step;
               if(_replayTimer <= 0)
               {
                  if(_replayCallback != null)
                  {
                     _replayCallback();
                     _replayCallback = null;
                  }
                  else
                  {
                     FlxG.stopReplay();
                  }
               }
            }
            if(_replaying && _replay.finished)
            {
               FlxG.stopReplay();
               if(_replayCallback != null)
               {
                  _replayCallback();
                  _replayCallback = null;
               }
            }
            if(_debugger != null)
            {
               _debugger.vcr.updateRuntime(_step);
            }
         }
         else
         {
            FlxG.updateInput();
         }
         if(_recording)
         {
            _replay.recordFrame();
            if(_debugger != null)
            {
               _debugger.vcr.updateRuntime(_step);
            }
         }
         update();
         FlxG.mouse.wheel = 0;
         if(_debuggerUp)
         {
            _debugger.perf.activeObjects(FlxBasic._ACTIVECOUNT);
         }
      }
      
      protected function updateSoundTray(param1:Number) : void
      {
         var _loc2_:* = null;
         if(_soundTray != null)
         {
            if(_soundTrayTimer > 0)
            {
               _soundTrayTimer = §§dup()._soundTrayTimer - param1 / 1000;
            }
            else if(_soundTray.y > -_soundTray.height)
            {
               _soundTray.y = _soundTray.y - param1 / 1000 * FlxG.height * 2;
               if(_soundTray.y <= -_soundTray.height)
               {
                  _soundTray.visible = false;
                  _loc2_ = new FlxSave();
                  if(_loc2_.bind("flixel"))
                  {
                     if(_loc2_.data.sound == null)
                     {
                        _loc2_.data.sound = {};
                     }
                     _loc2_.data.sound.mute = FlxG.mute;
                     _loc2_.data.sound.volume = FlxG.volume;
                     _loc2_.close();
                  }
               }
            }
         }
      }
      
      protected function update() : void
      {
         var _loc1_:uint = getTimer();
         FlxG.elapsed = FlxG.timeScale * _step / 1000;
         FlxG.updateSounds();
         FlxG.updatePlugins();
         _state.update();
         FlxG.updateCameras();
         if(_debuggerUp)
         {
            _debugger.perf.flixelUpdate(getTimer() - _loc1_);
         }
      }
      
      protected function draw() : void
      {
         var _loc1_:uint = getTimer();
         FlxG.lockCameras();
         _state.draw();
         FlxG.drawPlugins();
         FlxG.unlockCameras();
         if(_debuggerUp)
         {
            _debugger.perf.flixelDraw(getTimer() - _loc1_);
         }
      }
      
      protected function create(param1:Event) : void
      {
         if(root == null)
         {
            return;
         }
         removeEventListener("enterFrame",create);
         _total = getTimer();
         stage.scaleMode = "noScale";
         stage.align = "TL";
         stage.frameRate = _flashFramerate;
         stage.addEventListener("mouseDown",onMouseDown);
         stage.addEventListener("mouseUp",onMouseUp);
         stage.addEventListener("mouseWheel",onMouseWheel);
         stage.addEventListener("keyDown",onKeyDown);
         stage.addEventListener("keyUp",onKeyUp);
         addChild(_mouse);
         if(!FlxG.mobile)
         {
            if(FlxG.debug || forceDebugger)
            {
               _debugger = new FlxDebugger(FlxG.width * FlxCamera.defaultZoom,FlxG.height * FlxCamera.defaultZoom);
               addChild(_debugger);
            }
            createSoundTray();
            stage.addEventListener("deactivate",onFocusLost);
            stage.addEventListener("activate",onFocus);
            createFocusScreen();
         }
         addEventListener("enterFrame",onEnterFrame);
      }
      
      protected function createSoundTray() : void
      {
         _soundTray.visible = false;
         _soundTray.scaleX = 2;
         _soundTray.scaleY = 2;
         var _loc2_:Bitmap = new Bitmap(new BitmapData(80,30,true,2130706432));
         _soundTray.x = FlxG.width / 2 * FlxCamera.defaultZoom - _loc2_.width / 2 * _soundTray.scaleX;
         _soundTray.addChild(_loc2_);
         var _loc6_:TextField = new TextField();
         _loc6_.width = _loc2_.width;
         _loc6_.height = _loc2_.height;
         _loc6_.multiline = true;
         _loc6_.wordWrap = true;
         _loc6_.selectable = false;
         _loc6_.embedFonts = true;
         _loc6_.antiAliasType = "normal";
         _loc6_.gridFitType = "pixel";
         _loc6_.defaultTextFormat = new TextFormat("system",8,16777215,null,null,null,null,null,"center");
         _soundTray.addChild(_loc6_);
         _loc6_.text = "VOLUME";
         _loc6_.y = 16;
         var _loc3_:uint = 10;
         var _loc4_:uint = 14;
         _soundTrayBars = [];
         var _loc5_:uint = 0;
         while(_loc5_ < 10)
         {
            _loc2_ = new Bitmap(new BitmapData(4,++_loc5_,false,16777215));
            _loc2_.x = _loc3_;
            _loc2_.y = _loc4_;
            _soundTrayBars.push(_soundTray.addChild(_loc2_));
            _loc3_ = _loc3_ + 6;
            _loc4_--;
         }
         _soundTray.y = -_soundTray.height;
         _soundTray.visible = false;
         addChild(_soundTray);
         var _loc1_:FlxSave = new FlxSave();
         if(_loc1_.bind("flixel") && _loc1_.data.sound != null)
         {
            if(_loc1_.data.sound.volume != null)
            {
               FlxG.volume = _loc1_.data.sound.volume;
            }
            if(_loc1_.data.sound.mute != null)
            {
               FlxG.mute = _loc1_.data.sound.mute;
            }
            _loc1_.destroy();
         }
      }
      
      protected function createFocusScreen() : void
      {
         var _loc5_:Graphics = _focus.graphics;
         var _loc1_:uint = FlxG.width * FlxCamera.defaultZoom;
         var _loc4_:uint = FlxG.height * FlxCamera.defaultZoom;
         _loc5_.moveTo(0,0);
         _loc5_.beginFill(0,0.5);
         _loc5_.lineTo(_loc1_,0);
         _loc5_.lineTo(_loc1_,_loc4_);
         _loc5_.lineTo(0,_loc4_);
         _loc5_.lineTo(0,0);
         _loc5_.endFill();
         var _loc7_:uint = _loc1_ / 2;
         var _loc3_:uint = _loc4_ / 2;
         var _loc2_:uint = FlxU.min(_loc7_,_loc3_) / 3;
         _loc5_.moveTo(_loc7_ - _loc2_,_loc3_ - _loc2_);
         _loc5_.beginFill(16777215,0.65);
         _loc5_.lineTo(_loc7_ + _loc2_,_loc3_);
         _loc5_.lineTo(_loc7_ - _loc2_,_loc3_ + _loc2_);
         _loc5_.lineTo(_loc7_ - _loc2_,_loc3_ - _loc2_);
         _loc5_.endFill();
         var _loc6_:Bitmap = new ImgLogo();
         _loc6_.scaleX = _loc2_ / 10;
         if(_loc6_.scaleX < 1)
         {
            _loc6_.scaleX = 1;
         }
         _loc6_.scaleY = _loc6_.scaleX;
         _loc6_.x = _loc6_.x - _loc6_.scaleX;
         _loc6_.alpha = 0.35;
         _focus.addChild(_loc6_);
         addChild(_focus);
      }
   }
}
