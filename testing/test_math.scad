include <../math.scad>
include <utils_testing.scad>


module TestMath() {
  echo("Testing math.scad");
  Test(derivative([2, 5, 9, 1, -5, 3, 6]), [3, 4, -8, -6, 8, 3]);
  Test(integral([3, 4, -8, -6, 8, 3]), [3, 7, -1, -7, 1, 4]);
  Test(derivative([4, 7]), [3]);
  Test(integral([42]), [42]);
  Test(derivative([4]), []);
  Test(derivative([]), []);
  Test(integral([]), []);
  v = [3, 4, -8, -6, 8, 3];
  Test(sum(v), 4);
  Test(sum(v, 3, 4), 2);

  Test(vect_range(2, 10, 2), [2, 4, 6, 8, 10]);
  Test(vect_range(2, 2, 5), [2]);
  Test(vect_range(3, -3, -1), [3, 2, 1, 0, -1, -2, -3]);
}

TestMath();

