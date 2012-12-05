////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection {
	
	/**
	 * @author					valyard
	 */
	public interface IOSCClientConnection extends IOSCConnection {
		
		/**
		 * Connects to remote socket
		 */
		function connect(host:String = null, port:uint = 0):void;
		
	}
}