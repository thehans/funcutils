/* Additional type checkers */

/* 
Builtin type checking functions:
 - is_bool
 - is_function
 - is_list
 - is_num       true for all "numeric" type values except nan (eg. 0/0)
 - is_string
 - is_undef

Notes:
 - Can't redefine builtin functions as literals with same name
 - Recommended to wrap builtins in anonymous functions if needed
     BAD:  is_bool = function (x) is_bool(x); // Infinite recursion!
     GOOD: some_higher_order_f(x, function(x) is_bool(x) )
*/

is_range = function (x) !is_list(x) && !is_string(x) && !is_undef(x[0]);
is_nan = function (x) !is_function(x) && !is_list(x) && x!=x;
has_nan = function (x) !is_function(x) && (let(x=filter(x, function(e) !is_function(e))) x!=x);
has_function = function(v) is_list(v) && fold(false, v, function(i, x)i||is_function(x));
