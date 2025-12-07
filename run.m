% run.m - compact runner for gps_solve
clear; clc;

% --- Input ---
satPos = [1 2 0; 2 0 2; 1 1 1; 2 1 0];
tVec   = [11.99; 8.23; 33.30; 10.47];

% --- Solve (algebraic, no display inside) ---
[solutions, condA] = gps_solve(satPos, tVec);
if isempty(solutions)
    fprintf('No algebraic candidates (no real intersection).\n'); return;
end

% --- Residual metric ---
rmat = solutions(:,6:9);
maxAbsRes = max(abs(rmat),[],2);

% --- Selection: prefer t >= max(tVec) with small residuals, else min residual ---
tMax = max(tVec); tol = 1e-3;
phys = find(solutions(:,1) >= tMax & maxAbsRes <= tol);
if ~isempty(phys)
    [~,i] = min(maxAbsRes(phys)); chosen = phys(i); reason = 'physical-time + small residual';
else
    [~,chosen] = min(maxAbsRes); reason = 'smallest max residual (fallback)';
end

% --- Print concise summary ---
fprintf('cond(Axyz)=%.6g\n', condA);
for k=1:size(solutions,1)
    fprintf('cand %d: t=%7.4f  x=%6.4f  y=%6.4f  z=%6.4f  maxRes=%8.4g\n', ...
        k, solutions(k,1), solutions(k,2), solutions(k,3), solutions(k,4), maxAbsRes(k));
end
fprintf('\nChosen: cand %d (%s)\n  t=%.8g  x=%.8g  y=%.8g  z=%.8g\n', ...
    chosen, reason, solutions(chosen,1), solutions(chosen,2), solutions(chosen,3), solutions(chosen,4));
fprintf('Residuals r1..r4: '); fprintf(' %8.4g', solutions(chosen,6:9)); fprintf('\n');

%% --- gpsSensor demonstration ---
% This block simulates noisy GPS readings for a stationary receiver.
% It does NOT affect algebraic candidate selection.
try
    gps = gpsSensor('SampleRate',1);
    N = 20;
    truePos = zeros(N,3);
    trueVel = zeros(N,3);

    pos = gps(truePos, trueVel);
    
    fprintf("gpsSensor simulated altitude noise:\n");
    disp(pos(:,3));   
catch
    fprintf("gpsSensor not available.\n");
end