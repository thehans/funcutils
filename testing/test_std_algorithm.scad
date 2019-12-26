include <../list.scad> // needed for insertv_sorted  (list.scad includes std_algorithm.scad)
include <utils_testing.scad>

// TODO update README for newly added std functions and interface changes made since testing
// TODO various algorithms with hastily written implementation NOT YET TESTED at all

module TestStdAlgorithm() {
  echo("Testing std_algorithm.scad");

  // end (v,last)
  let(v=[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1]) {
    Test(end([]), 0);
    Test(end(v), len(v));
    Test(end(v, 5), 5);
  }

  // all_of (v, p, first=0, last)
  // any_of (v, p, first=0, last)
  // none_of (v, p, first=0, last)
  for(v=[ 
      [ [[],false,true,"ok"], [false, false,  true] ],
      [ [0,1,2,3,0/0],        [false,  true, false] ], 
      [ [],                   [ true, false,  true] ], 
      [ [0,1,2,3],            [ true,  true, false] ]
    ]) 
    let(p=function(x) is_num(x)) 
  {
    Test([ all_of(v[0],p), any_of(v[0],p=p), none_of(v[0],p=p) ], v[1]);
    Test( any_of(v[0],p), !none_of(v[0],p=p));
    Test(!any_of(v[0],p),  none_of(v[0],p=p));
  }

  let(v=[undef,undef,2,3,4,undef]) {

    // for_each (v, f, first=0, last)
    Test(is_function(for_each(v,function(x)assert(!is_undef(x)),2,5)),true);
    Test(is_function(for_each(v,function(x)assert(is_undef(x)),0,2)),true);
    Test(is_function(for_each(v,function(x)assert(is_undef(x)),5,6)),true);

    // for_each_n (v, f, first=0, n)
    Test(for_each_n(v,function(x)assert(!is_undef(x)),2,3),2+3);
    Test(for_each_n(v,function(x)assert(is_undef(x)),0,2),0+2);
    Test(for_each_n(v,function(x)assert(is_undef(x)),5,1),5+1);
  }

  // count (v, first=0, last, value, cmp=eq)
  Test(count("this is a test", "t"), 3);

  // count_if (v, first=0, last, value, p)
  Test(count_if([1,2,3,4,5,6,7,8,9,10], p=function(x)x>3), 7);

  // mismatch (v1, first1=0, last1, v2, first2=0, last2, cmp=eq)
  Test(mismatch(v1="oh! hi, how are you?",first1=4,v2="hi, how's it going?"), [11, 7]);
  Test(mismatch(v1="Hello World",v2="Hello World"), [11, 11]);
  Test(mismatch(v1="Hello!",v2="Hello"), [5, 5]);
  Test(mismatch(v1="l",v2="Hello",first2=3), [1, 4]);
  
  let(v=[6,4,7,-8,4,3,5,-6,5,3,2,1,10,0,-1],
      neg=function(x)x<0, 
      und=function(x)is_undef(x),
      num=function(x)is_num(x))
  {
    // contains
    Test(contains(v, 3.14), false);
    Test(contains(v, 6), true);
    Test(contains(v, -1), true);
    Test(contains([],true), false);

    // find (v, value, first=0, last, cmp=eq)
    Test(find(v, 6), 0);          // first element
    Test(find(v, -1), len(v)-1);  // last element
    Test(find(v, 3), 5);          // multiple matches, return index of first one
    Test(find(v, -8), 3);         // "random" element
    Test(find(v, undef), end(v)); // not found
    Test(find([0], 0), 0);        // single element, found
    Test(find([0], 1), 1);        // single element, not found
    Test(find([], undef), 0);     // empty list, not found

    // find_if (v, p, first=0, last)
    Test(find_if (v, neg), 3);
    Test(find_if (v, neg, 3), 3);
    Test(find_if (v, neg, 8), end(v)-1);
    Test(find_if (v, und), end(v));
    Test(find_if (v, num), 0);

    // find_if_not (v, p, first=0, last)
    Test(find_if_not (v, neg), 0);
    Test(find_if_not (v, neg, 3), 4);
    Test(find_if_not (v, neg, 3), 4);
    Test(find_if_not (v, und, 7), 7);
    Test(find_if_not (v, und, 0, 0), 0);
    Test(find_if_not (v, und, 0, 1), 0);
    Test(find_if_not (v, num), end(v));
    Test(find_if_not (v, num, 3, 10), 10);
  }

