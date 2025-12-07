# MATLAB Algebraic GPS (Kalman Method)

This repository implements the algebraic GPS position solution described in  
**Dan Kalman (2002), “An Underdetermined Linear System for GPS.”**  
The project computes the two candidate receiver positions from four satellite signals and illustrates basic GPS noise using MATLAB’s `gpsSensor`.

---

## Files

### `gps_solve.m`
Algebraic solver implementing Kalman’s method.

- **Input:**  
  `satPos` (4×3 satellite coordinates), `tVec` (4×1 transmit times)
- **Output:**  
  `solutions` — rows of `[t, x, y, z, sphResid, r1–r4]`  
  `condA` — condition number of the 3×3 subsystem  
- Note: This function **does not** select a candidate; it returns both algebraic solutions.

### `run.m`
Example script that:

1. Calls `gps_solve`
2. Computes residuals for each algebraic candidate  
3. Selects the preferred candidate using:
   - Physical-time rule \(t \ge \max_i t_i\) when possible  
   - Otherwise, smallest residual
4. Prints a concise summary  
5. Shows a minimal `gpsSensor` noise demonstration (altitude only)

---

## Quick Start

```matlab
satPos = [1 2 0;
          2 0 2;
          1 1 1;
          2 1 0];
tVec = [11.99; 8.23; 33.30; 10.47];

[solutions, condA] = gps_solve(satPos, tVec);
run   % prints chosen candidate + gpsSensor noise summary
