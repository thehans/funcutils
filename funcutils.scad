// Common higher-order functions

map = function (v, f) [for(x=v) f(x)];
// Ex:
//echo(map([1,2,3,4,5,6,7],function(x)x^2));

filter = function (v, pred) [for(x=v) if(pred(x)) x]; 
// Ex:
//echo(filter([-2,-1,0,1,2,3,4,5,6,7,8,9],function(x)mod(x,2)==1));

fold = function (i, v, f, off = 0) len(v) > off ? fold(f(i, v[off]), v, f, off + 1) : i;


// Basic operators for functions below
//  not sure if commented ones are worth cluttering namespace

// Comparators
eq = function (x,y) x==y;
//ne = function (x,y) x!=y;
lt = function (x,y) x<y;
//gt = function (x,y) x>y;
//le = function (x,y) x<=y;
//ge = function (x,y) x>=y;

// Arithmetic
//ident = function(x) x;
add = function (x,y) x+y;
//sub = function (x,y) x-y;
//mul = function (x,y) x*y;
//div = function (x,y) x/y;
//rem = function (x,y) x%y;
//  return (x modulo y) in range: [0,y-1], always non-negative
mod = function (x,y) let(r=x%y) r<0 ? r+abs(y) : r;

// Boolean
//not  = function (x) !x;
//and  = function (x,y) x&&y;
//or   = function (x,y) x||y;
//xor  = function (x,y) (x||y) && !(x&&y);
//nand = function (x,y) !(x&&y);
//nor  = function (x,y) !(x||y);
//xnor = function (x,y) (x&&y) || ((!x)&&(!y)); 


/* Misc utility functions */
// default value
//def = function (x,default) is_undef(x)?default:x;
// get element from v with wrapping
get = function (v,i) v[mod(i,len(v))];
// limit range of values for x between lo and hi
clamp = function (x,lo,hi) x<lo ? lo : (x>hi ? hi : x);

/* Extra type checks */
// return true only if x is a range object
is_range = function (x) !is_list(x) && !is_string(x) && !is_undef(x[0]);
// return true only if x is the nan value
is_nan = function (x) !is_function(x) && !is_list(x) && x!=x;
// return true only if x is a list containing nan, or is itself nan
has_nan = function (x) !is_function(x) && (let(x=filter(x, function(e) !is_function(e))) x!=x);
// return true only if x is a list containing a function
has_function = function(v) is_list(v) && fold(false, v, function(i, x)i||is_function(x));
// Ex:
/*
for (x=[undef,1/0,-1/0,0/0,[],[1,2,3],[1,0/0,2],[1,function(x)x,2],[1,function(x)x,0/0,2],"hi!","",function(x)x,true,false,0,1,-1,[0:-10],[0:1:10],[0:0:0],[0:1:2]]) {
  if (is_nan(x)) echo(str("is_nan(",x,") = true"));
  if (has_nan(x)) echo(str("has_nan(",x,") = true"));
  if (has_function(x)) echo(str("has_function(",x,") = true"));
  if (is_range(x)) echo(str("is_range(",x,") = true"));
}
//*/


// *** C++ STL-inspired algorithms, using closest approximate interface where possible ***

// Loosely based on: https://en.cppreference.com/w/cpp/iterator/end
//   return last OR length of v if last not defined
//     used to for getting default "end iterator" in STL-like functions
end = function (v,last) is_undef(last) ? len(v) : last;

