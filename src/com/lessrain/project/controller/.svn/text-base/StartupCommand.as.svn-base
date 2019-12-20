package com.lessrain.project.controller {
	import com.lessrain.puremvc.transitionviews.controller.TransitionViewsPrepareCommand;
	import com.lessrain.puremvc.assets.controller.AssetsPrepareCommand;
	import com.lessrain.puremvc.swfaddress.controller.SWFAddressPrepareCommand;

	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
	 */
	public class StartupCommand extends MacroCommand 
	{

		override protected function initializeMacroCommand() : void 
		{
			//addSubCommand(SWFAddressPrepareCommand);			addSubCommand(AssetsPrepareCommand);
			addSubCommand(ModelPrepareCommand);
			addSubCommand(TransitionViewsPrepareCommand);
			addSubCommand(ViewPrepareCommand);
			addSubCommand(FSMInjectCommand); 		}
	}
}
