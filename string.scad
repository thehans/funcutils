// String-specific functions

substr = function(s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) (b==e) ? "" : join([for(i=[b:1:e-1]) s[i] ]);

join = function (l,delimiter="") 
  let(s = len(l), d = delimiter,
      jb = function (b,e) let(s = e-b, m = floor(b+s/2)) // join binary
        s > 2 ? str(jb(b,m), jb(m,e)) : s == 2 ? str(l[b],l[b+1]) : l[b],
      jd = function (b,e) let(s = e-b, m = floor(b+s/2))  // join delimiter
        s > 2 ? str(jd(b,m), d, jd(m,e)) : s == 2 ? str(l[b],d,l[b+1]) : l[b])
  s > 0 ? (d=="" ? jb(0,s) : jd(0,s)) : "";

fixed = function(x,w,p,sp="0")
  let(mult = pow(10,p), x2 = round(x*mult)/mult,
    lz = function (x, l, z="0") l>1 && abs(x) < pow(10,l-1) ? str(z, lz(x,l-1)) : "",
    tz = function (x, t, z="0") let(mult=pow(10,t-1)) t>0 && abs(floor(x*mult)-x*mult) < 1e-7 ? str(z, tz(x,t-1)) : ""
  )
  str(x2<0?"-":" ", lsp(x2,w-p-2,sp), abs(x2), abs(floor(x)-x2)<1e-9 ? "." : "" ,tz(x2,p,sp));
