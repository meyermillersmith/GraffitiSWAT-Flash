package com.lessrain.project.controller {
	import com.lessrain.project.model.ApplicationParamsProxy;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
	 */
	public class ModelPrepareCommand extends SimpleCommand 
	{

		override public function execute(notification_ : INotification) : void 
		{
			facade.registerProxy(new ApplicationParamsProxy());		}
	}
}
