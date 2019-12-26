include <ops.scad>

// C++ STL-inspired algorithms
//   Also see file: "std_algorithm_status.md" for list of functions


// *********************************
// Non-modifying sequence operations
// *********************************

end = function (v, last)
  is_undef(last) ? len(v) : last;

all_of = function (v, p, first=0, last)
  let(l=end(v,last))
  find_if_not(v,p,first,l)==l;

any_of = function (v, p, first=0, last)
  let(l=end(v,last))
  find_if(v,p,first,l)!=l;

none_of = function (v, p, first=0, last)
  let(l=end(v,last))
  find_if(v,p,first,l)==l;

// As a "non-modifying" function, for_each just returns f rather than a new vector.
// Use std "transform" or general functional "map" for that.
// As such, for_each function probably only useful for echos and asserts.
for_each = function(v, f, first=0, last)
  let(l=end(v,last),dummy2=[for(i=[first:1:l-1]) let(dummy1=f(v[i])) if(false) undef])
  f;

// similar to for_each but returns (first+n)
for_each_n = function(v, f, first=0, n)
  let(dummy2=[ for(i=[first:1:first+n-1]) let(dummy1=f(v[i])) if(false) undef ])
  first+n;

// for_each[_n] module maybe slightly more useful, putting result of f into $each variable,
// which may be used by children
module for_each(v, f, first=0, last) {
  let(l=end(v,last))
    for(i=[first:1:l-1]) let($each=f(v[i])) children();
}
module for_each_n(v, f, first=0, n) {
  for(i=[first:1:first+n-1]) let($each=f(v[i])) children();
}

count = function (v, value, first=0, last, cmp=eq)
  accumulate(v,first,last,0,function(a,b) eq(b,value) ? a+1 : a);

count_if = function (v, p, first=0, last)
  accumulate(v,first,last,0,function(a,b) p(b) ? a+1 : a);

mismatch = function (v1, first1=0, last1, v2, first2=0, last2, cmp=eq)
  let(l1 = end(v1,last1), l2 =  end(v2,last2),
    imax = min(l1-first1, l2-first2),
    f=function (i) (i>=imax || !cmp(v1[first1+i],v2[first2+i])) ? (i<imax ? [first1+i,first2+i] : [first1+imax,first2+imax]) : f(i+1))
  assert(first1<=l1) assert(first2<=l2)
  f(0);

contains = function (v, value, first=0, last, cmp=eq)
  let(l=end(v,last))
  find(v,value,first,l,cmp)!=l;

find_if = function (v, p, first=0, last)
  let(l=end(v,last), f=function (i) (i>=l || p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);

find_if_not = function (v, p, first=0, last)
  let(l=end(v,last), f=function (i) (i>=l || !p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);

find = function(v, value, first=0, last, cmp=eq)
  find_if(v,function(x)cmp(value,x),first,last);

find_end = function(v, s_v, first=0, last, s_first=0, s_last, cmp=eq)
  let(l=end(v,last), sl=end(s_v,s_last)-1,
    _f=function(i, j) (j < s_first ? i+1 : (i < first ? l :
      (cmp(v[i],s_v[j]) ? _f(i-1,j-1) : _f(i+sl-j-1, sl)))))
  _f(l-1, sl);

find_first_of = function(v, s_v, first=0, last, s_first=0, s_last, cmp=eq)
  find_if(v,function(x)contains(s_v,x,s_first,s_last),first,last);

adjacent_find = function(v, first=0, last, cmp=eq)
  let(l=end(v,last), _a=function(f) l-f>1 && !cmp(v[f],v[f+1]) ? _a(f+1) : (l-f>1 ? f : l))
  _a(first);

std_search = function(v, s_v, first=0, last, s_first=0, s_last, cmp=eq)
  let(f=s_first, l=end(v,last), sl=end(s_v,s_last), d=sl-f,
    _s=function(i, j) (j >= sl ? i - d : (i == l ? l :
      (cmp(v[i],s_v[j]) ? _s(i+1,j+1) : _s(i+f-j+1, f)))))
  _s(first, s_first);

search_n = function(v, count, value, first=0, last, cmp=eq)
  let(l=end(v,last), _s=function(i,j) (j>=count ? i-count : (i == l ? l :
    (cmp(v[i],value) ? _s(i+1,j+1) : _s(i+1,0)))))
  _s(first,0);

// *****************************
// Modifying sequence operations
// *****************************

copy = function(v, first=0, last, d=[], d_first=0)
  let(l=end(v,last))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=[first:1:l-1]) v[i],
    for(i=[d_first+l-first:1:end(d)-1]) d[i] ];

