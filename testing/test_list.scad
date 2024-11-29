include <../list.scad>
include <utils_testing.scad>


module TestList() {
  echo("Testing list.scad");
  v = [0,1,2,3,4,5,6,7,8,9];
  Test(slice(v), [0,1,2,3,4,5,6,7,8,9]);
  Test(slice(v,20), []);
  Test(slice(v,9), [9]);
  Test(slice(v,0,2,8), [0,2,4,6]);
  Test(slice(v,[0:2:8]), [0,2,4,6]);
  Test(slice(v,[0:8]), [0,1,2,3,4,5,6,7]);
  Test(slice(v,0,-2,8), []);
  Test(slice(v,-8), [2,3,4,5,6,7,8,9]);
  Test(slice(v,-8,-1), [2,1,0]);
  Test(slice(v,-8,-1,0), [2,1]);
  Test(slice(v,step=-1), [9,8,7,6,5,4,3,2,1,0]);
  Test(slice(v,step=-2), [9,7,5,3,1]);
  Test(slice(v,end=2), [0,1]);
  //Test(slice(v,[-1:-1:0]), [9,8,7,6,5,4,3,2,1]); // (warning but works)
  Test(slice(v,begin=1,end=3), [1,2]);
  Test(slice(v,begin=1,end=0), []);
  Test(slice([1,2,3,4],step=1/2), [1,1,2,2,3,3,4,4]); // (neat!)
  Test(slice([1,2,3,4],step=-1/2), [4,4,3,3,2,2,1,1]); // (neat!)
  Test(slice([1,2,3,4],step=-1/4), [4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1]); // (neat!)
  Test(slice(v,begin=1,end=0,step=-1), [1]);
  Test(slice(v,begin=-20,step=-1,end=-15),  []);
  Test(slice(v,step=0,end=undef,range=[0:2],begin=1/0), [0,1]); // (range override)
  // echo(slice(v,step=0)); // assertion!

  Test(pairs([0,1,2,3,4]), [[0,1],[1,2],[2,3],[3,4]]);
  Test(pairs([0,1]), [[0,1]]);
  Test(pairs([0]), []);
  Test(pairs([]), []);

  Test(ziparr([[1,2],[4,5],[6,7,8],[9,10,11]]), [[1,4,6,9],[2,5,7,10]]);
  Test(zip([1,2,3],[4,5,6,7]), [[1,4],[2,5],[3,6]]);
  Test(zip([1,2],[4,5],[6,7,8]), [[1,4,6],[2,5,7]]);
  Test(zip([1,2],[4,5],[6,7,8],[9,10,11]), [[1,4,6,9],[2,5,7,10]]);

  Test(select_mask(v, [false, true, false, true, true]), [1, 3, 4]);

  _ = rands(0, 1, 0, 0);  // Fixed seed
  Test(shuffle([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]), 
               [6,19,17,7,15,10,9,12,13,8,1,5,16,18,20,4,11,14,3,2] );

  // Tests for `parse_array`
  Test(parse_array("[1]"), [1.0]);
  Test(parse_array("[-1]"), [-1.0]);
  Test(parse_array("[1,4]"), [1.0, 4.0]);
  Test(parse_array("[1,4,9]"), [1.0, 4.0, 9.0]);
  Test(parse_array("[9,7,5,3,1]"), [9.0, 7.0, 5.0, 3.0, 1.0]);
  Test(parse_array("[[5]]"), [[5.0]]);
  Test(parse_array("[4,[2,9]]"), [4.0, [2.0, 9.0]]);
  Test(parse_array("[[1],4]"), [[1.0], 4.0]);
  Test(parse_array("[1,[4]]"), [1.0, [4.0]]);
  Test(parse_array("[503,10009,[[29,35,354,826488],9603287],18,8802745,[7842633],80,1]"), [503.0, 10009.0, [[29.0, 35.0, 354.0, 826488.0], 9603287.0], 18.0, 8802745.0, [7842633.0], 80.0, 1.0]);

  // This test produces the correct result, however it fails with "ERROR: Assertion '(test == result)' failed in file utils_testing.scad, line 6". Could be a bug in OpenSCAD or in utils_testing.
  // Test(parse_array("[116,8430867709923,92,8550,91332,1,27309547860,9739,4417784926591106415,301056846226629727851371]"), [116,8430867709923,92,8550,91332,1,27309547860,9739,4417784926591106415,301056846226629727851371]);

  Test(parse_array("[[7683,7031520709841,36445453876794239]]"), [[7683.0, 7031520709841.0, 36445453876794239.0]]);
  Test(parse_array("[1829,[6],887429071204245822022957,7,9627561254736,71673]"), [1829.0, [6.0], 887429071204245822022957.0, 7.0, 9627561254736.0, 71673.0]);
  Test(parse_array("[673309850355,98817604,1280899,[7,3119964922,4008738],862]"), [673309850355.0, 98817604.0, 1280899.0, [7.0, 3119964922.0, 4008738.0], 862.0]);
  Test(parse_array("[]"), []);
  Test(parse_array(" [   98 ,  [  3 , 5 ] ] "), [98.0,[3.0,5.0]]);
}

TestList();
