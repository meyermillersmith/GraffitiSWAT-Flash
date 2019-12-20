package com.lessrain.project.controller {
	import com.lessrain.project.view.GoToFacebookMediator;
	import com.lessrain.project.view.ApplicationMediator;
	import com.lessrain.project.view.CheckSurfaceMediator;
	import com.lessrain.project.view.ControlsMediator;
	import com.lessrain.project.view.EditorMediator;
	import com.lessrain.project.view.FacebookMediator;
	import com.lessrain.project.view.FileSaveMediator;
	import com.lessrain.project.view.ToolPaletteMediator;
	import com.lessrain.project.view.components.Application;
	import com.lessrain.project.view.components.Controls;
	import com.lessrain.project.view.components.Editor;
	import com.lessrain.project.view.components.FileSaveDisplay;
	import com.lessrain.project.view.components.facebook.FacebookConnector;
	import com.lessrain.project.view.components.toolpalette.ToolPalette;
	import com.lessrain.project.view.utils.FullScreenManager;
	import com.lessrain.project.view.utils.PopupContainer;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;




	/**
	 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
	 */
	public class ViewPrepareCommand extends SimpleCommand 
	{

		override public function execute(notification_ : INotification) : void 
		{
			var application : Application = notification_.getBody() as Application;
			facade.registerMediator(new ApplicationMediator(application));
			
			var editor : Editor = application.applicationDisplayListManager.applicationContainer.addChild(new Editor(application.getParam('fbid') == "-1")) as Editor;
			facade.registerMediator(new EditorMediator(editor));
			
			var toolPalette : ToolPalette = application.applicationDisplayListManager.applicationContainer.addChild(new ToolPalette()) as ToolPalette;
			facade.registerMediator(new ToolPaletteMediator(toolPalette));
			
			var fbConnector : FacebookConnector = application.applicationDisplayListManager.applicationContainer.addChild(new FacebookConnector(application.getParam('fbid'),application.getParam('name'),application.getParam('first_name'),application.getParam('collabid'),application.getParam('collab_request_id'))) as FacebookConnector;
			facade.registerMediator(new FacebookMediator(fbConnector));
			
			var controls : Controls = application.applicationDisplayListManager.applicationContainer.addChild(new Controls(application.getParam('showBanner') == 'true',application.getParam('fbid'))) as Controls;
			facade.registerMediator(new ControlsMediator(controls));
			
			var filesaver : FileSaveDisplay = application.applicationDisplayListManager.applicationContainer.addChild(new FileSaveDisplay()) as FileSaveDisplay;
			facade.registerMediator(new FileSaveMediator(filesaver));
			
			facade.registerMediator(new GoToFacebookMediator());
			
			facade.registerMediator(new CheckSurfaceMediator(application.getParam('surfaceid'),application.getParam('collabid')));
			
			application.applicationDisplayListManager.applicationContainer.addChild(PopupContainer.getInstance());
			
			application.applicationDisplayListManager.applicationContainer.addChild(FullScreenManager.getInstance()) as FullScreenManager;
		}
	}
}
