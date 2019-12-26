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

  //Test(substr("", -5, 2), "");
  //Test(substr("", 1, 2), "");
}

TestString();
