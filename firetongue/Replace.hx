/**
 * Copyright (c) 2013 Level Up Labs, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

package firetongue;

import flash.display.Sprite;

class Replace
{
	/**
	 * Simple class to do variable replacements for localization
	 * 
	 * USAGE:
		 * var str:String = fire_tongue.get("$GOT_X_GOLD"); //str now = "You got <X> gold coins!"
		 * str = Replace.flags(str,["<X>"],[num_coins]);	//num_coins = "10"
		 * 
		 * //str now = "You got 10 gold coins!"
	 * 
	 * This method is preferably to schemes that do this:
	 * (str = "You got" + num_coins + " gold coins!")
	 *  
	 * Even if you translate the sentence fragments, each language has
	 * its own unique word order and sentence structure, so trying to embed
	 * that in code is a lost cuase. It's better to just let the translator 
	 * specify where the variable should fall, and replace it accordingly. 
	 */
	
	public function new ()
	{
		//does nothing
	}
	//Formating: "Give me <X> {1:Beer, 2:Beers}"
	public static function flags(string:String, flags:Array<String>, values:Array<String>):String
	{
		trace("Called flags");
		//var reg:EReg = ~/\{.*\}/;
		var j:Int = 0;
		while (j < flags.length)
		{
			var flag = flags[j];
			var value = values[j];
			var flagSize:Int = flag.length;
			var temp = stringToRegex(flag);
			trace("TEMP: " + temp);
			var reg:EReg = new EReg(temp+"\\s?\\{([^\\}]*)\\}", "g");//matches the corresponding curly braces
			while (string.indexOf(flag) != -1)//While there is still a placeholder
			{
				//If curly braces follow...
				if (reg.match(string)){//Just check the next position for {
					//...grab the contents
					var m:String = reg.matched(0).substring(reg.matched(0).lastIndexOf("{"));//grabs the braces
					var sub = reg.matched(1);//The contents of the braces
					var arr = ~/\s?,\s?/g.split(sub);//Split the string into an array, using regex to account for spaces
					var s:String = "";
					//Are numbers provided?
					if (~/[0-9]+/.match(arr[0])){
						for (v in arr){
							var n:String = v.substring(0, v.indexOf(":"));//The numeric expression (ex. 1 or 2-5)
							trace("N  " + n);
							//Is range?
							if (n.indexOf("-") != -1){
								var b:Int = Std.parseInt(n.substring(0, n.indexOf("-")));
								var e:Int = 1+Std.parseInt(n.substring(n.indexOf("-")+1));
								for (i in b...e){
									if (Std.string(i) == value){
										s = v.substring(v.indexOf(":") + 1);
									}
								}
							} else{//If not a range
								if (n == Std.string(value)){
									s = v.substring(2);
								}
							}
							//If no match was found, use the smallest/largest value
							if (s == ""){
								if (Std.parseInt(value) < Std.parseInt(arr[0])){
									var r:String = arr[0];
									s = r.substring(r.indexOf(":")+1);
								} else{
									var r:String = arr[arr.length - 1];
									s = r.substring(r.indexOf(":")+1);
								}
								
							}
						}
					} else{//If no numbers are provided, assume binary singular/plural
						if (arr.length < 2){
							s = "NOT_ENOUGH_NUMBER_FORMS";
						} else{
							s = (value == "1") ? arr[0] : arr[1];
						}
					}
					string = StringTools.replace(string, m, s);
				}//Always replace the variable
				string = StringTools.replace(string, flag, value);
			}
			j++;
		}
		return string;
	}
	
	private static function stringToRegex(str:String):String{
		str = StringTools.replace(str, "\\", "\\\\");
		str = StringTools.replace(str, "[","\\[");
		str = StringTools.replace(str, "]", "\\]");
		return str;
	}
}