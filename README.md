FireTongue
==========

This is a fork of the FireTongue localization library.
It implements a different way of handling plurals to make life easier for programmers and translators, especially when dealing with target languages that have complex numerical system.

Defining plurals
--
*(For the full documentation, please refer to the [original repository](https://github.com/larsiusprime/firetongue).*
	
To the translator, a string containing a variable will look something like this:
	
```tsv
	$STR	Give me <X> fish!
```

If a different plural Form of the noun is needed, several strings have to be defined:
	
```tsv
	$STR	Give me <X> beer!
	$STR_PL	Give me <Y> beers!
```	
	
This creates more work for programmers, who have to write code that takes the number of items into account, and for the translator, who have to take care of two strings that are almost the same.

However, now you can simply do this:
	
```tsv
	$STR	Give me <X> {beer, beers}!
```

If you add curly brackets with the singular and plural form of the noun, the `flag` function in `Replace.hx` will automatically pick the right form depending on the number.

##Advanced usage##

But what if you are working in a target language with a more complex numeral system? Scottish Gaelic for example uses the Dual. This is handled by adding a number to the forms:
	
```tsv
	$STR	<X> {1:cù, 2:chù , 3:coin }
```

If the variable value is higher than the values given in the string, the highest value is used (so if <X> equals 4, *coin* would be used).

For even more complex cases, like in Polish, ranges of numbers can be specified:

```tsv
	$STR	<X> {1:kot, 2-4:koty, 5-21:kotów }
```

