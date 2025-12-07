function [solutions, condA] = gps_solve(satPos, tVec)
% gps_solve - Algebraic solver for 4-satellite GPS
% Inputs:
%   satPos : 4x3 matrix, rows = [a_i, b_i, c_i]
%   tVec   : 4x1 vector,   t_i (ms)
% Outputs:
%   solutions : Kx9 matrix, rows = [t, x, y, z, sphResid, r1, r2, r3, r4]
%   condA     : condition number of the 3x3 linear subsystem Axyz

c_light = 0.047;

% input validation
if ~isequal(size(satPos),[4,3]) || ~isequal(size(tVec),[4,1])
    error('satPos must be 4x3 and tVec must be 4x1.');
end

% baseline satellite 1
a1 = satPos(1,1); b1 = satPos(1,2); c1 = satPos(1,3); t1 = tVec(1);

% build linear system by subtracting sat1 eqn from eqns 2..4
L = zeros(3,4);
rhs = zeros(3,1);
for i = 1:3
    a = satPos(i+1,1); b = satPos(i+1,2); cp = satPos(i+1,3); ti = tVec(i+1);
    L(i,1) = 2*(a - a1);
    L(i,2) = 2*(b - b1);
    L(i,3) = 2*(cp - c1);
    L(i,4) = -2*(c_light^2)*(ti - t1);      % correct sign
    rhs(i)  = (a^2 + b^2 + cp^2) - (a1^2 + b1^2 + c1^2) + c_light^2*(ti^2 - t1^2);
end

% partition and diagnostic
Axyz = L(:,1:3);
Atcol = L(:,4);
condA = cond(Axyz);

if rcond(Axyz) < 1e-12
    warning('Axyz nearly singular (rcond < 1e-12). Geometry may be ill-conditioned.');
end

% parametrize xyz = P + Q*t
P = Axyz \ rhs;
Q = - (Axyz \ Atcol);

% quadratic coefficients for ||P + Q t||^2 = 1
Acoef = dot(Q,Q);
Bcoef = 2 * dot(P,Q);
Ccoef = dot(P,P) - 1;

% solve scalar quadratic for t
if abs(Acoef) < 1e-14
    if abs(Bcoef) < 1e-14
        error('Degenerate sphere equation (constant). No unique t.');
    end
    tCand = - Ccoef / Bcoef;
else
    disc = Bcoef^2 - 4*Acoef*Ccoef;
    if disc < -1e-12
        solutions = [];
        fprintf('No real intersection of line with unit sphere (disc < 0).\n');
        return;
    end
    disc = max(disc,0);
    tCand = [(-Bcoef + sqrt(disc)) / (2*Acoef); (-Bcoef - sqrt(disc)) / (2*Acoef)];
end

% evaluate algebraic candidates and return rows
solutions = [];
for k = 1:numel(tCand)
    tval = tCand(k);
    xyz = P + Q * tval;                 % 3x1
    sphResid = xyz.' * xyz - 1;         % scalar (should be ~0)
    d = c_light * (tval - tVec);        % 4x1
    rvals = ( (xyz(1)-satPos(:,1)).^2 + (xyz(2)-satPos(:,2)).^2 + (xyz(3)-satPos(:,3)).^2 ) - d.^2; % 4x1
    row = [tval, xyz.', sphResid, rvals.'];   % 1x9
    solutions = [solutions; row];
end

end
