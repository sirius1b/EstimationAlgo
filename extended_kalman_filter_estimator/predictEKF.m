function [X2,P2] = predictEKF(f,X1,P1,Jf,Q)
    global u dt;
    % f: function handle x_dot
    % X1: k-1 posterior X^+
    % P1: k-1 posterior P^+
    % Jf: function handle jacobian del f/del X 
    % Q: covariance matrix
    %
    % X2: k prior X^-
    % phi: del F \ del X
    % P2 : k prior P^-
    X2 = rk4(f,X1,u,0,dt);
    phi = expm(Jf(X1));
    P2 = phi*P1*phi' + Q;
end