  let (buf = "Buffalo buffalo Buffalo buffalo buffalo buffalo Buffalo buffalo",
       bin = "1001010100010101001010101")
  {
    // find_end (v, s_v, first=0, last, s_first=0, s_last, cmp=eq)
    Test(find_end(buf, "Buffalo"), 48);
    Test(find_end(buf, "buffalo"), 56);
    Test(find_end(buf, " Buffalo"), 47);
    Test(find_end(buf, "Buffaloo"), end(buf));
    Test(find_end(bin, "10101"), 20);
    Test(find_end(bin, "100101"), 15);
    Test(find_end(bin, "00"), 16);
    Test(find_end(bin, bin), 0);
    Test(find_end(bin, bin, s_first=2), 2);
    Test(find_end(bin, "0000"), end(bin));

    // find_first_of (v, s_v, first=0, last, s_first=0, s_last, cmp=eq)
    Test(find_first_of(buf,"abc"), 4);
    Test(find_first_of(buf,"def"), 2);
    Test(find_first_of(buf,"ABC"), 0);
    Test(find_first_of(buf,"ABC", 16), 16);
    Test(find_first_of(buf,"ABC", 17), 48);
    Test(find_first_of(buf,"ABC", 17, 40), 40);
    Test(find_first_of(buf,"ABCDEFG", s_first=2), end(buf));
    Test(find_first_of(buf,"abcdefg", s_first=2, s_last=5), end(buf));

    Test(adjacent_find(buf), 2);
    Test(adjacent_find(buf, 2), 2);
    Test(adjacent_find(buf, 3), 10);
    Test(adjacent_find(bin), 1);
    Test(adjacent_find(bin, 2), 8);

    // std_search (v, s_v, first=0, last, s_first=0, s_last, cmp=eq) 
    Test(std_search(buf, "Buffalo"), 0);
    Test(std_search(buf, "buffalo"), 8);
    Test(std_search(buf, " Buffalo"), 15);
    Test(std_search(bin, "10101"), 3);

    // search_n (v, count, value, first=0, last, cmp=eq) 
    Test(search_n(buf, 2, "f"), 2);
    Test(search_n(buf, 1, "b"), 8);
    Test(search_n(buf, 0, "Z"), 0);
    Test(search_n(bin, 4, "0"), end(bin));
    Test(search_n(bin, 3, "0"), 8);
  }

  let(v=[0,1,2,3,4,5,6,7,8,9], even=function(x)x%2==0, lt5=function(x)x<5) {
    // copy (v, first=0, last, d=[], d_first=0)
    Test(copy(v),v);
    Test(copy(v,5),[5,6,7,8,9]);
    Test(copy(v,7,8),[7]);
    Test(copy(v,0,7,[10,11,12,13,14,15,16,17,18,19]),[0,1,2,3,4,5,6,17,18,19]);
    Test(copy(v,0,7,[10,11,12],2),[10,11,0,1,2,3,4,5,6]);
      
    // copy_if (v, p, first=0, last, d=[], d_first=0)
    Test(copy_if(v,even),[0,2,4,6,8]);
    Test(copy_if(v,lt5,5),[]);
    Test(copy_if(v,lt5,2,8),[2,3,4]);
    Test(copy_if(v,even,0,7,[10,11,12,13,14,15,16,17,18,19]),[0,2,4,6,14,15,16,17,18,19]);
    Test(copy_if(v,even,0,7,[10,11,12],2),[10,11,0,2,4,6]);
    
    // copy_n (v, count, first=0, d=[], d_first=0)
    Test(copy_n(v,10),v);
    Test(copy_n(v,5,5),[5,6,7,8,9]);
    Test(copy_n(v,1,7),[7]);
    Test(copy_n(v,7,0,[10,11,12,13,14,15,16,17,18,19]),[0,1,2,3,4,5,6,17,18,19]);
    Test(copy_n(v,7,0,[10,11,12],2),[10,11,0,1,2,3,4,5,6]);
  
    // TODO
    // copy_backward = function(v, first=0, last, d=[], d_last)
  
    Test(fill([],-1,0,5),[-1,-1,-1,-1,-1]);
    Test(fill(v,-1,0,5),[-1,-1,-1,-1,-1,5,6,7,8,9]);
    Test(fill(v,-1,5,10),[0,1,2,3,4,-1,-1,-1,-1,-1]);

    Test(fill_n([],5,-1),[-1,-1,-1,-1,-1]);
    Test(fill_n(v,5,-1),[-1,-1,-1,-1,-1,5,6,7,8,9]);
    Test(fill_n(v,6,0,first=5),[0,1,2,3,4,0,0,0,0,0,0]);
  }

  // TODO ...
  // transform = function(v1, unary_op, first1=0, last1, d=[], d_first=0)
  // transform2 = function(v1, v2, binary_op, first1=0, last1, first2=0, d=[], d_first=0)
  // generate = function(g, v=[], first=0, last)
  // generate_n = function(count, g, v=[], first=0)

