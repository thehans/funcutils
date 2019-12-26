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
}

TestList();

