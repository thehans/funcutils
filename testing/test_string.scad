include <../string.scad>
include <utils_testing.scad>

// TODO some string tests still missing.

module TestString() {
  echo("Testing string.scad");

  s = "The quick brown fox jumps over the lazy dog.";
  // split on words
  Test(split(s), ["The", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog."]);
  Test(join(split(s), " "), s);

  // split on empty string (every letter)
  Test(join(split(s, "")), s);
  Test(len(split(s, "")), len(s));
  Test(is_list(split(s, "")), true);

  Test(csv_parse(
   "-1, 0,2,4, 3.14159, 6.67408e-11, 1.0545e-34, 6.022e23, -1.602e-19"),
   [-1, 0,2,4, 3.14159, 6.67408e-11, 1.0545e-34, 6.022e23, -1.602e-19]);

  //Test(substr("", -5, 2), "");
  //Test(substr("", 1, 2), "");
}

TestString();
