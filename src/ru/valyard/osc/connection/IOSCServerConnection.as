////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection {
	
	/**
	 * @author					valyard
	 */
	public interface IOSCServerConnection extends IOSCConnection {
		
		/**
		 * Starts listening for incoming connection
		 */
		function open(host:String = null, port:uint = 0):void;
		
	}
}