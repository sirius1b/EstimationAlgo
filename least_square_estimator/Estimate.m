clear ; clc;
format long;
t = readtable('sat_data_V1A1.csv');
X_current = [0;0;0;0]; % cold start
nSat = 12;
TimeInstants = unique(t.Time_ms);
t_car = readtable('motion_V1.csv');

Pos1 = []; % ECEF
Pos2 = []; % Lat Long

errorPos = []; % del_x , del_y , del_z
PDOPs = [];
res = [];
for time = TimeInstants'
    disp(time)
    flag = t.Time_ms == time;
    t1  = t(flag,:);
    if nSat <= height(t1)
        data = zeros(nSat,4); % x_pos , y_pos , z_pos , p_range
        data(:,1) = t1.Sat_Pos_X(1:nSat,:);
        data(:,2) = t1.Sat_Pos_Y(1:nSat,:);
        data(:,3) = t1.Sat_Pos_Z(1:nSat,:);
        data(:,4) = t1.P_RangeL1(1:nSat,:) ;
    end
    data(~any(data,2),:) = [];
    compute = true;
    while compute 
        rho_hat = estimate_rho(data,X_current);
        H = H_matrix(data,X_current);
        delta_rho = rho_hat - data(:,4);    
        delta_x =   pinv(H)*delta_rho;
        X_current = X_current + delta_x;            
        if (delta_x <= 1e-8)
            compute = false;
        end
    end
    res = [res;norm([delta_rho - H*delta_x])];
    DH = inv(H'*H);
    PDOPs = [PDOPs ; sqrt(DH(1,1) + DH(2,2) + DH(3,3))];
    Pos1 = [Pos1; X_current']; 
    Pos2 = [Pos2; ecef_to_wgs84(X_current) ];
    flag2 = t_car.Time_ms == time;
    t_car_small = t_car(flag2,:);
    errorPos = [errorPos;[t_car_small.Pos_X - X_current(1),t_car_small.Pos_Y - X_current(2),t_car_small.Pos_Z - X_current(3)]];
end
Pos2(:,1:2) = 180*(Pos2(:,1:2)/pi);

% --------------- Plotting ---------------------
show_plot;
% ----------------------------------------------


function rho_hat = estimate_rho(data,X0)
    X = data(:,1:3) - X0(1:3)';
    rho_hat = sqrt(sum(X.^2,2)) + X0(4);
end

function H = H_matrix(data,X0)
    H = zeros(length(data(:,1)),4);
    H(:,4) = -ones(length(data(:,1)),1);
    mat = X0(1:3)' - data(:,1:3);
    n = vecnorm(mat,2,2);
    for i = 1:length(n)
        mat(i,:) = mat(i,:)/n(i);
    end
    H(:,1:3)  = -mat;    
end

function point = ecef_to_wgs84(X) % x,y,zu,ct
%########### WGS-84 #############
    a = 6378137.0;
    b = 6356752.314245;
    f = 1/298.257223563;
    e1 =  sqrt(2*f - f^2) ; %  sqrt((a^2 - b^2)/a^2)
    e2  = sqrt((a^2 - b^2)/b^2);
%################################

    p = sqrt(X(1)^2 + X(2)^2);
    theta = atan2(X(3)*a,p*b);
    long = atan2(X(2),X(1));
    lat = atan2((X(3) + (e2^2)*b*(sin(theta)^3) ),(p - (e1^2)*a*(cos(theta)^3)));
    N =  a/sqrt(1 - (e1*sin(lat))^2);
    h = p/cos(lat) - N;
    point = [lat,long,h];
end