// Based on: https://en.cppreference.com/w/cpp/algorithm/find
// return index of first element which matches value or predicate p
//        or last if not found.
find_if = function (v,first=0,last,p)
  let(l=end(v,last), f=function (i) (i>=l || p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);
find_if_not = function (v,first=0,last,p)
  let(l=end(v,last), f=function (i) (i>=l || !p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);
find = function(v, value, first=0, last, cmp=eq)
  find_if(v,first,last,function(x)cmp(value,x));

// Ex:
//v=[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1];
//echo(find(v,-8));
//echo(find(v,-1));
//echo(find(v,undef));
//echo(find([0],0));
//echo(find([0],1));
//echo(find([],undef));

// Based on: https://en.cppreference.com/w/cpp/algorithm/all_any_none_of
all_of = function (v,first=0,last,p) let(l=end(v,last)) find_if_not(v,first,l,p)==l;
any_of = function (v,first=0,last,p) let(l=end(v,last)) find_if(v,first,l,p)!=l;
none_of = function (v,first=0,last,p) let(l=end(v,last)) find_if(v,first,l,p)==l;
// Ex:
/*
for(v=[ [], [0,1,2,3], [0,1,2,3,0/0], [[],false,true,"ok"] ]) let(p=function(x)is_num(x)) {
  if (all_of(v,p=p)) echo(str("all_of(",v,",is_num) = true"));
  if (any_of(v,p=p)) echo(str("any_of(",v,",is_num) = true"));
  if (none_of(v,p=p)) echo(str("none_of(",v,",is_num) = true"));
}
//*/

// Not a direct analogue in STL, 
// but a variation of std::find, or loosely based on: https://en.cppreference.com/w/cpp/container/map/contains
// return true if any element in v is equivalent to value
contains = function (v,value,first,last,cmp=eq) let(l=end(v,last)) find(v,value,first,l,cmp)!=l;
// Ex:
//echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],3.14));
//echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],-1));


// Based on: https://en.cppreference.com/w/cpp/algorithm/accumulate
//  same as "fold" but with optional params for first, last, op (default addition)
accumulate = function (v, first=0, last=undef, init=0, op=add)
  let(l=end(v,last), a = function(f,acc) f<l ? a(f+1,op(acc,v[f])) : acc)
  a(first,init);
// Ex:
//echo(accumulate([1,2,3,4,5]));
//echo(accumulate([1,2,3,4,5],init=1,op=function(x,y)x*y));

// Based on: https://en.cppreference.com/w/cpp/algorithm/upper_bound
// return index of first element in v which is greater than the value
upper_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(ub = function(b,e)
      let(m=floor((b+e)/2)) e-b > 1 ?
        cmp(value,v[m]) ? ub(b,m) : ub(m,e) :
        cmp(value,v[m]) ? m : e) 
  ub(first,end(v,last));

// Based on: https://en.cppreference.com/w/cpp/algorithm/lower_bound
// return index of first element in v which is *not less* than the value
lower_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(lb = function(b,e) //echo(v,x,b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(v[m],value) ? lb(m,e) : lb(b,m) :
      cmp(v[m],value) ? e : m) 
  lb(first, end(v,last));
// Ex:
//v = [1, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6];
//echo(sublist(v,lower_bound(v,4),upper_bound(v,4)));


// Based on: https://en.cppreference.com/w/cpp/algorithm/binary_search
// return true if sorted vector contains value
binary_search = function (v, value, first=0, last=undef, cmp=lt)
  let(last = end(v,last), first = lower_bound(v, value, first, last, cmp))
  !(first == last) && !cmp(value, v[first]);
// Ex:
//echo(binary_search([1,2,3,5,5,8,12],3));


// remove range of elements [first,last) from list
remove = function (v,first=0,last) let(l=end(v,last)) [
  for(j=[0:1:first-1]) v[j], 
  for(j=[last:1:len(v)-1]) v[j]
];
// remove elements from range which match predicate
remove_if = function (v,first=0,last,p) let(l=end(v,last)) [
  for(i=[0:1:l-1]) if(!p(v[i])) v[i]];
//echo(remove([0,1,2,3,4,5,6,7,8,9],3,7));
//echo(remove([0,1,2,3,4,5,6,7,8,9]));
//echo(remove_if([0,1,2,3,4,5,6,7,8,9],p=function(x)x%3==0));


// https://en.cppreference.com/w/cpp/algorithm/replace
// replace elements equivalent to old_value with new_value, in range [first,last) 
replace = function (v,old_value,new_value,first=0,last,cmp=eq) let(l=end(v,last))
  [for(i=[first:1:l-1]) cmp(v[i],old_value) ? new_value : v[i] ];
replace_if = function (v,new_value,first=0,last,p) let(l=end(v,last))
  [for(i=[first:1:l-1]) p(v[i]) ? new_value : v[i] ];
//echo(replace([0,1,2,3,1,4,5,6,1,7,8,1,9],1,[]));
//echo(replace_if([0,1,2,3,1,4,5,6,1,7,8,1,9],0,p=function(x)x<5));


// https://en.cppreference.com/w/cpp/algorithm/reverse
// Reverse a range of elements
reverse = function (v,first=0,last) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i],
  for(i=[l-1:-1:first]) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];
