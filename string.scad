// String-specific functions

join = function (l,delimiter="") 
  let(s = len(l), d = delimiter,
      jb = function (b,e) let(s = e-b, m = floor(b+s/2)) // join binary
        s > 2 ? str(jb(b,m), jb(m,e)) : s == 2 ? str(l[b],l[b+1]) : l[b],
      jd = function (b,e) let(s = e-b, m = floor(b+s/2))  // join delimiter
        s > 2 ? str(jd(b,m), d, jd(m,e)) : s == 2 ? str(l[b],d,l[b+1]) : l[b])
  s > 0 ? (d=="" ? jb(0,s) : jd(0,s)) : "";

substr = function(s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) (b==e) ? "" : join([for(i=[b:1:e-1]) s[i] ]);

split = function(s,separator=" ") separator=="" ? [for(i=[0:1:len(s)-1]) s[i]] :
  let(t=separator, e=len(s), f=len(t),
    _s=function(b,c,d,r) b<e ?
      (s[b]==t[c] ?
        (c+1 == f ?
          _s(b+1,0,b+1,concat(r,substr(s,d,b-c))) : // full separator match, concat substr to result
          _s(b+1,c+1,d,r) ) : // separator match char, more to test
        _s(b-c+1,0,d,r) ) : // separator mismatch
      concat(r,substr(s,d,e))) // end of input string, return result
  _s(0,0,0,[]);

fixed = function(x,w,p,sp="0")
  assert(len(sp)==1)
  let(mult = pow(10,p), x2 = round(x*mult)/mult,
    lz = function (x, l) l>1 && abs(x) < pow(10,l-1) ? str(sp, lz(x,l-1)) : "",
    tz = function (x, t) let(mult=pow(10,t-1)) t>0 && abs(floor(x*mult)-x*mult) < 1e-9 ? str(sp, tz(x,t-1)) : ""
  )
  str(x2<0?"-":" ", lz(x2,w-p-2), abs(x2), abs(floor(x)-x2)<1e-9 ? "." : "" ,tz(x2,p));
