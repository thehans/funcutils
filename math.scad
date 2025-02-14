include <list.scad>

derivative = function (v)
  [for (p=pairs(v)) p[1]-p[0]];

function _integral_rec(v, sum=0, i=0, arr=[]) = (i == len(v)) ? arr :
  let(
    nsum = sum + v[i]
  )
  _integral_rec(v, nsum, i+1, [each arr, nsum]);
integral = function (v) len(v)<1 ? [] : _integral_rec(v, v[0]-v[0]);

function _sum_rec(v, first, last, sum=0) = first > last ? sum :
  _sum_rec(v, first+1, last, sum+v[first]);

sum = function(v, first=0, last=undef) let(
    last_int = is_undef(last) ? len(v)-1 : last
  )
  _sum_rec(v, first, last_int);

vect_range = function(first, last, step=1)
  [for (i=[first:step:last]) i];

