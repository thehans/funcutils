include <../ops.scad>
include <utils_testing.scad>

// try to define a special comparator that produce ordering between any two types (except functions?) ?
// special situations:
//   undef vs any
//   nan vs nan, nan vs any
//   string vs numbers?
//   list vs string?
//   

// Type ordering:
//   undef,bool,nan,numbers,string/list(which is first?),ranges(directly comaprable with lists by iterating values?),functions (order functions lexicographically by str(f)? )
//   

echo();


v = [undef, false, true, 0, "", "0", "OK", [], [undef], []];
for (i=[0:1:len(v)-1], j=[0:1:len(v)-1]) 
  echo(v[i], v[j]);
  if ()
  Test(are_comparable(v[i],v[j]), true);


echo(undef == 0);
echo(undef < 0);
echo(undef > 0);
echo(undef <= 0);
echo(undef >= 0);

echo(0 == undef);
echo(0 < undef);
echo(0 > undef);
echo(0 <= undef);
echo(0 >= undef);

echo(undef < undef);
echo(undef > undef);
//echo(undef / undef);
echo(undef < undef);
echo(undef > undef);