//echo(reverse([0,1,2,3,4,5,6,7,8,9]));
//echo(reverse([0,1,2,3,4,5,6,7,8,9],3,7));


// Based on https://en.cppreference.com/w/cpp/algorithm/rotate
// Reorders elements in the range [first,last) such that sub-ranges:
//   [first_n, last) moves to the beginning of the range, and
//   [first, first_n) moves to end of the range.
std_rotate = function(v,first=0,first_n,last) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i], 
  for(i=[first_n:1:l-1]) v[i], 
  for(i=[first:1:first_n-1]) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];
// Ex:
/* move elements [3,7) to position 12: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=630 */
//echo(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,7,12)); 
/* move elements [8,12) to position 3: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=645 */
//echo(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,8,12)); 

// Based on https://en.cppreference.com/w/cpp/algorithm/stable_partition
// Reorders the elements in the range [first, last) in such a way that 
// all elements for which the predicate p returns true precede 
// the elements for which predicate p returns false. 
// Relative order of the elements is preserved.
stable_partition = function(v,first=0,last,p) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i], 
  for(i=[first:1:l-1]) if(p(v[i])) v[i], 
  for(i=[first:1:l-1]) if(!p(v[i])) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];
// Ex:
//is_even = function(x)x%2==0;
//echo(stable_partition([0,1,2,3,4,5,6,7,8,9],p=is_even));

// Based on: https://en.cppreference.com/w/cpp/algorithm/unique
// Removes all but the first element from every group of consecutive equivalent elements.
//   v should be pre-sorted if uniqueness across entire vector is desired.
unique = function(v, first=0, last, cmp=eq) let(l=end(v,last))
  [for(prev=undef, i=first, cur=v[i]; i<l; prev=cur, i=i+1, cur=v[i]) if(!eq(prev,cur)) cur];
// Ex:
//echo(unique(insertv_sorted([],[1,2,3,1,2,3,3,4,5,4,5,6,7])));

  
// *** END STL-specific algorithms ***


// insert x into sorted vector v
insert_sorted = function (v,x,cmp=lt)
  insert(v,x,upper_bound(v,x,cmp=cmp));

// insert vector xs into sorted vector v
//   xs does not need to be sorted
insertv_sorted = function (v,xs,cmp=lt)
  let(l=len(xs))
  [for(temp=v, i=0;
      i<=l;
      temp=i==l ? temp : insert_sorted(temp,xs[i],cmp),i=i+1)
    if(i==l) temp
  ][0];
// Ex:
//echo(insertv_sorted([1,2,3,5,5,8,12],[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1]));
//echo(insertv_sorted([],[for (x=rands(0,10000,10000)) floor(x)]));



// *** Various List manipulation functions (Not higher-order) ***

// insert element x into v at index i
insert = function (v,x,i) [for(j=[0:1:i-1]) v[j], x, for(j=[i:1:len(v)-1]) v[j]];

// insert vector of elements xs into v at index i 
insertv = function (v,i,xs) [for(j=[0:1:i-1]) v[j], for(x=xs) x, for(j=[i:1:len(v)-1]) v[j]];

