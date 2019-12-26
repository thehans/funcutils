// Test files all define a main Test___ module,  and include<...> their own dependencies.
// So we can use<...> each file individually here to avoid any interaction between includes.
use <test_func.scad>
use <test_list.scad>
use <test_math.scad>
use <test_std_algorithm.scad>
use <test_string.scad>

TestFunc();
TestList();
TestMath();
TestStdAlgorithm();
TestString();
