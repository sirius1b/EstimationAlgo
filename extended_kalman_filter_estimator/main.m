clc;
% rng(32);
global dt u;
t0 = 1 ; tf = 300 ; dt = 1;
x = [0 ; 0]; % x at t = 0
a_true = zeros(tf - t0+1,1);
a_true(1:100) = linspace(0,0.05,100);
a_true(101:200) = 0.05;
a_true(201:300) = linspace(0.05,0,100);

t = linspace(t0,tf,(tf - t0 + 1)/dt);
X_true = zeros(2,(tf - t0+1)/dt);
Z = zeros(3,(tf - t0+1)/dt);
for i = 1:length(a_true)
    pnoise = [0 ; 0.5*randn(1)];
    x = rk4(@f,x,a_true(i),pnoise,dt) ;
    X_true(:,i) = x;
    
    mnoise = randn(3,1);
    Z(:,i) = h(x) + mnoise;
end
a_meas = a_true + 0.01 + 0.001*randn(size(a_true));


X_est = zeros(3,(tf - t0+1)/dt);
X_post = [10;0;0];
P_post = eye(length(X_post))*1;
Q = [1, 0 , 0; 0 , 1, 0 ; 0 , 0 , 10^-8];
R = [3 , 0 , 0 ; 0 , 3 , 0 ; 0 , 0 , 3];
sigmas = zeros(3,(tf - t0 +1)/dt);
for i = 1:length(a_true)
    u = a_meas(i);
    [X_prior,P_prior] =  predictEKF(@f_,X_post,P_post,@Jf_,Q);
    [X_post,P_post] = updateEKF(X_prior,P_prior,Z(:,i),@h,@Jh_,R);
    X_est(:,i) = X_post;
    sigmas(1,i) = sqrt(P_post(1,1));
    sigmas(2,i) = sqrt(P_post(2,2));
    sigmas(3,i) = sqrt(P_post(3,3));
end


figure
% subplot(2,1,1);
plot(t,sigmas(1,:),'--k');
hold on;
plot(t,X_true(1,:) - X_est(1,:));
plot(t,-sigmas(1,:),'--k');
title('x_{true} - x_{estimated}');
legend('\sigma',"Error: x_{true} - x_{estimated}")
xlabel('Time Step(seconds)')
ylabel('Residue(X_{Pos}(m))')
ylim([-4 4]);
xlim([0 300]);
grid on;

figure;
% subplot(2,1,2);
plot(t,sigmas(2,:),'--k');
hold on;
plot(t,X_true(2,:) - X_est(2,:));
plot(t,-sigmas(2,:),'--k');
title('v_{true} - v_{estimated}');
legend('\sigma',"Error: v_{true} - v_{estimated}")
xlabel('Time Step(seconds)')
ylabel('Residue(X_{Vel}(ms^{-1}))')
ylim([-4 4]);
xlim([0 300]);
grid on;

figure;
plot(t,X_true(1,:),'-b');
hold on;
plot(t,X_est(1,:),'ok','MarkerIndices',1:10:length(X_est(1,:)));
title('Position vs Time');
legend('Actual Position',"Estimated Position");
xlabel('Time Step(seconds)')
ylabel('Position(m)')
xlim([0 300]);
grid on;

figure;
plot(t,X_true(2,:),'-b');
hold on;
plot(t,X_est(2,:),'ok','MarkerIndices',1:10:length(X_est(2,:)));
title('Velocity vs Time');
legend('Actual Velocity',"Estimated Velocity");
xlabel('Time Step(seconds)')
ylabel('Velocity(ms^-1)')
xlim([0 300]);
grid on;