// replace elements of v in range with elements from vector xs
//    range is vec2 containing [begin,end) indices.
//    xs does not need to be same length as range
replace_range = function (v,range,xs) [for(j=[0:1:range[0]-1]) v[j], for(x=xs) x, for(j=[range[1]+1:1:len(v)-1]) v[j]];

// permutations
rotl = function (v,l=1) let(i0=mod(l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];
rotr = function (v,l=1) let(i0=mod(-l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];

// Extract sub-list given begin(inclusive) and end(exclusive). If end not specified, go to end of list
sublist = function (s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) [for(i=[b:1:e-1]) s[i] ];

// return a range with begin (inclusive) and end (exclusive) clamped based on len(v)
// allows negative values to wrap, but only once.
clamp_range = function (v,begin,step,end)
  let(
    l = len(v),
    s = is_undef(step) ? 1 : assert(step!=0) step,
    b = is_undef(begin) ? (s<0 ? l+max(-1,s) : 0) : clamp(begin<0?begin+l:begin, 0, l),
    // subtract step because slice end is exclusive
    e = is_undef(end) ? (s<0 ? 0 : l-s) : clamp(end<0?end+l:end, 0, l)-s,
    r = [ b : s : e ]
  )
  //echo(str("clamp_range(v,",begin,",",step,",",end,")\tl=",l,"\tr=",r)) // debug
  r;

// slice params after v are optional
//   range param overrides others
//   allow unnamed range to be optionally positioned in place of begin
slice = function (v, begin, step, end, range)
  let(r = is_undef(range) ? begin : range)
  is_range(r) ?
    [for(i=clamp_range(v,r[0],r[1],r[2])) v[i]] :
    [for(i=clamp_range(v,begin,step,end)) v[i]];


// String-specific functions

// extract substring given begin(inclusive) and end(exclusive)
// if end not specified, go to end of string
function substr(s,b,e) = let(e=is_undef(e) || e > len(s) ? len(s) : e) (b==e) ? "" : join([for(i=[b:1:e-1]) s[i] ]);

//function join(strs, delimiter="", i=0) = (i == len(strs)-1) ? strs[i] : str(strs[i], delimiter, join(strs, delimiter, i+1));
// binary tree based join, depth of recursion is log_2(n), rather than (n) for naive join
join = function (l,delimiter="") let(s = len(l)) s > 0 ?
  (delimiter=="" ? _jb(l,0,s) : _jbd(l,delimiter,0,s)):
  "";
// "join binary", splits list into halves and joins them.
// l=list, b=begin(inclusive), e=end(exlusive), s=size, m=midpoint
function _jb(l,b,e) = let(s = e-b, m=floor(b+s/2)) s > 2 ?
  str(_jb(l,b,m), _jb(l,m,e)) :
  s == 2 ?
    str(l[b],l[b+1]) :
    l[b];
function _jbd(l,d,b,e) = let(s = e-b, m=floor(b+s/2)) s > 2 ?
  str(_jbd(l,d,b,m), d, _jbd(l,d,m,e)) :
  s == 2 ?
    str(l[b],d,l[b+1]) :
    l[b];

// add leading zeroes to pad width
function lsp(x, l) = l>1 && abs(x) < pow(10,l-1) ? str("0", lsp(x,l-1)) : "";
// return extra trailing zeroes for a given precision
function tz(x, t) = let(mult=pow(10,t-1))
  t>0 && abs(floor(x*mult)-x*mult) < 1e-7 ? str("0", tz(x,t-1)) : "";
// format number as string with fixed width
function fixed(x,w,p) = let(mult=pow(10,p), x2=round(x*mult)/mult)
  str(x2<0?"-":" ", lsp(x2,w-p-2), abs(x2), abs(floor(x)-x2)<1e-9 ? "." : "" ,tz(x2,p));
