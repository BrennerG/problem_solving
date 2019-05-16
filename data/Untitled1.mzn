
array[1..3, 1..3] of var 1..50: test1;
array[1..3, 1..3] of var 0..1: test2;

constraint
  forall(i in 1..3, j in 1..3)(
    if test1[i, j] > 20 then
      test2[i, j] = 1
    endif
  );


constraint
  test2[1, 1] = 0;

