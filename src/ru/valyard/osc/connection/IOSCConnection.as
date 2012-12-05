////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection
{
	import flash.events.IEventDispatcher;
	
	import ru.valyard.osc.IOSCMessageFactory;
	import ru.valyard.osc.data.OSCPacket;

	/**
	 * @author					valyard
	 */
	public interface IOSCConnection extends IEventDispatcher {
		
		/**
		 * OSCFactory for creating OSC packets
		 */
		function get factory():IOSCMessageFactory;
		
		/**
		 * true if connection is ready
		 */
		function get active():Boolean;
		
		/**
		 * Sends an OSC packet
		 */
		function send(packet:OSCPacket):void;
		
		/**
		 * Closes connection
		 */
		function close():void;
		
		/**
		 * Adds a listener
		 */
		function addListener(listener:IOSCConnectionListener):void;
		
		/**
		 * Removes a listener
		 */
		function removeListener(listener:IOSCConnectionListener):void;
	}
}