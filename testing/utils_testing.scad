module Test(test, result) {
  echo(str(test, " == ", result));
  assert(test == result);
}

