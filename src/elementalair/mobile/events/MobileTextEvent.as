package elementalair.mobile.events {
	
	import flash.events.Event;
	
	public class MobileTextEvent extends Event {
		
		public static const KEYBOARD_ACTIVATE:String 	= 'keyboardActivate';
		
		public static const KEYBOARD_ACTIVATING:String 	= 'keyboardActivating';
		
		public static const KEYBOARD_DEACTIVATE:String 	= 'keyboardDeactivate';
		
		public function MobileTextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}