# MATLAB Algebraic GPS (Kalman Method)

MATLAB implementation of the algebraic GPS solution from  
Kalman (2002), “An Underdetermined Linear System for GPS.”
Computes two candidate receiver locations from four satellites and includes a minimal GPS noise demo.


## Files
- **gps_solve.m** - Returns algebraic candidates `[t, x, y, z, r1–r4]` and `condA`.  
- **run.m** - Selects the better candidate (time rule, residuals) and shows brief `gpsSensor` noise output.
- **code.zip** - Contains `gps_solve.m` and `run.m` files.
- **report.pdf** - Write-up summarizing the method and results for a linear algebra deliverable.

---

## Usage
```matlab
[solutions, condA] = gps_solve(satPos, tVec);
run   % prints chosen candidate + gpsSensor summary
```

## Example
```matlab
cand1: t=19.40  maxRes=10.03
cand2: t= 9.67  maxRes= 4.29
Chosen: cand2

```
---

## References
Kalman (2002); MathWorks (gpsSensor).