copy_if = function(v, p, first=0, last, d=[], d_first=0)
  let(l=end(v,last), dl=end(d))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=first, j=d_first, t=i<l ? p(v[i]) : false;
        j < dl-d_first || i < l;
        i=i+1, j=(t || i>=l) ? j+1 : j, t=i<l ? p(v[i]) : false)
      if(t || i>=l) t ? v[i] : d[j] ];

copy_n = function(v, count, first=0, d=[], d_first=0)
  copy(v, first, first+count, d, d_first);

copy_backward = function(v, first=0, last, d=[], d_last)
  let(l=end(v,last), dl=end(d,d_last))
  [ for(i=[0:1:dl-l+first-1]) d[i],
    for(i=[first:1:l-1]) v[i],
    for(i=[dl:1:end(d)-1]) d[i] ];

//(N/A) move | moves a range of elements to a new location
//(N/A) move_backward | moves a range of elements to a new location in backwards order

fill = function(v=[], value, first=0, last)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=[first:1:l-1]) value,
    for(i=[l:1:end(v)-1]) v[i] ];

fill_n = function(v=[], count, value, first=0)
  [ for(i=[0:1:first-1]) v[i],
    for(i=[1:1:count]) value,
    for(i=[first+count:1:end(v)-1]) v[i] ];

transform = function(v1, unary_op, first1=0, last1, d=[], d_first=0)
  let(l1=end(v1,last1))
  [ for(i=[0:1:d_first1-1]) d[i],
    for(i=[first1:1:l1]) unary_op(v1[i]),
    for(i=[d_first+l1-first1:1:end(d)-1]) d[i] ];

transform2 = function(v1, v2, binary_op, first1=0, last1, first2=0, d=[], d_first=0)
  let(l1=end(v1,last1))
  [ for(i=[0:1:d_first1-1]) d[i],
    for(i=[0:1:l1-first1-1]) binary_op(v1[first1+i],v2[first2+i]),
    for(i=[d_first+l1-first1:1:end(d)-1]) d[i] ];

generate = function(g, v=[], first=0, last)
  let(l=end(v,last))
  [ for(i=[0:1:first-1])
    for(i=[first:1:l-1]) g(),
    for(i=[l:1:end(v)-1]) v[i] ];

generate_n = function(count, g, v=[], first=0)
  [ for(i=[0:1:first-1]) v[i],
    for(i=[1:1:count]) g(),
    for(i=[first+count:1:end(v)-1]) v[i] ];

remove = function (v, value, first=0, last, cmp=eq)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=[first:1:l-1]) if(!cmp(v[i],value)) v[i],
    for(i=[l:1:len(v)-1]) v[i] ];

remove_if = function (v, p, first=0, last)
  [ for(i=[0:1:end(v,last)-1]) if(!p(v[i])) v[i] ];

remove_copy = function (v, value, first=0, last, d=[], d_first=0, cmp=eq)
  copy_if(v, function(x)!cmp(x,value), first, last, d, d_first);

remove_copy_if = function(v, p, first=0, last, d=[], d_first=0)
  copy_if(v, function(x)!p(x), first, last, d, d_first);

replace = function (v, old_value, new_value, first=0, last, cmp=eq)
  [ for(i=[first:1:end(v,last)-1]) cmp(v[i],old_value) ? new_value : v[i] ];

replace_if = function (v, p, new_value, first=0, last)
  [ for(i=[first:1:end(v,last)-1]) p(v[i]) ? new_value : v[i] ];

replace_copy = function (v, old_value, new_value, first=0, last, d=[], d_first=0, cmp=eq)
  let(l=end(v,last))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=[first:1:l-1]) cmp(old_value, v[i]) ? new_value : v[i],
    for(i=[d_first+l-first:1:end(d)-1]) d[i] ];

replace_copy_if = function (v, p, new_value, first=0, last, d=[])
  let(l=end(v,last))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=[first:1:l-1]) p(v[i]) ? new_value : v[i],
    for(i=[d_first+l-first:1:end(d)-1]) d[i] ];

//(N/A) swap | swaps the values of two objects

swap_ranges = function(v1, v2, first1=0, last1, first2=0)
  let(l1=end(v1,last1))
  [ copy(v2, first2, first2+l1-first1, v1, first1),
    copy(v1, first1, l1, v2, first2) ];
    
index_swap = function(v_a, v_b, a_i, b_i)
  swap_ranges(v_a, v_b, a_i, a_i+1, b_i);

reverse = function (v, first=0, last)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=[l-1:-1:first]) v[i],
    for(i=[l:1:len(v)-1]) v[i] ];

reverse_copy = function (v, d, first=0, last, d_first)
  let(l=end(v,last))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=[l-1:-1:first]) v[i],
    for(i=[d_first+l-first:1:len(d)-1]) d[i] ];

