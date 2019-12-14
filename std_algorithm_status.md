## OpenSCAD Algorithm Implementation Status (C++ STL based)

#### List of STL Algorithms pulled from [cppreference.com](https://en.cppreference.com/w/cpp/algorithm)

### Key

Status      | Description 
----------- | -----------
:heavy_check_mark: | **DONE**
:white_check_mark: | **TODO**
:x:<sup>[#](#notes)</sup> | **Not Applicable** to OpenSCAD (with numbered note)
:question:<sup>[#](#notes)</sup> | **Unsure** if applicable (with numbered note)
:heavy_plus_sign: | **Bonus** Implemented in std library *style*, but not a native STL function

## Non-modifying sequence operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:heavy_check_mark: | all_of   | checks if a predicate is true for all of the elements in a range
:heavy_check_mark: | any_of   | checks if a predicate is true for any of the elements in a range
:heavy_check_mark: | none_of  | checks if a predicate is true for none of the elements in a range
:white_check_mark: | for_each   |
:white_check_mark: | for_each_n | applies a function object to the first n elements of a sequence
:white_check_mark: | count
:white_check_mark: | count_if | returns the number of elements satisfying specific criteria
:white_check_mark: | mismatch | finds the first position where two ranges differ
:heavy_check_mark: | find
:heavy_check_mark: | find_if
:heavy_check_mark: | find_if_not | finds the first element satisfying specific criteria
:heavy_plus_sign: | contains | like find, but return boolean instead of index
:white_check_mark: | find_end | finds the last sequence of elements in a certain range
:white_check_mark: | find_first_of | searches for any one of a set of elements
:white_check_mark: | adjacent_find | finds the first two adjacent items that are equal (or satisfy a given predicate)
:white_check_mark: | search | searches for a range of elements
:white_check_mark: | search_n | searches a range for a number of consecutive copies of an element

## Modifying sequence operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | copy
:white_check_mark: | copy_if | copies a range of elements to a new location
:white_check_mark: | copy_n | copies a number of elements to a new location
:white_check_mark: | copy_backward | copies a range of elements in backwards order
:x:<sup>[1](#note1)</sup> | move | moves a range of elements to a new location
:x:<sup>[1](#note1)</sup> | move_backward | moves a range of elements to a new location in backwards order
:white_check_mark: | fill | copy-assigns the given value to every element in a range
:white_check_mark: | fill_n | copy-assigns the given value to N elements in a range
:white_check_mark: | transform | applies a function to a range of elements, storing results in a destination range
:white_check_mark: | generate | assigns the results of successive function calls to every element in a range
:white_check_mark: | generate_n | assigns the results of successive function calls to N elements in a range
:heavy_check_mark: | remove
:heavy_check_mark: | remove_if | removes elements satisfying specific criteria
:x:<sup>[1](#note1)</sup> | remove_copy
:x:<sup>[1](#note1)</sup> | remove_copy_if | copies a range of elements omitting those that satisfy specific criteria
:heavy_check_mark: | replace
:heavy_check_mark: | replace_if | replaces all values satisfying specific criteria with another value
:x:<sup>[1](#note1)</sup> | replace_copy
:x:<sup>[1](#note1)</sup> | replace_copy_if | copies a range, replacing elements satisfying specific criteria with another value
:question: | swap | swaps the values of two objects
:question: | swap_ranges | swaps two ranges of elements
:question: | iter_swap | swaps the elements pointed to by two iterators
:heavy_check_mark: | reverse | reverses the order of elements in a range
:x:<sup>[1](#note1)</sup> | reverse_copy | creates a copy of a range that is reversed
:heavy_check_mark: | rotate | rotates the order of elements in a range
:x:<sup>[1](#note1)</sup> | rotate_copy | copies and rotate a range of elements
:white_check_mark: | shift_left
:white_check_mark: | shift_right | shifts elements in a range
:white_check_mark: | random_shuffle
:white_check_mark: | shuffle | randomly re-orders elements in a range
:white_check_mark: | sample | selects n random elements from a sequence
:heavy_check_mark: | unique | removes consecutive duplicate elements in a range
:x:<sup>[1](#note1)</sup> | unique_copy | creates a copy of some range of elements that contains no consecutive duplicates

## Partitioning operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | is_partitioned | determines if the range is partitioned by the given predicate
:heavy_check_mark: | partition | divides a range of elements into two groups
:x:<sup>[1](#note1)</sup> | partition_copy | copies a range dividing the elements into two groups
:x:<sup>[2](#note2)</sup> | stable_partition | divides elements into two groups while preserving their relative order
:white_check_mark: | partition_point | locates the partition point of a partitioned range

## Sorting operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | is_sorted | checks whether a range is sorted into ascending order
:white_check_mark: | is_sorted_until | finds the largest sorted subrange
:white_check_mark: | sort | sorts a range into ascending order
:white_check_mark: | partial_sort | sorts the first N elements of a range
:x:<sup>[1](#note1)</sup> | partial_sort_copy | copies and partially sorts a range of elements
:question:<sup>[2](#note2)</sup> | stable_sort | sorts a range of elements while preserving order between equal elements
:white_check_mark: | nth_element | partially sorts the given range making sure that it is partitioned by the given element

## Binary search operations (on sorted ranges)

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:heavy_check_mark: | lower_bound | returns an iterator to the first element not less than the given value
:heavy_check_mark: | upper_bound | returns an iterator to the first element greater than a certain value
:heavy_check_mark: | binary_search | determines if an element exists in a certain range
:white_check_mark: | equal_range | returns range of elements matching a specific key

## Other operations on sorted ranges

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | merge | merges two sorted ranges
:question:<sup>[1](#note1)</sup> | inplace_merge | merges two ordered ranges in-place

## Set operations (on sorted ranges)

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | includes | returns true if one set is a subset of another
:white_check_mark: | set_difference | computes the difference between two sets
:white_check_mark: | set_intersection | computes the intersection of two sets
:white_check_mark: | set_symmetric_difference | computes the symmetric difference between two sets
:white_check_mark: | set_union | computes the union of two sets

## Heap operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:question:<sup>[3](#note3)</sup> | is_heap | checks if the given range is a max heap
:question:<sup>[3](#note3)</sup> | is_heap_until | finds the largest subrange that is a max heap
:question:<sup>[3](#note3)</sup> | make_heap | creates a max heap out of a range of elements
:question:<sup>[3](#note3)</sup> | push_heap | adds an element to a max heap
:question:<sup>[3](#note3)</sup> | pop_heap | removes the largest element from a max heap
:question:<sup>[3](#note3)</sup> | sort_heap | turns a max heap into a range of elements sorted in ascending order

## Minimum/maximum operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | max | returns the greater of the given values
:white_check_mark: | max_element | returns the largest element in a range
:white_check_mark: | min | returns the smaller of the given values
:white_check_mark: | min_element | returns the smallest element in a range
:white_check_mark: | minmax | returns the smaller and larger of two elements
:white_check_mark: | minmax_element | returns the smallest and the largest elements in a range
:heavy_check_mark: | clamp | clamps a value between a pair of boundary values

## Comparison operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | equal | determines if two sets of elements are the same
:white_check_mark: | lexicographical_compare | returns true if one range is lexicographically less than another
:white_check_mark: | lexicographical_compare_three_way | compares two ranges using three-way comparison

## Permutation operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | is_permutation | determines if a sequence is a permutation of another sequence
:white_check_mark: | next_permutation | generates the next greater lexicographic permutation of a range of elements
:white_check_mark: | prev_permutation | generates the next smaller lexicographic permutation of a range of elements

## Numeric operations

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:white_check_mark: | iota | fills a range with successive increments of the starting value
:heavy_check_mark: | accumulate | sums up a range of elements
:white_check_mark: | inner_product | computes the inner product of two ranges of elements
:white_check_mark: | adjacent_difference | computes the differences between adjacent elements in a range
:white_check_mark: | partial_sum | computes the partial sum of a range of elements
:x:<sup>[4](#note4)</sup> | reduce | similar to std::accumulate, except out of order
:white_check_mark: | exclusive_scan | similar to std::partial_sum, excludes the ith input element from the ith sum
:white_check_mark: | inclusive_scan | similar to std::partial_sum, includes the ith input element in the ith sum
:white_check_mark: | transform_reduce | applies a functor, then reduces out of order
:white_check_mark: | transform_exclusive_scan | applies a functor, then calculates exclusive scan
:white_check_mark: | transform_inclusive_scan | applies a functor, then calculates inclusive scan

## Operations on uninitialized memory

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:x:<sup>[5](#note5)</sup> | uninitialized_copy | copies a range of objects to an uninitialized area of memory
:x:<sup>[5](#note5)</sup> | uninitialized_copy_n | copies a number of objects to an uninitialized area of memory
:x:<sup>[5](#note5)</sup> | uninitialized_fill | copies an object to an uninitialized area of memory, defined by a range
:x:<sup>[5](#note5)</sup> | uninitialized_fill_n | copies an object to an uninitialized area of memory, defined by a start and a count
:x:<sup>[5](#note5)</sup> | uninitialized_move | moves a range of objects to an uninitialized area of memory
:x:<sup>[5](#note5)</sup> | uninitialized_move_n | moves a number of objects to an uninitialized area of memory
:x:<sup>[5](#note5)</sup> | uninitialized_default_construct | constructs objects by default-initialization in an uninitialized area of memory, defined by a range
:x:<sup>[5](#note5)</sup> | uninitialized_default_construct_n | constructs objects by default-initialization in an uninitialized area of memory, defined by a start and a count
:x:<sup>[5](#note5)</sup> | uninitialized_value_construct | constructs objects by value-initialization in an uninitialized area of memory, defined by a range
:x:<sup>[5](#note5)</sup> | uninitialized_value_construct_n | constructs objects by value-initialization in an uninitialized area of memory, defined by a start and a count
:x:<sup>[5](#note5)</sup> | destroy_at | destroys an object at a given address
:x:<sup>[5](#note5)</sup> | destroy | destroys a range of objects
:x:<sup>[5](#note5)</sup> | destroy_n | destroys a number of objects in a range

## C library

**Status** | **Function Name** | **Description**
---------- | ----------------- | --------------- 
:question:<sup>[6](#note6)</sup> | qsort | sorts a range of elements with unspecified type
:question:<sup>[7](#note7)</sup> | bsearch | searches an array for an element of unspecified type

### Totals:

 | Count | Type                | 
 | -----:| ------------------- |
 |    19 | **DONE**            |
 |    59 | **TODO**            |
 |    26 | **Not Applicable**  |
 |    13 | **Unsure**          |
 |   117 | **Total STL algos** |
 |     1 | **Bonus**           |

### <a name="notes"></a>Notes

1. <a name="note1"></a>OpenSCAD doesn't differentiate between copy and move (everything is copy due to immutability)
2. <a name="note2"></a>Don't think there is a way to benefit from unstable version in OpenSCAD so "stable_" is already implied
3. <a name="note3"></a>Not sure if heap type operations can be implemented in such a way that is efficient/worth using?
4. <a name="note4"></a>Don't think there would be any difference between `reduce` and `accumulate` for OpenSCAD.  Choose one name?

   Also, `fold` exists under "Common higher-order function" (not STL based), but might want to call that `reduce`?
5. <a name="note5"></a>No low-level memory management in OpenSCAD
6. <a name="note6"></a>Don't think we can do quicksort efficiently since every swap requires a whole new list (mergesort makes most sense?)
7. <a name="note7"></a>Don't think there'd be any significant difference between bsearch and binary_search given that we just use indices not iterators or pointers

