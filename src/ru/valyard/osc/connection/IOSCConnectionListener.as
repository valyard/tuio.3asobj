////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection
{
	import ru.valyard.osc.data.OSCMessage;

	/**
	 * @author					valyard
	 */
	public interface IOSCConnectionListener {
		
		/**
		 * Receives a dispatched OSC message from connection
		 */
		function receiveOSCMessage(message:OSCMessage):void;
	}
}