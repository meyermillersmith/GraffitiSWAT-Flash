package com.lessrain.project.view.components.palette {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.components.toolpalette.ToolButton;
	import com.lessrain.project.view.utils.PopupContainer;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author denise
	 */
	public class ToolTip extends Sprite {
		public static const TOOLTIP_MAX_WIDTH : Number = 200;
		public static const POINTER_OFFSET : Number = 50;
		public static const MARGIN : Number = 5;
		public static const CLOSED : String = 'tooltip.closed';
		private var _background : Sprite;
		private var _title : SimpleTextfield;
		private var _toolButton : ToolButton;
		
		public function ToolTip(toolButton_ : ToolButton) {
			PopupContainer.getInstance().addChild(this);
			_background = addChild(Sprite(ApplicationFacade.getSWFAssetInstance('Bubble'))) as Sprite;
			
			_toolButton = toolButton_;
			
			var textKey:String = 'tool.'+toolButton_.toolData.key+'.tooltip';
			_title = addChild(new SimpleTextfield(ApplicationFacade.getCopy(textKey), '.toolTitle',TOOLTIP_MAX_WIDTH - 2*MARGIN,true,true)) as SimpleTextfield;
			_title.x = _title.y = MARGIN;
			_background.width = _title.width + 2*MARGIN;
			_background.height = _title.height + 2*MARGIN;
			
			var position:Point = _toolButton.localToGlobal(new Point());
			x = Math.min(stage.stageWidth, Math.max(0, position.x - POINTER_OFFSET + ToolButton.CIRCLE_WIDTH / 2));
			y = Math.min(stage.stageHeight, Math.max(0, position.y - height - MARGIN));
			
			addEventListener(MouseEvent.CLICK, close);
		}

		private function close(event : MouseEvent) : void {
			dispatchEvent(new Event(CLOSED));
		}

		public function destroy() : void {
			visible = false;
			removeEventListener(MouseEvent.CLICK, destroy);
			parent.removeChild(this);
		}

		public function get toolButton() : ToolButton {
			return _toolButton;
		}
	}
}
