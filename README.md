# OpenSCAD Functional Programming Utilities

This library is a collection of [OpenSCAD](http://www.openscad.org) functions for use with OpenSCAD **[function-literals](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/User-Defined_Functions_and_Modules#Function_Literals)**.

It is meant to provide algorithms and tools to help build efficient scripts using functional programming techniques in OpenSCAD.

This was started as somewhat of an experiment or coding exercise to see how well various general algorithms could be implemented and built upon in the OpenSCAD language.  The [C++ standard algorithms library](https://en.cppreference.com/w/cpp/algorithm) was chosen as a model for most of **funcutils** API.  An attempt was made to support as much of the C++ API as possible, although due to language differences some of these functions may be decidedly less useful or practical within OpenSCAD.

In addition to <a href="#std_algorithm">std_algorithm.scad</a>, various other utilities have been provided which the authors felt were particularly useful for OpenSCAD.

:warning: - Only [OpenSCAD Release 2021.01](http://openscad.org/news.html#20210131) or later has builtin support for function-literals.

:information_source: - Prior to release 2021.01, function-literals were available as an **experimental feature**, accessible from [Development Snapshots](http://www.openscad.org/downloads.html#snapshots) and Nightly Builds.
  - Such builds must be newer than **Oct. 23 2019** when **function-literals** was merged into OpenSCAD master.
  - If build is from sources between 2019.10.23 and 2021.01 Release, then the feature must be enabled within OpenSCAD by checking the option under **Preferences -> Features -> function-literals**.
  - If built from sources from the above date range, then experimental features must be enabled in the build config e.g.: `cmake -DEXPERIMENTAL=ON  [...]`  (pre-built Development Snapshots and Nightlies from OpenSCAD  all have this configuration enabled)

## General Usage

In order to pass functions as values, function literals are declared slightly differently than "traditional" OpenSCAD functions, so that they exist as an *assignment* in OpenSCAD's variable namespace.

 - function literal: `foo = function(x) x + 1337;`
 - vs traditional function: `function foo(x) = x + 1337;`

:warning: Important note for including files which define function literals: 
 - function literal declarations **_are_ variable assignments**, and `use <filename>` **does not evaluate assignments**.
 - Therefore `include <filename>` **should be used instead**, for files from this library.

Currently OpenSCAD's builtin functions are not available directly as literals (this might change in future), but can be wrapped in anonymous functions for passing into higher-order functions.

Example:
```
echo(filter([1,[],2,3,4,5,undef,"no"], function(x) is_num(x))); // result: [1,2,3,4,5]
```

## API Reference 

### Library Files
 - <a href="#funcutils">funcutils.scad</a>
   - Main file to include *all* other files in this library
 - <a href="#func">func.scad</a>
   - Minimal collection of common higher-order functions: `map`, `filter`, `fold`
 - <a href="#ops">ops.scad</a>
   - Elementary function literals for comparison, arithmetic and boolean value operations.
 - <a href="#std_algorithm">std_algorithm.scad</a>
   - Functions modeled after [C++ Algorithms](https://en.cppreference.com/w/cpp/algorithm) standard library, mostly operating on ranges of sequences (lists/vectors or strings)
 - <a href="#list">list.scad</a>
   - Various list-based functions which are *not* directly modeled after C++ STL algorithms.
 - <a href="#math">math.scad</a>
   - Mathematical functions which are *not* directly modeled after C++ STL algorithms.
 - <a href="#string">string.scad</a>
   - String specific functions
 - <a href="#types">types.scad</a>
   - Extra type checking functions for which no OpenSCAD buitin exists.

## Dependency / Include Tree

:warning: - Individual library files already `include <...>` their own dependencies.
To avoid duplicate definitions, do not manually include any more-deeply-nested dependencies than the outermost one(s) you choose.
So, if including top-level `functils.scad`, then do not include *any* others.

 - [funcutils.scad](#funcutils)
   - [list.scad](#list)
     - [types.scad](#types)
     - [std_algorithm.scad](#std_algorithm)
       - [ops.scad](#ops)
     - [math.scad](#math)
   - [func.scad](#func)
   - [string.scad](#string)

<a name="funcutils"></a>
# funcutils.scad
**Top level file, existing only to include all others.  No function definitions in itself.**

<a name="ops"></a>
# ops.scad
**Elementary Operators**

###  Comparators
 - `eq (x, y)`
   - Equal
 - `ne (x, y)`
   - Not Equal
 - `lt (x, y)`
   - Less Than
 - `gt (x, y)`
   - Greater Than
 - `le (x, y)`
   - Less than or Equal
 - `ge (x, y)`
   - Greater than or Equal

### Arithmetic unary ops
 - `ident (x)`
   - Identity function (returns x unchanged)
 - `neg (x)`
   - Negation

### Arithmetic binary ops
 - `add (x, y)`
   - Addition
 - `sub (x, y)`
   - Subtraction
 - `mul (x, y)`
   - Multiplication
 - `div (x, y)`
   - Division
 - `rem (x, y)`
   - Remainder (`x % y`)
 - <a name="mod"></a>`mod (x, y)`
   - Modulo operator.  Unlike remainder, always returns non-negative value in range: `[0,y)`

### Boolean unary op
 - `not (x)`
   - NOT

### Boolean binary ops
 - `and (x, y)`
   - AND
 - `or (x, y)`
   - OR
 - `xor (x, y)`
   - XOR
 - `nand (x, y)`
   - NAND
 - `nor (x, y)`
   - NOR
 - `xnor (x, y)`
   - XNOR

<a name="list"></a>
# list.scad
**Various list-based functions which are *not* directly modeled after C++ STL algorithms.**

 - `clamp_range (v, begin, step, end)`
   - Return a range with `begin` (inclusive) and `end` (exclusive) clamped between `0` and `len(v)`.
   - Allows negative values to wrap but *only once* (`-1` becomes index of last element, and values less than `-len(v)` clamp to `0`).
   - mainly for use by [slice](#slice) function
 - `def (x, default)`
   - return `x`, or `default` if `x` undefined
 - `get (v, i)`
   - get element from `v` with wrapping, using index [mod](#mod)(i,len(v))
 - `insert (v, x, i)`
   - insert element `x` into `v` at index `i`
 - `insertv (v, i, xs)`
   - insert vector of elements `xs` into `v` at index `i` 
 - `insert_sorted (v, x, cmp=lt)`
   - insert `x` into sorted vector `v`
 - `insertv_sorted (v, xs, cmp=lt)`
   - insert vector `xs` into sorted vector `v`
   - `xs` does not need to be sorted
```
echo(insertv_sorted([1,2,3,5,5,8,12],[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1]));
echo(insertv_sorted([],[for (x=rands(0,10000,10000)) floor(x)]));
```
 - `replace_range (v, range, xs)`
   - replace elements of `v` in range with elements from vector `xs`
   - `range` is vec2 containing `[begin,end)` indices.
   - `xs` does not need to be same length as range
 - `rotl (v, l=1)`
   - Rotate elements in vector `v`, by `l` positions to the left.
 - `rotr (v, l=1)`
   - Rotate elements in vector `v`, by `l` positions to the right.
 - `sublist (s, b=0, e)`
   - Extract sub-list given `begin` (inclusive) and `end` (exclusive). If `end` not specified, go to end of list
 - <a name="slice"></a>`slice (v, begin, step, end, range)`
   - slice vector `v`, similar to Python's builtin [slice](https://docs.python.org/3.3/library/functions.html#slice) function or [extended indexing syntax](https://docs.python.org/3.3/library/stdtypes.html#common-sequence-operations).
   - all params after `v` are optional
   - `range` param overrides others
   -  unnamed range may be optionally positioned in place of `begin`
 - `parse_array (s)`
   - parse a string into a multidimensional array containing floats.
   - throws an assertion if the string can't be parsed
   - whitespace characters (whitespace, newline, tab) are ignored
```
echo(parse_array("[1,2,3]));
echo(parse_array("[]"));
echo(parse_array("[[2.3]]"));
echo(parse_array("[4.5, [2, 1], 3.2]"));
```

<a name="std_algorithm"></a>
# std_algorithm.scad
**Functions modeled after [C++ STL Algorithms](https://en.cppreference.com/w/cpp/algorithm) (incomplete, see [std algorithm status](std_algorithm_status.md) for details)**

:information_source: Where C++ uses `first` and `last` *iterators* for most of the following functions, OpenSCAD uses *indices* of the same name.  This results in some differences between function signatures including:
 - `v` (for "vector", but may also be a string) is always the first parameter for such OpenSCAD functions
 - `first=0` is default when omitted
 - `last=len(v)` is default when omitted
   - default parameter values cannot depend on previous parameters being initialized in order, so documented function signatures don't explicitely show `last=len(v)`,
   but it is set within the function body via [end (v, last)](#end)
 - In some cases, the OpenSCAD version of functions have parameters in a different order than C++
   - For example C++'s `std::find(first, last, value);` is `find(v, value, first, last)` in OpenSCAD.  `value` comes before `first` and `last` since they can be reasonably defaulted, when `value` can't.

### Non-modifying sequence operations 

 - <a name="end"></a>`end (v,last)`  (ref: [std::end](https://en.cppreference.com/w/cpp/iterator/end), loosely based)
   - return `last`, OR length of `v` if `last` not defined.
 - `find_if (v, first=0, last, p)` (ref: [std::find_if](https://en.cppreference.com/w/cpp/algorithm/find))
  - return index of first element in range `[first,last)` which matches predicate `p`, or `last` if none found.
 - `find_if_not (v, first=0, last, p)` (ref: [std::find_if_not](https://en.cppreference.com/w/cpp/algorithm/find))
  - return index of first element in range `[first,last)` which does *not* match predicate `p`, or `last` if none found.
 - `find (v, value, first=0, last, cmp=eq)` (ref: [std::find](https://en.cppreference.com/w/cpp/algorithm/find))
   - return index of first element in range `[first,last)` equivalent to `value`, or `last` if none found.
```
v=[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1];
echo(find(v,-8));
echo(find(v,-1));
echo(find(v,undef));
echo(find([0],0));
echo(find([0],1));
echo(find([],undef));
```
 - `all_of (v, first=0, last, p)` (ref: [std::all_of](https://en.cppreference.com/w/cpp/algorithm/all_any_none_of))
   - Checks if unary predicate `p` returns `true` for all elements in the range `[first, last)`. 
 - `any_of (v, first=0, last, p)` (ref: [std::any_of](https://en.cppreference.com/w/cpp/algorithm/all_any_none_of))
   - Checks if unary predicate `p` returns `true` for at least one element in the range `[first, last)`. 
 - `none_of (v,first=0,last,p)` (ref: [std::none_of](https://en.cppreference.com/w/cpp/algorithm/all_any_none_of))
   - Checks if unary predicate `p` returns `true` for no elements in the range `[first, last)`. 
```
for(v=[ [], [0,1,2,3], [0,1,2,3,0/0], [[],false,true,"ok"] ]) let(p=function(x)is_num(x)) {
  if (all_of(v,p=p)) echo(str("all_of(",v,",is_num) = true"));
  if (any_of(v,p=p)) echo(str("any_of(",v,",is_num) = true"));
  if (none_of(v,p=p)) echo(str("none_of(",v,",is_num) = true"));
}
```
 - `contains (v, value, first, last, cmp=eq)`
   - No direct analogue in C++ STL, but a variation of `std::find` returning bool, or loosely based on [std::map::contains](https://en.cppreference.com/w/cpp/container/map/contains)
   - return `true` if any element in range `[first,last)` is equivalent to `value`
```
echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],3.14));
echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],-1));
```

 - `count (v, value, first=0, last, cmp=eq)` ref: [std::count](https://en.cppreference.com/w/cpp/algorithm/count)
   - return the number of elements in the range `[first, last)` equal to `value`
 - `count_if (v, p, first=0, last)` ref: [std::count_if](https://en.cppreference.com/w/cpp/algorithm/count)
   - return the number of elements in the range `[first, last)` for which predicate `p` returns `true`
 - `mismatch (v1, first1=0, last1, v2, first2=0, last2, cmp=eq)` ref: [std::mismatch](https://en.cppreference.com/w/cpp/algorithm/mismatch)
   - return pair of indices `[i1,i2]` to the first two non-equal elements.
   - if no mismatches are found when the comparison reaches `last1` or `last2`, whichever happens first, the pair holds the end index and the corresponding index from the other range.
```
echo(count("this is a test","t"));
echo(count_if([1,2,3,4,5,6,7,8,9,10],p=function(x)x>3));
echo(mismatch(v1="oh! hi, how are you?",first1=4,v2="hi, how's it going?"));// [11, 7]
echo(mismatch(v1="Hello World",v2="Hello World"));// [11, 11]
echo(mismatch(v1="Hello!",v2="Hello"));           // [5, 5]
echo(mismatch(v1="l",v2="Hello",first2=3));       // [1, 4]
```


### Modifying sequence operations

 - `remove(v,first=0,last)` ref: [std::remove](https://en.cppreference.com/w/cpp/algorithm/remove)
   - remove range of elements [first,last) from list
 - `remove_if(v,first=0,last,p)` ref: [std::remove_if](https://en.cppreference.com/w/cpp/algorithm/remove)
   - remove elements from range which match predicate
```
echo(remove([0,1,2,3,4,5,6,7,8,9],3,7));
echo(remove([0,1,2,3,4,5,6,7,8,9]));
echo(remove_if([0,1,2,3,4,5,6,7,8,9],p=function(x)x%3==0));
```
 - `replace (v, old_value, new_value, first=0, last, cmp=eq)` ref: [std::replace](https://en.cppreference.com/w/cpp/algorithm/replace)
   - Replaces all elements that are equivalent to `old_value` with `new_value`, in the range `[first, last)`.
 - `replace_if (v, new_value, first=0, last, p)` ref: [std::replace_if](https://en.cppreference.com/w/cpp/algorithm/replace)
   - Replaces all elements for which predicate `p` returns `true`, with `new_value`, in the range `[first, last)`.
```
echo(replace([0,1,2,3,1,4,5,6,1,7,8,1,9],1,[]));
echo(replace_if([0,1,2,3,1,4,5,6,1,7,8,1,9],0,p=function(x)x<5));
```
 - `reverse (v, first=0, last)` ref: [std::reverse](https://en.cppreference.com/w/cpp/algorithm/reverse)
   - Reverse a range of elements
```
echo(reverse([0,1,2,3,4,5,6,7,8,9]));
echo(reverse([0,1,2,3,4,5,6,7,8,9],3,7));
```
 - `std_rotate (v, first=0, first_n, last)` ref: [std::rotate](https://en.cppreference.com/w/cpp/algorithm/rotate)
   - Reorders elements in the range [first,last) such that sub-ranges:
     - [first_n, last) moves to the beginning of the range, and
     - [first, first_n) moves to end of the range.
```
// move elements [3,7) to position 12: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=630
echo(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,7,12)); 
// move elements [8,12) to position 3: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=645
echo(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,8,12)); 
```
 - `unique (v, first=0, last, cmp=eq)` ref: [std::unique](https://en.cppreference.com/w/cpp/algorithm/unique)
   - Removes all but the first element from every group of consecutive equivalent elements in range `[first,last)`.
   - `v` should be pre-sorted if uniqueness across entire vector is desired.
```
echo(unique(insertv_sorted([],[1,2,3,1,2,3,3,4,5,4,5,6,7])));
```

### Partitioning operations

 - `stable_partition (v, first=0, last, p)` ref: [std::stable_partition](https://en.cppreference.com/w/cpp/algorithm/stable_partition)
   - Reorders the elements in the range `[first, last)` in such a way that all elements for which the predicate `p` returns `true` precede the elements for which predicate `p` returns `false`. 
   - Relative order of the elements is preserved.
```
is_even = function(x)x%2==0;
echo(stable_partition([0,1,2,3,4,5,6,7,8,9],p=is_even));
```

### Sorting operations
 - None yet implemented

### Binary search operations (on sorted ranges)
 - `upper_bound (v, value, first=0, last=undef, cmp=lt)`  ref: [std::upper_bound](https://en.cppreference.com/w/cpp/algorithm/upper_bound)
   - return index of first element in range `[first,last)` which is greater than `value`.
 - `lower_bound (v, value, first=0, last=undef, cmp=lt)` ref: [std::lower_bound](https://en.cppreference.com/w/cpp/algorithm/lower_bound)
   - return index of first element in range `[first,last)` which is *not less* than `value`.
 - `binary_search (v, value, first=0, last=undef, cmp=lt)` ref: [std::binary_search](https://en.cppreference.com/w/cpp/algorithm/binary_search)
   -  return `true` if range `[first,last)` contains `value`.
```
v = [1, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6];
echo(sublist(v,lower_bound(v,4),upper_bound(v,4)));
echo(binary_search([1,2,3,5,5,8,12],3));
```

### Mininum/maximum operations

 - `max (a, b, cmp=lt)` ref: [std::max](https://en.cppreference.com/w/cpp/algorithm/max)
   - return the greater of the two values.  if equivalent, return `a` 
   - overrides `max` builtin function, but with customizable comparator
 - `max_element (v, first=0, last, cmp=lt)` ref: [std::max_element](https://en.cppreference.com/w/cpp/algorithm/max_element)
   - return index of maximum value in range `[first,last)`, or `last` if empty range
 - `min (a, b, cmp=lt)` ref: [std::min](https://en.cppreference.com/w/cpp/algorithm/min)
   - return the lesser of the two values.  if equivalent, return `a` 
   - overrides `min` builtin function, but with customizable comparator
 - `min_element (v, first=0, last, cmp=lt)`  ref: [std::min_element](https://en.cppreference.com/w/cpp/algorithm/max_element)
   - return index of minimum value in range `[first,last)`, or `last` if empty range
 - `minmax (a, b, cmp=lt)`  ref: [std::minmax](https://en.cppreference.com/w/cpp/algorithm/minmax)
   - return `[a,b]` when `a <= b` or `[b,a]` when `a > b`
 - `minmax_element (v, first=0, last, cmp=lt)`  ref: [std::minmax_element](https://en.cppreference.com/w/cpp/algorithm/minmax_element)
   - return pair of indices `[i,j]` where `v[i]` is minimum element and `v[j]` is maximum in range `[first,last)`, OR `[last,last]` if empty range
   - if multiple elements are equivalent to the minimum, return first such index for `i`
   - if multiple elements are equivalent to the maximum, return last such index for `j`
 - `clamp(x,lo,hi,cmp=lt)` ref [std::clamp](https://en.cppreference.com/w/cpp/algorithm/clamp)
   - return `lo` if `x` is less than `lo`, or to `hi` if `hi` is less than `x`, otherwise `x`
```
// Example compare by index
echo(max([100,1],[-100,2],function(a,b) a[0]<b[0])); // [100,1]
echo(max([100,1],[-100,2],function(a,b) a[1]<b[1])); // [-100,2]
echo(min([100,1],[-100,2],function(a,b) a[0]<b[0])); // [-100,2]
echo(min([100,1],[-100,2],function(a,b) a[1]<b[1])); // [100,1]
// return first when "equivalent"
echo(max([1,2,3],[3,2,1],function(a,b) a[1]<b[1])); // [1,2,3] 
echo(min([1,2,3],[3,2,1],function(a,b) a[1]<b[1])); // [1,2,3]

v= [0,1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2,1,0,9];
echo(min_element(v));    // 0
echo(min_element(v,10)); // 18
echo(max_element(v));    // 9
echo(max_element(v,10)); // 19

lencmp = function (a,b) len(a) < len(b);
echo(minmax("World!","Hello",lencmp)); // ["Hello", "World!"]
echo(minmax("Hello","World!",lencmp)); // ["Hello", "World!"]
// [a,b] stay in-order when equivalent
echo(minmax("Hello","World",lencmp));  // ["Hello", "World"]
echo(minmax("world","Hello",lencmp));  // ["World", "Hello"]
s = "The quick brown fox jumps over the lazy dog";
x = minmax_element(s);
echo(x,s[x[0]],s[x[1]]); // [3, 37], " ", "z"
```


### Numeric operations

 - `accumulate (v, first=0, last=undef, init=0, op=add)` ref: [std::accumulate](https://en.cppreference.com/w/cpp/algorithm/accumulate)
   - same as "fold" but with optional params for first, last, op (default addition)
```
echo(accumulate([1,2,3,4,5]));
echo(accumulate([1,2,3,4,5],init=1,op=function(x,y)x*y));
```

<a name="string"></a>
# string.scad

**String specific functions**

Strings may be iterated over character by character, and many of the same functions/algorithsm that work on vectors will also "work" on strings.
However the value returned is typically a vector of single-character strings, when what is expected is a single string.
This is why string-specific functions have their own place here.

- `substr (s, b, e)`
   - extract substring given begin(inclusive) and end(exclusive)
   - if end not specified, go to end of string 
 - `join (strs, delimiter="")`
   - converts a vector of values into a single string, with optional delimiter between elements
   - uses efficient binary tree based join, where depth of recursion is `log_2(len(strs))`.
 - `fixed (x, w, p, sp="0")`
   - format number `x` as string with fixed width `w` and precision `p`.

<a name="types"></a>
# types.scad
**Extra type checking functions for which no OpenSCAD buitin exists.**

 - `is_range (x)`
   - return true only if x is a range object
 - `is_nan (x)`
   - return true only if x is the [nan](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/General#Numbers) value
 - `has_nan (x)`
   - return true only if x is a list containing [nan](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/General#Numbers), or is itself [nan](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/General#Numbers)
 - `has_function (v)`
   - return true only if x is a list containing a function
```
for (
  x=[undef,1/0,-1/0,0/0,[],[1,2,3],[1,0/0,2],[1,function(x)x,2],[1,function(x)x,0/0,2],
    "hi!","",function(x)x,true,false,0,1,-1,[0:-10],[0:1:10],[0:0:0],[0:1:2]]
  ) {
  if (is_nan(x)) echo(str("is_nan(",x,") = true"));
  if (has_nan(x)) echo(str("has_nan(",x,") = true"));
  if (has_function(x)) echo(str("has_function(",x,") = true"));
  if (is_range(x)) echo(str("is_range(",x,") = true"));
}
```
