// Elementary Operators

// Comparators
eq = function (x,y) x==y;
ne = function (x,y) x!=y;
lt = function (x,y) x<y;
gt = function (x,y) x>y;
le = function (x,y) x<=y;
ge = function (x,y) x>=y;

// Arithmetic unary ops
ident = function (x) x;
neg   = function (x) -x;
inc   = function (x) x+1;
dec   = function (x) x-1;

// Arithmetic binary ops
add = function (x,y) x+y;
sub = function (x,y) x-y;
mul = function (x,y) x*y;
div = function (x,y) x/y;
rem = function (x,y) x%y; // remainder operator
mod = function (x,y) let(r=x%y) r<0 ? r+abs(y) : r; // modulo operator, returns non-negative value range: [0,y)

// Boolean unary ops
not  = function (x) !x;

// Boolean binary ops
and  = function (x,y) x&&y;
or   = function (x,y) x||y;
xor  = function (x,y) (x||y) && !(x&&y);
nand = function (x,y) !(x&&y);
nor  = function (x,y) !(x||y);
xnor = function (x,y) (x&&y) || ((!x)&&(!y)); 

//are_comparable = function (x,y,cmp=lt) let(a=cmp(x,y), b=cmp(y,x)) xor(a,b);