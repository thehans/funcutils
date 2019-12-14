include <ops.scad>

// C++ STL-inspired algorithms
//   Also see file: "std_algorithm_status.md" for list of functions


// *********************************
// Non-modifying sequence operations 
// *********************************

end = function (v,last) is_undef(last) ? len(v) : last;

find_if = function (v,first=0,last,p)
  let(l=end(v,last), f=function (i) (i>=l || p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);
find_if_not = function (v,first=0,last,p)
  let(l=end(v,last), f=function (i) (i>=l || !p(v[i])) ? (i<l ? i : l) : f(i+1))
  f(first);
find = function(v, value, first=0, last, cmp=eq)
  find_if(v,first,last,function(x)cmp(value,x));

all_of = function (v,first=0,last,p) let(l=end(v,last)) find_if_not(v,first,l,p)==l;
any_of = function (v,first=0,last,p) let(l=end(v,last)) find_if(v,first,l,p)!=l;
none_of = function (v,first=0,last,p) let(l=end(v,last)) find_if(v,first,l,p)==l;

//TODO: for_each   |
//TODO: for_each_n | applies a function object to the first n elements of a sequence
//TODO: count
//TODO: count_if | returns the number of elements satisfying specific criteria
//TODO: mismatch | finds the first position where two ranges differ

contains = function (v,value,first,last,cmp=eq) let(l=end(v,last)) find(v,value,first,l,cmp)!=l;

//TODO: find_end | finds the last sequence of elements in a certain range
//TODO: find_first_of | searches for any one of a set of elements
//TODO: adjacent_find | finds the first two adjacent items that are equal (or satisfy a given predicate)
//TODO: search | searches for a range of elements
//TODO: search_n | searches a range for a number of consecutive copies of an element


// *****************************
// Modifying sequence operations
// *****************************

//TODO: copy
//TODO: copy_if | copies a range of elements to a new location
//TODO: copy_n | copies a number of elements to a new location
//TODO: copy_backward | copies a range of elements in backwards order
//(N/A) move | moves a range of elements to a new location
//(N/A) move_backward | moves a range of elements to a new location in backwards order
//TODO: fill | copy-assigns the given value to every element in a range
//TODO: fill_n | copy-assigns the given value to N elements in a range
//TODO: transform | applies a function to a range of elements, storing results in a destination range
//TODO: generate | assigns the results of successive function calls to every element in a range
//TODO: generate_n | assigns the results of successive function calls to N elements in a range

remove = function (v,first=0,last) let(l=end(v,last)) [
  for(j=[0:1:first-1]) v[j], 
  for(j=[last:1:len(v)-1]) v[j]
];
remove_if = function (v,first=0,last,p) let(l=end(v,last)) [
  for(i=[0:1:l-1]) if(!p(v[i])) v[i]];

//(N/A) remove_copy
//(N/A) remove_copy_if | copies a range of elements omitting those that satisfy specific criteria

replace = function (v,old_value,new_value,first=0,last,cmp=eq) let(l=end(v,last))
  [for(i=[first:1:l-1]) cmp(v[i],old_value) ? new_value : v[i] ];
replace_if = function (v,new_value,first=0,last,p) let(l=end(v,last))
  [for(i=[first:1:l-1]) p(v[i]) ? new_value : v[i] ];

//(N/A) replace_copy
//(N/A) replace_copy_if | copies a range, replacing elements satisfying specific criteria with another value
//(Unsure) swap | swaps the values of two objects
//(Unsure) swap_ranges | swaps two ranges of elements
//(Unsure) iter_swap | swaps the elements pointed to by two iterators

reverse = function (v,first=0,last) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i],
  for(i=[l-1:-1:first]) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];

//(N/A) reverse_copy | creates a copy of a range that is reversed

std_rotate = function(v,first=0,first_n,last) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i], 
  for(i=[first_n:1:l-1]) v[i], 
  for(i=[first:1:first_n-1]) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];

//(N/A) rotate_copy | copies and rotate a range of elements
//TODO: shift_left
//TODO: shift_right | shifts elements in a range
//TODO: random_shuffle
//TODO: shuffle | randomly re-orders elements in a range
//TODO: sample | selects n random elements from a sequence

unique = function(v, first=0, last, cmp=eq) let(l=end(v,last))
  [for(prev=undef, i=first, cur=v[i]; i<l; prev=cur, i=i+1, cur=v[i]) if(!eq(prev,cur)) cur];

