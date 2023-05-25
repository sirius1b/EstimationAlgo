% 1.1 Lat Long plot on Map
figure;
geoplot(Pos2(:,1),Pos2(:,2),'r-'); hold on;
geoplot(rad2deg(t_car.Lat),rad2deg(t_car.Long),'b-');
legend("Estimated Position", "Actual Position");

% 1.2 Lat Long plot on axis
figure;
subplot(2,1,1);
plot(TimeInstants,Pos2(:,1));
title("Estimated Lattitude vs Time");
xlabel("Time(ms)");
ylabel("Lattitude(deg)");
grid on;
subplot(2,1,2);
plot(TimeInstants,Pos2(:,2));
title("Estimated Longitude vs Time");
xlabel("Time(ms)");
ylabel("Longitude(deg)");
grid on;

% 2. Estimation error
figure;
plot(TimeInstants,sqrt(sum(errorPos.*errorPos,2)));
title("L_2 norm of Actual_{pos} - Estimated_{pos}");
xlabel("Time(ms)");
ylabel("Estimation Error(m)");
grid on;

% 3. PDOP 
figure;
plot(TimeInstants,PDOPs);
title("PDOP(at the last iteration of X computation) vs Time");
xlabel("Time(ms)");
ylabel("PDOP");
grid on;

% 4. Residue vs Time
figure;
plot(TimeInstants,res);
title("L_2 norm of Residue vs Time");
xlabel("Time(ms)");
ylabel("Residue");
grid on;

fprintf("done\n");