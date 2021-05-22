
-- 1) Sum = 0
-- 2) For each row i
-- a) For each col j
-- i) Sum = Sum + (Filter[i,j] * Window[i,j])
-- 3) Result = Max(Sum, 0)