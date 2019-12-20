package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
	 * @author Oliver List, Less Rain (o.list@lessrain.com)
	 */

	[SWF(width="760", frameRate="30", backgroundColor="#ffffff")]

	public class Preloader extends MovieClip
	{

		public function Preloader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
			
			stop();
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		private function onEnterFrame(e_ : Event) : void
		{
			if(framesLoaded == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				init();
			}
		}

		private function init() : void 
		{
			var mainClass : Class = Class(getDefinitionByName("Main"));
			if (mainClass) 
			{
				var app : Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}
}