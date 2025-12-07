# GPS Algebraic Script in MATLAB

MATLAB implementation based on *An Underdetermined Linear System for GPS* - Dan Kalman (2002). Includes diagnostics and example data.

## Purpose
This repository contains a MATLAB implementation of Kalman's algebraic solution for the 4-satellite GPS problem (idealized geometric model). The code computes the algebraic candidate solutions for receiver position and time, reports residuals against the original range equations, and returns physically plausible solutions (time at or after the latest satellite transmit time). It also prints the condition number of the 3×3 linear subsystem to show geometry-induced sensitivity.

## Files
- `gps_solve.m` - Main MATLAB function.  
  **Inputs:** `satPos` (4×3 matrix), `tVec` (4×1 vector).  
  **Outputs:** `solutions` (candidate rows containing `[t, x, y, z, sphResid, r1, r2, r3, r4]`), `physSolutions` (subset with `t >= max(t_i)`), `condA` (condition number of the 3×3 linear subsystem).
- `example_run.m` - Example script: runs `gps_solve` with canidate selection, results display, and basic `gpsSensor` showcase. 
- `code.zip`- Zip containing `gps_solve.m` and `example_run.m` for easy upload to MATLAB Online or the GUI.

## Quick usage
```matlab
% in MATLAB
satPos = [1 2 0; 2 0 2; 1 1 1; 2 1 0];
tVec   = [11.99; 8.23; 33.30; 10.47];
[sols, phys, condA] = gps_solve(satPos, tVec);
```
