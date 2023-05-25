function x_dot = f(x,u,pnoise)
    x_dot = [0 , 1; 0 , 0]*x + [0 ; 1]*u + pnoise;    
end