  // remove (v, value, first=0, last)
  let(v=[0,1,2,3,4,5,6,7,8,9]) {
    Test(remove(v), v); // value is undef, so nothing removed
    Test(remove(v,0), [1,2,3,4,5,6,7,8,9]); // value is undef, so nothing removed
    Test(remove(v,9), [0,1,2,3,4,5,6,7,8]); // value is undef, so nothing removed
    Test(remove(v,4,4,5), [0,1,2,3,5,6,7,8,9]);

    // remove_if (v, p, first=0, last)
    Test(remove_if(v, p=function(x)x%3==0), [1,2,4,5,7,8]);

    // TODO ...
    // remove_copy = function (v, value, first=0, last, d=[], d_first=0, cmp=eq) 
    // remove_copy_if = function(v, p, first=0, last, d=[], d_first=0) 
  }

  // replace (v, old_value, new_value, first=0, last, cmp=eq)
  Test(replace([0,1,2,3,1,4,5,6,1,7,8,1,9],1,[]), [0,[],2,3,[],4,5,6,[],7,8,[],9]);
  // replace_if (v, new_value, first=0, last, p)
  Test(replace_if([0,1,2,3,1,4,5,6,1,7,8,1,9],function(x)x<5, 0),[0,0,0,0,0,0,5,6,0,7,8,0,9]);

  // TODO ...
  // replace_copy = function (v, old_value, new_value, first=0, last, d=[], d_first=0, cmp=eq)
  // replace_copy_if = function (v, p, new_value, first=0, last, d=[])
  // (N/A) swap
  // swap_ranges = function(v1, v2, first1=0, last1, first2=0)
  // index_swap = function(v_a, v_b, a_i, b_i)

  // reverse (v, first=0, last)
  Test(reverse([0,1,2,3,4,5,6,7,8,9]), [9,8,7,6,5,4,3,2,1,0]);
  Test(reverse([0,1,2,3,4,5,6,7,8,9],3,7), [0,1,2,6,5,4,3,7,8,9]);

  // TODO
  // reverse_copy = function (v, d, first=0, last, d_first)

