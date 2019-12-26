include <../func.scad>
include <utils_testing.scad>


module TestFunc() {
  echo("Testing func.scad");
  Test(
    forf(
      function() [1, 1],
      function(v) len(v)<20,
      function(v) concat(v, [v[len(v)-2]+v[len(v)-1]])
    ),
    [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]);
  Test(
    forf(
      function() [2, [1, 1]],
      function(v) v[0]<20,
      function(v) [v[0]+1, [v[1][1], v[1][0]+v[1][1]]]
    )[1][1],
    6765);

  echo("Outputting 0 to 9:");
  testinit = function() 0;
  testcond = function(state) state<10;
  testupdate = function(state) state+1;
  testfunc = function(state) echo(state);
  Test(forf(testinit, testcond, testupdate, testfunc), 10);
}

TestFunc();

