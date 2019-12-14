include <../list.scad>
include <utils_testing.scad>


module TestList() {
  echo("Testing funcutils.scad");
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
}

TestList();

