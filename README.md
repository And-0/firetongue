FireTongue
==========

This is a fork of the FireTongue localization library.
It implements a different way of handling plurals to make life easier for programmers and translators, especially when dealing with target languages that have complex numerical system.

Defining plurals
--
*(For the full documentation, please refer to the [original repository](https://github.com/larsiusprime/firetongue).)*
	
To the translator, a string containing a variable will look something like this:
	
```tsv
	$STR	Give me <X> fish!
```

If a different plural Form of the noun is needed, you'd have to define multiple strings:
	
```tsv
	$STR	Give me <X> beer!
	$STR_PL	Give me <X> beers!
```	
	
This creates more work for programmers, who have to write code that takes the number of items into account, and for the translators, who have to take care of two strings that are almost the same.

However, now you can simply do this:
	
```tsv
	$STR	Give me <X> {beer, beers}!
```

If you add curly brackets with the singular and plural form of the noun, the `flag` function in `Replace.hx` will automatically pick the right form depending on whether the noun needs to be in singular or plural.

##Advanced usage##

But what if you are working in a target language with a more complex numeral system? Scottish Gaelic for example uses the Dual. This is handled by adding a number followed by a colon to the forms:
	
```tsv
	$STR	<X> {1:cù, 2:chù , 3:coin }
```
Optionally, `n` can be used to set a default form to be used if the variable value doesn't match any of the given numbers. In the following example, any value other than 1 and 2 will use the form "coin":

```tsv
	$STR	<X> {1:cù, 2:chù , n:coin }
```

If `n` is not defined and the variable value does not match a form, either the lowest or highest form is used, depending on which is closer to the value;
So you would get 0 cù and 12 coin, for example.

Finally, for even more complex cases like in Polish, ranges of numbers can be specified:

```tsv
	$STR	<X> {1:kot, 2-4:koty, 5-21:kotów }
```

Again, `n` can be used to catch all values that don't have a better match.