std_rotate = function(v, first=0, n_first, last)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=[n_first:1:l-1]) v[i],
    for(i=[first:1:n_first-1]) v[i],
    for(i=[l:1:len(v)-1]) v[i] ];

std_rotate_copy = function(v, d, first=0, n_first, last, d_first=0)
  let(l=end(v,last))
  [ for(i=[0:1:d_first-1]) d[i],
    for(i=[0:1:first-1]) v[i],
    for(i=[n_first:1:l-1]) v[i],
    for(i=[first:1:n_first-1]) v[i],
    for(i=[l:1:len(v)-1]) v[i],
    for(i=[d_first+last-first:1:end(d)]) d[i] ];
    
//(Unsure): shift_left
//(Unsure): shift_right | shifts elements in a range
//(N/A): random_shuffle

//TODO: shuffle | randomly re-orders elements in a range
//shuffle = function(v, rand, first=0, last)
// rands(min, max, count, seed)

//TODO: sample | selects n random elements from a sequence



unique = function(v, first=0, last, cmp=eq)
  let(l=end(v,last))
  [ for(prev=undef, i=first, cur=v[i]; i<l; prev=cur, i=i+1, cur=v[i]) if(!eq(prev,cur)) cur ];

//(N/A) unique_copy | creates a copy of some range of elements that contains no consecutive duplicates


// ***********************
// Partitioning operations
// ***********************

//TODO: is_partitioned | determines if the range is partitioned by the given predicate

stable_partition = function(v, p, first=0, last)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=[first:1:l-1]) if(p(v[i])) v[i],
    for(i=[first:1:l-1]) if(!p(v[i])) v[i],
    for(i=[l:1:len(v)-1]) v[i] ];

//(N/A) partition_copy | copies a range dividing the elements into two groups
//(N/A) stable_partition | divides elements into two groups while preserving their relative order
//TODO: partition_point | locates the partition point of a partitioned range


// ******************
// Sorting operations
// ******************

is_sorted = function(v, first=0, last, cmp=lt)
  let(l=end(v,last))
  is_sorted_until(v,first,l)==l;

is_sorted_until = function(v, first=0, last, cmp=lt)
  let(l=end(v,last), su = function(i) i==l || cmp(v[i],v[i-1]) ? i : su(i+1))
  l-first>1 ? su(first+1) : l;

sort = function(v,first=0,last,cmp=lt)
  let(l=end(v,last), ms = function(f,l) let(d=l-f) d>2 ? let(m=floor((f+l)/2)) merge(ms(f,m),ms(m,l),cmp=cmp) : (d==2 ? minmax(v[f],v[f+1],cmp) : [v[f]]))
  l-first>0 ? ms(first,l) : [];  

//TODO: partial_sort | sorts the first N elements of a range
//(N/A) partial_sort_copy | copies and partially sorts a range of elements
//(Unsure) stable_sort | sorts a range of elements while preserving order between equal elements
//TODO: nth_element | partially sorts the given range making sure that it is partitioned by the given element


// *******************************************
// Binary search operations (on sorted ranges)
// *******************************************

