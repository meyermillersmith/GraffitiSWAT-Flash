package com.lessrain.project.controller {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.components.Application;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.statemachine.FSMInjector;

	/**
	 * Create and inject the StateMachine.
	 */
	public class FSMInjectCommand extends SimpleCommand 
	{

		override public function execute( notification_ : INotification ) : void 
		{
			// Create the FSM definition
			var fsm:XML = <fsm initial={Application.STATE_LOADING}>
			   <state name={Application.STATE_LOADING} entering={ApplicationFacade.LOADING_STATE_ENTER}>
			       <transition action={Application.ACTION_COMPLETE} target={Application.STATE_MAIN}/>
			   </state>
			   <state name={Application.STATE_MAIN} entering={ApplicationFacade.MAIN_STATE_ENTER}>
			   </state>
			</fsm>;
			
			// Create and inject the StateMachine 
			var injector:FSMInjector = new FSMInjector( fsm );
			injector.initializeNotifier(this.multitonKey);
			injector.inject();
		}
	}
}
