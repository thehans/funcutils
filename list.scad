include <types.scad>
include <std.scad>
//  Dependencies included by std.scad:
//    include <ops.scad>

// Various list-based functions which are *not* directly modeled after C++ STL algorithms.

clamp_range = function (v,begin,step,end)
  let(
    l = len(v),
    s = is_undef(step) ? 1 : assert(step!=0) step,
    b = is_undef(begin) ? (s<0 ? l+max(-1,s) : 0) : clamp(begin<0?begin+l:begin, 0, l),
    e = is_undef(end) ? (s<0 ? 0 : l-s) : clamp(end<0?end+l:end, 0, l)-s
  )
  [ b : s : e ];

def = function (x,default) is_undef(x)?default:x;

get = function (v,i) v[mod(i,len(v))];

insert = function (v,x,i) [for(j=[0:1:i-1]) v[j], x, for(j=[i:1:len(v)-1]) v[j]];

insertv = function (v,i,xs) [for(j=[0:1:i-1]) v[j], for(x=xs) x, for(j=[i:1:len(v)-1]) v[j]];

insert_sorted = function (v,x,cmp=lt)
  insert(v,x,upper_bound(v,x,cmp=cmp));

insertv_sorted = function (v,xs,cmp=lt)
  let(l=len(xs))
  [for(temp=v, i=0;
      i<=l;
      temp=i==l ? temp : insert_sorted(temp,xs[i],cmp),i=i+1)
    if(i==l) temp
  ][0];

replace_range = function (v,range,xs) [for(j=[0:1:range[0]-1]) v[j], for(x=xs) x, for(j=[range[1]+1:1:len(v)-1]) v[j]];

rotl = function (v,l=1) let(i0=mod(l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];
rotr = function (v,l=1) let(i0=mod(-l-1,len(v))) [for(i=[i0+1:1:len(v)-1]) v[i],  for(i=[0:1:i0]) v[i]];

sublist = function (s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) [for(i=[b:1:e-1]) s[i] ];

slice = function (v, begin, step, end, range)
  let(r = is_undef(range) ? begin : range)
  is_range(r) ?
    [for(i=clamp_range(v,r[0],r[1],r[2])) v[i]] :
    [for(i=clamp_range(v,begin,step,end)) v[i]];

pairs = function(v) len(v) < 2 ? [] :
  [for (i=[0:len(v)-2]) [v[i], v[i+1]]];

