function [X1 , P1] = updateEKF(X2,P2,z_meas,h,Jh,R,H)
    % X2: k prior X^-
    % P2: k Prior P^- 
    % z_meas : measurement
    % h : function handle z = h(X)
    % Jh : function handle jacobian del H/del X 
    % R : Covariance Matrix
    % Hm: H evluated at 
    %
    H = Jh(X2);
    
    K = P2*(H')/(H*P2*(H') + R);
    X1 = X2 - K*(z_meas - h(X2));
    P1 = (eye(length(X1)) - K*H)*P2*((eye(length(X1)) - K*H)') + K*R*(K');
end