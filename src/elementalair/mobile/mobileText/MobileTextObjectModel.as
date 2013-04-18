package elementalair.mobile.mobileText {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.StageText;
	import flash.text.SoftKeyboardType;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.text.ReturnKeyLabel;
	
	import elementalair.mobile.mobileText.MobileTextObject;
	
	/**
	 * StageTextModel is the base super class for StageTextObject. It acts as a properties model for 
	 * getting and setting all properties and variables for the StageText object. This kepps all 
	 * properties separate from the implementation functions in the StageTextObject class.
	 */
	public class MobileTextObjectModel extends Sprite {
		
		/** id name of StageTextObject **/
		private var _name:String;
		
		/** TextField properties **/
		private var _fontSize:Number 		= 12;
		private var _fontColor:uint 		= 0x000000;
		private var _fontFace:String;
		private var _textFieldWidth:Number 	= 300;
		private var _textFieldHeight:Number = 20;
		private var _textValue:String;
		
		/** TextField background properties **/
		private var _hasBackground:Boolean 	= false;
		private var _backgroundColor:uint 	= 0xFFFFFF;
		private var _borderColor:uint		= 0x000000;
		private var _borderThickness:Number = 1;
		
		/** Object display objects **/
		private var _stageText:StageText;
		private var _backgroundSprite:Sprite;
		private var _stageTextBitmapCopy:Sprite;
		
		private var _textFieldToCopy:TextField;
		
		/** SoftKeyboard properties **/
		private var _softKeyboardType:String = SoftKeyboardType.DEFAULT;
		private var _returnKeyLabel:String = ReturnKeyLabel.DEFAULT;
		
		/** Use localToGlobal option is form field is in nested DisplayObject **/
		private var _useLocalToGlobal:Boolean = true;
		
		/** If display size of app is set for non-retina display (i.e. 1024 x 768,
		 * all StageText size and position properties need to be doubled for IOS retina.
		 */
		private var _compensateForRetina:Boolean = false;
		
		//private var _deviceType:String;
		
		public function MobileTextObjectModel() {
			super();
		}
		
		protected function init(evt:Event = null):void {
			
		}
		
		/**
		 * Name of object for identifying by descriptive String name.
		 */
		public override function get name():String {
			return this._name;
		}
		
		public override function set name(p_name:String):void {
			this._name = p_name;
		}
		
		/**
		 * StageText object for internal use in class.
		 */
		protected function get stageText():StageText {
			return this._stageText;
		}
		
		protected function set stageText(p_stageText:StageText):void {
			this._stageText 					= p_stageText;
			this._stageText.softKeyboardType 	= this._softKeyboardType;
			this._stageText.returnKeyLabel 		= this._returnKeyLabel;
		}
		
		/**
		 * Set whether or not text field has background.
		 * @return
		 */
		public function get hasBackground():Boolean {
			return this._hasBackground;
		}
		
		public function set hasBackground(p_hasBackground:Boolean):void {
			this._hasBackground = p_hasBackground;
		}
		
		/**
		 * Background Sprite drawn internall or set externally.
		 */
		public function get backgroundSprite():Sprite {
			return this._backgroundSprite;
		}
		
		public function set backgroundSprite(p_backgroundSprite:Sprite):void {
			this._backgroundSprite 	= p_backgroundSprite;
			this._hasBackground 	= true;
		}
		
		/**
		 * Background color for text field.
		 * @return
		 */
		public function get backgroundColor():uint {
			return this._backgroundColor;
		}
		
		public function set backgroundColor(p_backgroundColor:uint):void {
			this._backgroundColor 	= p_backgroundColor;
			this._hasBackground 	= true;
		}
		
		/**
		 * Border color for text field background.
		 * @return
		 */
		public function get borderColor():uint {
			return this._borderColor;
		}
		
		public function set borderColor(p_borderColor:uint):void {
			this._borderColor 		= p_borderColor;
			this._hasBackground 	= true;
		}
		
		/**
		 * TextField background stroke thickness.
		 */
		public function get borderThickness():Number {
			return this._borderThickness;
		}
		
		public function set borderThickness(p_borderThickness:Number):void {
			this._borderThickness = p_borderThickness;
		}
		
		/**
		 * text value of StageText object.
		 * @return
		 */
		public function get textValue():String {
			return this._textValue;
		}
		
		public function set textValue(p_textValue:String):void {
			this._textValue = p_textValue;
			this._stageText.text = this._textValue;
		}
		
		/**
		 * Set reference to TextField display object to copy as SrageText object.
		 */
		public function get textFieldToCopy():TextField {
			return this._textFieldToCopy;
		}
		
		public function set textFieldToCopy(p_textFieldToCopy:TextField):void {
			this._textFieldToCopy = p_textFieldToCopy;
		}
		
		/**
		 * Width of TextField.
		 */
		public function get textFieldWidth():Number {
			return this._textFieldWidth;
		}
		
		public function set textFieldWidth(p_textFieldWidth:Number):void {
			this._textFieldWidth = p_textFieldWidth;
		}
		
		/**
		 * Width of TextField.
		 */
		public function get textFieldHeight():Number {
			return this._textFieldHeight;
		}
		
		public function set textFieldHeight(p_textFieldHeight:Number):void {
			this._textFieldHeight = p_textFieldHeight;
		}
		
		/**
		 * SoftKeyBoardType to use for StageText field.
		 */
		public function set softKeyboardType(p_softKeyboardType:String):void {
			this._softKeyboardType = p_softKeyboardType;
		}
											 
		/**
		 * Return key label on keyboard for StageText field.
		 */
		public function set returnKeyLabel(p_returnKeyLabel:String):void {
			this._returnKeyLabel = p_returnKeyLabel;
		}
		
		/** 
		 * Use localToGlobal option is form field is in nested DisplayObject 
		 */
		public function get useLocalToGlobal():Boolean {
			return this._useLocalToGlobal;
		}
		
		public function set useLocalToGlobal(p_useLocalToGlobal:Boolean):void {
			this._useLocalToGlobal = p_useLocalToGlobal;
		}
		
		/** If display size of app is set for non-retina display (i.e. 1024 x 768,
		 * all StageText size and position properties need to be doubled for IOS retina.
		 */
		public function get compensateForRetina():Boolean {
			return this._compensateForRetina;
		}
		
		public function set compensateForRetina(p_compensateForRetina:Boolean):void {
			this._compensateForRetina = p_compensateForRetina;
		}
		
	}
}