upper_bound = function (v, value, first=0, last, cmp=lt)
  let(ub = function(b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(value, v[m]) ? ub(b, m) : ub(m, e) :
      cmp(value, v[m]) ? m : e)
  ub(first, end(v,last));

lower_bound = function (v, value, first=0, last, cmp=lt)
  let(lb = function(b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(v[m], value) ? lb(m,e) : lb(b,m) :
      cmp(v[m], value) ? e : m)
  lb(first, end(v, last));

binary_search = function (v, value, first=0, last, cmp=lt)
  let(l=end(v,last), f=lower_bound(v, value, first, l, cmp))
  !(f == l) && !cmp(value, v[f]);

//TODO: equal_range | returns range of elements matching a specific key


// *********************************
// Other operations on sorted ranges
// *********************************


// TODO: add d, d_first
merge = function(v1, v2, first1=0, last1, first2=0, last2, cmp=lt)
  let(l1=end(v1,last1), l2=end(v2,last2), fc = function(i,j) (i<l1 ? (j<l2 ? cmp(v1[i],v2[j]) : true) : false) )
  [ for(i=first1,j=first2,t=fc(i,j); i<l1 || j<l2; i=t?i+1:i,j=t?j:j+1,t=fc(i,j)) t ? v1[i] : v2[j] ];

inplace_merge = function(v, first, middle, last, cmp=lt)
  let(fc = function(i,j) (i<middle ? (j<last ? cmp(v[i],v[j]) : true) : false) )
  [ for(i=first,j=middle,t=fc(i,j); i<middle || j<last; i=t?i+1:i,j=t?j:j+1,t=fc(i,j)) v[t?i:j] ];


// *********************************
// Set operations (on sorted ranges)
// *********************************

//TODO: includes | returns true if one set is a subset of another
//TODO: set_difference | computes the difference between two sets
//TODO: set_intersection | computes the intersection of two sets
//TODO: set_symmetric_difference | computes the symmetric difference between two sets
//TODO: set_union | computes the union of two sets


// ***************
// Heap operations
// ***************

is_heap = function(v, first=0, last, cmp=lt)
  let(l=end(v,last))
  is_heap_until(v,first,l,cmp)==l;

is_heap_until = function(v, first=0, last, cmp=lt)
  let(f=first,l=end(v,last),e=ceil((l-f)/2),
    ih = function(i) let(n=v[i+f],li=f+i*2+1,ri=li+1) !((ri<l && cmp(n,v[ri])) || (li<l && cmp(n,v[li]))),
    hu = function(i=0) i<e && ih(i) ? hu(i+1) : min(f+i*2+2,l) )
    hu();

//make_heap = function(v, first=0, last)
//  let(l=end(v,last))
//  [ for(i=[first:1:l]) x];
//(Unsure) push_heap | adds an element to a max heap
//pop_heap = function(v, first=0, last)
//  let(f=first,l=end(v,last),e=ceil((l-f)/2),
//sort_heap = 


// **************************
// Minimum/maximum operations
// **************************

std_max = function(a, b, cmp=lt)
  cmp(a,b) ? b : a;

max_element = function(v, first=0, last, cmp=lt)
  let(l = end(v,last),
    m_e = function (i, m) i < l ? m_e(i+1, cmp(v[m], v[i]) ? i : m) : m)
  first < l ? m_e(first+1, first) : l;

std_min = function(a, b, cmp=lt)
  cmp(b,a) ? b : a;

min_element = function(v, first=0, last, cmp=lt)
  let(l = end(v,last),
    m_e = function (i, m) i < l ? m_e(i+1, cmp(v[i], v[m]) ? i : m) : m)
  first < l ? m_e(first+1, first) : l;

minmax = function(a, b, cmp=lt)
  cmp(b,a) ? [b,a] : [a,b];

minmax_element = function(v, first=0, last, cmp=lt) 
  let(l = end(v,last),
    mm_e = function (i, mm) i < l ? mm_e(i+1, [cmp(v[i],v[mm[0]]) ? i : mm[0], cmp(v[i],v[mm[1]]) ? mm[1] : i ]) : mm)
  first < l ? mm_e(first+1, [first,first]) : [l,l];

clamp = function (x,lo,hi,cmp=lt)
  cmp(x,lo) ? lo : (cmp(hi,x) ? hi : x);


// *********************
// Comparison operations
// *********************

//TODO: equal | determines if two sets of elements are the same
//TODO: lexicographical_compare | returns true if one range is lexicographically less than another
//TODO: lexicographical_compare_three_way | compares two ranges using three-way comparison


// **********************
// Permutation operations
// **********************

//TODO: is_permutation | determines if a sequence is a permutation of another sequence
//TODO: next_permutation | generates the next greater lexicographic permutation of a range of elements
//TODO: prev_permutation | generates the next smaller lexicographic permutation of a range of elements


// ******************
// Numeric operations
// ******************

iota = function(v=[], value, first=0, last, inc=inc)
  let(l=end(v,last))
  [ for(i=[0:1:first-1]) v[i],
    for(i=first, x=value; i<l; i=i+1, x=inc(x)) x ];

accumulate = function (v, first=0, last, init=0, op=add)
  let(l=end(v,last), a = function(i,acc) i<l ? a(i+1,op(acc,v[i])) : acc)
  a(first,init);

//TODO: inner_product
//TODO: adjacent_difference

//TODO: partial_sum


//(N/A) reduce
//TODO: exclusive_scan
//TODO: inclusive_scan
//TODO: transform_reduce
//TODO: transform_exclusive_scan
//TODO: transform_inclusive_scan


// ****************************************
// Operations on uninitialized memory (N/A)
// ****************************************

//(N/A) uninitialized_copy
//(N/A) uninitialized_copy_n
//(N/A) uninitialized_fill
//(N/A) uninitialized_fill_n
//(N/A) uninitialized_move
//(N/A) uninitialized_move_n
//(N/A) uninitialized_default_construct
//(N/A) uninitialized_default_construct_n
//(N/A) uninitialized_value_construct
//(N/A) uninitialized_value_construct_n
//(N/A) destroy_at
//(N/A) destroy
//(N/A) destroy_n


// *********
// C library
// *********

//(Unsure) qsort
//(Unsure) bsearch
