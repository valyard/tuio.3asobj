////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection {
	
	import ru.valyard.osc.tuio.data.TUIOObject;
	
	/**
	 * @author					valyard
	 */
	public interface ITUIOObjectListener extends ITUIOConnectionListener {
		
		/**
		 * Callback for adding TUIO objects
		 * @param object	TUIOObject instance
		 */
		function addTUIOObject(object:TUIOObject):void;
		
		/**
		 * Callback for updating TUIO objects
		 * @param object	TUIOObject instance
		 */
		function updateTUIOObject(object:TUIOObject):void;
		
		/**
		 * Callback for removing TUIO objects
		 * @param object	TUIOObject instance
		 */
		function removeTUIOObject(object:TUIOObject):void;
		
	}
}