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
//  return (x modulo y) in range: [0,y-1], always non-negative
mod = function (x,y) let(r=x%y) r<0 ? r+y : r; 

// Boolean
//not  = function (x) !x;
//and  = function (x,y) x&&y;
//or   = function (x,y) x||y;
//xor  = function (x,y) (x||y) && !(x&&y);
//nand = function (x,y) !(x&&y);
//nor  = function (x,y) !(x||y);
//xnor = function (x,y) (x&&y) || ((!x)&&(!y)); 


// Misc utility functions:
//def = function (x,default) is_undef(x)?default:x; // default value
get = function (v,i) v[mod(i,len(v))]; // get element from v with wrapping


// *** C++ STL-inspired algorithms, using closest approximate interface where possible ***

// Loosely based on: https://en.cppreference.com/w/cpp/iterator/end
//   return last OR length of v if last not defined
//     used to for getting default "end iterator" in STL-like functions
end = function (v,last) is_undef(last) ? len(v) : last;

// Based on: https://en.cppreference.com/w/cpp/algorithm/accumulate
//  same as "fold" but with optional params for first, last, op (default addition)
accumulate = function (v, first=0, last=undef, init=0, op=add)
  let(_acc = function(v,f,l,acc,op) f<l ? _acc(v,f+1,l,op(acc,v[f]),op) : acc)
  _acc(v,first,end(v,last),init,op);
// Ex:
//echo(accumulate([1,2,3,4,5]));
//echo(accumulate([1,2,3,4,5],init=1,op=function(x,y)x*y));

// Based on: https://en.cppreference.com/w/cpp/algorithm/upper_bound
// return index of first element in v which is greater than the value
upper_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(ub = function(v,x,b,e,cmp) //echo(v,x,b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(x,v[m]) ? ub(v,x,b,m,cmp) : ub(v,x,m,e,cmp) :
      cmp(x,v[m]) ? m : e) 
  ub(v, value, first, end(v,last), cmp);

// Based on: https://en.cppreference.com/w/cpp/algorithm/lower_bound
// return index of first element in v which is *not less* than the value
lower_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(lb = function(v,x,b,e,cmp) //echo(v,x,b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(v[m],x) ? lb(v,x,m,e,cmp) : lb(v,x,b,m,cmp) :
      cmp(v[m],x) ? e : m) 
  lb(v, value, first, end(v,last), cmp);
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

// Loosely based on: https://en.cppreference.com/w/cpp/container/map/contains
// return true if any element in v is equivalent to value
contains = function (v,value,i=0,cmp=eq) 
  i>=len(v) || cmp(v[i],value) ? i<len(v) : contains(v, value, i+1, cmp);
// Ex:
//echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],3.14));
//echo(contains([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],-1));

// Based on: https://en.cppreference.com/w/cpp/algorithm/find
// return index of first element which matches predicate cmp, 
//   or last/len(v) if not found.
find = function(v, value, first=0, last=undef, cmp=eq)
  let(fnd = function(v,x,f,l,cmp) f>=l || cmp(v[f],x) ? (f<l ? f : l) : fnd(v,x,f+1,l,cmp))
  fnd(v,value,first,end(v,last),cmp);
// Ex:
//echo(find([6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],-8));

// Based on: https://en.cppreference.com/w/cpp/algorithm/unique
// Removes all but the first element from every group of consecutive equivalent elements.
//   v should be pre-sorted if uniqueness across entire vector is desired.
unique = function(v, first=0, last, cmp=eq) 
  [for(prev=undef, i=first, cur=v[i]; i<end(v,last); prev=cur, i=i+1, cur=v[i]) if(!eq(prev,cur)) cur];
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
//echo(insertv_sorted([],[for (x=rands(0,1000,1000)) floor(x)]));



// *** Various List manipulation functions (Not higher-order) ***

// insert element x into v at index i
insert = function (v,x,i) [for(j=[0:1:i-1]) v[j], x, for(j=[i:1:len(v)-1]) v[j]];

// insert vector of elements xs into v at index i 
insertv = function (v,i,xs) [for(j=[0:1:i-1]) v[j], for(x=xs) x, for(j=[i:1:len(v)-1]) v[j]];

// replace element i'th of v with x
replace = function (v,i,x) [for(j=[0:1:i-1]) v[j], x, for(j=[i+1:1:len(v)-1]) v[j]];

// replace elements of v in range with elements from vector xs
//    range is vec2 containing [begin,end) indices.  
//    xs does not need to be same length as range
replace_range = function (v,range,xs) [for(j=[0:1:range[0]-1]) v[j], for(x=xs) x, for(j=[range[1]+1:1:len(v)-1]) v[j]];

// remove single element from v at index i
delete = function (v,i) [for(j=[0:1:i-1]) v[j], for(j=[i+1:1:len(v)-1]) v[j]];

// remove elements from v in the given range
delete_range = function (v,range) [for(j=[0:1:range[0]-1]) v[j], for(j=[range[1]+1:1:len(v)-1]) v[j]];

// permutations
reverse = function (v) [for(i=[len(v)-1:-1:0]) v[i]];
rotl = function (v,l=1) let(i0=mod(l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];
rotr = function (v,l=1) let(i0=mod(-l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];

// Extract sub-list given begin(inclusive) and end(exclusive). If end not specified, go to end of list
sublist = function (s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) [for(i=[b:1:e-1]) s[i] ];



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
