// Common higher-order functions

map = function (v, f) [for(x=v) f(x)];
// Ex:
//echo(map([1,2,3,4,5,6,7],function(x)x^2));

filter = function (v, pred) [for(x=v) if(pred(x)) x]; 
// Ex:
//echo(filter([-2,-1,0,1,2,3,4,5,6,7,8,9],function(x)mod(x,2)==1));

fold = function (i, v, f, off = 0) len(v) > off ? fold(f(i, v[off]), v, f, off + 1) : i;


forf = function (init, cond, update, func=undef) let(
    result=[for (
      state=init(),
        continue=cond(state),
        next=true;
      next;
      _=(continue && !is_undef(func)) ? func(state) : 0,
        state=continue ? update(state) : state,
        next=continue,
        continue=cond(state))
      if(!continue) state][0]
  ) result;