//(N/A) unique_copy | creates a copy of some range of elements that contains no consecutive duplicates


// ***********************
// Partitioning operations
// ***********************

//TODO: is_partitioned | determines if the range is partitioned by the given predicate

stable_partition = function(v,first=0,last,p) let(l=end(v,last)) [
  for(i=[0:1:first-1]) v[i], 
  for(i=[first:1:l-1]) if(p(v[i])) v[i], 
  for(i=[first:1:l-1]) if(!p(v[i])) v[i],
  for(i=[l:1:len(v)-1]) v[i]
];

//(N/A) partition_copy | copies a range dividing the elements into two groups
//(N/A) stable_partition | divides elements into two groups while preserving their relative order
//TODO: partition_point | locates the partition point of a partitioned range


// ******************
// Sorting operations
// ******************

//TODO: is_sorted | checks whether a range is sorted into ascending order
//TODO: is_sorted_until | finds the largest sorted subrange
//TODO: sort | sorts a range into ascending order
//TODO: partial_sort | sorts the first N elements of a range
//(N/A) partial_sort_copy | copies and partially sorts a range of elements
//(Unsure) stable_sort | sorts a range of elements while preserving order between equal elements
//TODO: nth_element | partially sorts the given range making sure that it is partitioned by the given element


// *******************************************
// Binary search operations (on sorted ranges)
// *******************************************

upper_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(ub = function(b,e)
      let(m=floor((b+e)/2)) e-b > 1 ?
        cmp(value,v[m]) ? ub(b,m) : ub(m,e) :
        cmp(value,v[m]) ? m : e) 
  ub(first,end(v,last));

lower_bound = function (v, value, first=0, last=undef, cmp=lt)
  let(lb = function(b,e) //echo(v,x,b,e)
    let(m=floor((b+e)/2)) e-b > 1 ?
      cmp(v[m],value) ? lb(m,e) : lb(b,m) :
      cmp(v[m],value) ? e : m) 
  lb(first, end(v,last));

binary_search = function (v, value, first=0, last=undef, cmp=lt)
  let(last = end(v,last), first = lower_bound(v, value, first, last, cmp))
  !(first == last) && !cmp(value, v[first]);

//TODO: equal_range | returns range of elements matching a specific key


// *********************************
// Other operations on sorted ranges
// *********************************

//TODO: merge | merges two sorted ranges
//(Unsure) inplace_merge | merges two ordered ranges in-place


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

//(Unsure) is_heap | checks if the given range is a max heap
//(Unsure) is_heap_until | finds the largest subrange that is a max heap
//(Unsure) make_heap | creates a max heap out of a range of elements
//(Unsure) push_heap | adds an element to a max heap
//(Unsure) pop_heap | removes the largest element from a max heap
//(Unsure) sort_heap | turns a max heap into a range of elements sorted in ascending order


// **************************
// Minimum/maximum operations
// **************************

max = function(a, b, cmp=lt) cmp(a,b) ? b : a;
max_element = function(v, first=0, last, cmp=lt) let(l = end(v,last),
  m_e = function (i, m) i < l ? m_e(i+1, cmp(v[m], v[i]) ? i : m) : m)
  first < l ? m_e(first+1, first) : l;

min = function(a, b, cmp=lt) cmp(b,a) ? b : a;
min_element = function(v, first=0, last, cmp=lt) let(l = end(v,last),
  m_e = function (i, m) i < l ? m_e(i+1, cmp(v[i], v[m]) ? i : m) : m)
  first < l ? m_e(first+1, first) : l;

minmax = function(a, b, cmp=lt) cmp(b,a) ? [b,a] : [a,b];
minmax_element = function(v, first=0, last, cmp=lt) let(l = end(v,last),
  mm_e = function (i, mm) i < l ? mm_e(i+1, [cmp(v[i],v[mm[0]]) ? i : mm[0], cmp(v[i],v[mm[1]]) ? mm[1] : i ]) : mm)
  first < l ? mm_e(first+1, [first,first]) : [l,l];

clamp = function (x,lo,hi,cmp=lt) cmp(x,lo) ? lo : (cmp(hi,x) ? hi : x);


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

//TODO: iota

accumulate = function (v, first=0, last=undef, init=0, op=add)
  let(l=end(v,last), a = function(f,acc) f<l ? a(f+1,op(acc,v[f])) : acc)
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
