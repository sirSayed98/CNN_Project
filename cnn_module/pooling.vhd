--1) Sum = 0
--2) For each row i
--a) For each col j
--i) Sum = Sum + Window[i,j]
--3) If Filter_Size == 3x3
--a) Result = Sum >> 3 (Where ?>>? is Arithmetic Shift Right)
--4) Else If Filter_Size == 5x5
--a) Result = Sum >> 5