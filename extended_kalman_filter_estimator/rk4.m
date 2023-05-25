function x = rk4(f,x0,u,pnoise,h)
    k1 = f(x0,u,pnoise);
    k2 = f(x0 + h*k1*0.5,u,pnoise);
    k3 = f(x0 + h*k2*0.5,u,pnoise);
    k4 = f(x0 + h*k3,u,pnoise);
    x = x0 + h*(k1 + 2*k2 + 2*k3 + k4)/6;
end