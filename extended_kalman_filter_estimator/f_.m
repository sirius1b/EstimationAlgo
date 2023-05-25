function x_dot = f_(x,u,pnoise)
    x_dot = [0, 1, 0; 0, 0, -1; 0, 0, 0;]*x + [0 ; 1 ; 0]*u + pnoise;    
end