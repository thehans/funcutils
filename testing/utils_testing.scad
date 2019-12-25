function lstr(s) = is_string(s) ? str(s,"\"") : s;
function rstr(s) = is_string(s) ? str("\"",s) : s;

module Test(test, result) {
  echo(str(lstr(test), " == ", rstr(result)));
  assert(test == result);
}