  // std_rotate (v, first=0, first_n, last)
  // move elements [3,7) to position 12: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=630
  Test(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,7,12), [0,1,2,7,8,9,10,11,3,4,5,6,12,13,14,15]); 
  // move elements [8,12) to position 3: https://www.youtube.com/watch?v=W2tWOdzgXHA&feature=youtu.be&t=645
  Test(std_rotate([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],3,8,12), [0,1,2,8,9,10,11,3,4,5,6,7,12,13,14,15]); 

  // TODO
  // std_rotate_copy = function(v, d, first=0, n_first, last, d_first=0)

  // unique (v, first=0, last, cmp=eq)
  Test(unique(insertv_sorted([],[1,2,3,1,2,3,3,4,5,4,5,6,7])), [1,2,3,4,5,6,7]);

  // stable_partition (v, first=0, last, p)
  let(is_even = function(x)x%2==0) {
    Test(stable_partition([0,1,2,3,4,5,6,7,8,9],is_even), [0,2,4,6,8,1,3,5,7,9]);
  }

  Test(unique(insertv_sorted([],[1,2,3,1,2,3,3,4,5,4,5,6,7])), [1,2,3,4,5,6,7]);

  let(v1=[],
    v2=[0],
    v3=[undef],
    v4=[1,2,3,4,5,67,43],
    v5=[100,99,98],
    v6=[0,1,2,3,4,4,3,2,1]
  ) { 

    // is_sorted (v, first=0, last, cmp=lt)
    Test(is_sorted(v1), true);
    Test(is_sorted(v2), true);
    Test(is_sorted(v3), true);
    Test(is_sorted(v4), false);
    Test(is_sorted(v5), false);
    Test(is_sorted(v6), false);

    // is_sorted_until (v, first=0, last, cmp=lt)
    Test(is_sorted_until(v1), 0);
    Test(is_sorted_until(v2), 1);
    Test(is_sorted_until(v3), 1);
    Test(is_sorted_until(v4), 6);
    Test(is_sorted_until(v5), 1);
    Test(is_sorted_until(v6), 6);
  }

  // merge_sort = function(v,first=0,last,cmp=lt)


  // upper_bound (v, value, first=0, last=undef, cmp=lt)
  // lower_bound (v, value, first=0, last=undef, cmp=lt)
  let(v = [1, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6]) {
    // return sublist of equivalent elements
    Test(sublist(v,lower_bound(v,1),upper_bound(v,1)), [1,1]);   // first element
    Test(sublist(v,lower_bound(v,4),upper_bound(v,4)), [4,4,4]); // "random" middle element
    Test(sublist(v,lower_bound(v,6),upper_bound(v,6)), [6]);     // last element
    Test(sublist(v,lower_bound(v,7),upper_bound(v,7)), []);      // non-existing element
  }

  // binary_search (v, value, first=0, last=undef, cmp=lt)
  let(v1 = [1,2,3,5,5,8,12], v2=[-1,0,4,6,9]) {
    for (x=v1) Test(binary_search(v1, x), true);  // contains all its own elements
    for (x=v2) Test(binary_search(v2, x), true);  
    for (x=v2) Test(binary_search(v1, x), false); // do not contain each other's elements
    for (x=v1) Test(binary_search(v2, x), false);

    Test(binary_search([],[]), false);
    Test(binary_search([ [] ],[]), true);
    Test(binary_search([],true), false);
    Test(binary_search([undef],undef), true);
    //  Can't really compare undef with other objects, see OpenSCAD Github Issue #3165
    //Test(binary_search([undef], 0), false);
    //Test(binary_search([0], undef), false);
  }

  // TODO 
  // merge (v1, v2, first1=0, last1, first2=0, last2)

  let(v1=[1,2,3,4,5,6,7,8,9,10],
      v2=[2,4,6,8,10],
      v3=[1,3,5,7,9],
      v4=[11,12,13,14,15],
      v5=[],
      v6=[0]) {
    inplace_test = function(v1,v2) inplace_merge(concat(v1,v2), 0, len(v1), len(v1)+len(v2));

    Test(inplace_test(v1,v1), [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10]);
    Test(inplace_test(v1,v2), [1,2,2,3,4,4,5,6,6,7,8,8,9,10,10]);
    Test(inplace_test(v1,v3), [1,1,2,3,3,4,5,5,6,7,7,8,9,9,10]);
    Test(inplace_test(v1,v4), concat(v1,v4));
    Test(inplace_test(v4,v1), concat(v1,v4));
    Test(inplace_test(v1,v5), v1);
    Test(inplace_test(v1,v6), concat(v6,v1));
    Test(inplace_test(v6,v1), concat(v6,v1));
    Test(inplace_test(v2,v3), v1);
    Test(inplace_test(v3,v2), v1);
  }

  // max (a, b, cmp=lt)
  // min (a, b, cmp=lt)
  // Example compare by index
  Test(std_max([100,1],[-100,2],function(a,b) a[0]<b[0]), [100,1]);   
  Test(std_max([100,1],[-100,2],function(a,b) a[1]<b[1]), [-100,2]);
  Test(std_min([100,1],[-100,2],function(a,b) a[0]<b[0]), [-100,2]);
  Test(std_min([100,1],[-100,2],function(a,b) a[1]<b[1]), [100,1]);
  // return first when "equivalent"
  Test(std_max([1,2,3],[3,2,1],function(a,b) a[1]<b[1]), [1,2,3]);
  Test(std_min([1,2,3],[3,2,1],function(a,b) a[1]<b[1]), [1,2,3]);


  let(v= [0,1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2,1,0,9]) {
    // max_element (v, first=0, last, cmp=lt)
    Test(max_element(v), 9);
    Test(max_element(v,10), 19);

    // min_element (v, first=0, last, cmp=lt)
    Test(min_element(v), 0);
    Test(min_element(v,10), 18);
  }
  
  // minmax (a, b, cmp=lt)
  let (lencmp = function (a,b) len(a) < len(b) ) {
    Test(minmax("World!","Hello",lencmp), ["Hello", "World!"]);
    Test(minmax("Hello","World!",lencmp), ["Hello", "World!"]); 
    // [a,b] stay in-order when equivalent
    Test(minmax("Hello","World",lencmp), ["Hello", "World"]);
    Test(minmax("World","Hello",lencmp), ["World", "Hello"]);
  }

  // minmax_element (v, first=0, last, cmp=lt)
  let(s = "The quick brown fox jumps over the lazy dog") {
    x = minmax_element(s);
    Test(x, [3, 37]);
    Test(s[x[0]], " ");
    Test(s[x[1]], "z");
  }

  // iota (v=[], value, first=0, last, inc=inc)
  Test(iota(value=0,last=10), [0,1,2,3,4,5,6,7,8,9]);
  Test(iota([0,1,2,3,4,5,6],7,7,10), [0,1,2,3,4,5,6,7,8,9]);
  Test(iota(v=[0,1,2,3,4,5],value=4,first=6,last=11,inc=dec), [0,1,2,3,4,5,4,3,2,1,0]);
  Test(iota(value="A",last=26,inc=function(x)chr(ord(x)+1)), [for(x=[ord("A"):ord("Z")]) chr(x)]);

  // accumulate (v, first=0, last=undef, init=0, op=add)
  let (v=[1,2,3,4,5]) {
    Test(accumulate(v), 15);
    Test(accumulate(v, init=1, op=function(x,y)x*y), 120);
  }

}


TestStdAlgorithm();
