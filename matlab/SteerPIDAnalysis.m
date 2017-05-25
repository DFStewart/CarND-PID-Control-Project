%%
% Legend append from here:
clear all; clc; close all;
%% 
out(1).data  = load_csv('testdata_kp_0_01.csv');
out(2).data  = load_csv('testdata_kp_0_05.csv');
out(3).data  = load_csv('testdata_kp_0_07.csv');
out(4).data  = load_csv('testdata_kp_0_1.csv');
out(5).data  = load_csv('testdata_kp_0_3.csv');
out(6).data  = load_csv('testdata_kp_0_5.csv');
out(7).data  = load_csv('testdata_kI_0_01.csv');
out(8).data  = load_csv('testdata_kI_0_001.csv');
out(9).data  = load_csv('testdata_kI_0_0001.csv');
out(10).data = load_csv('testdata_kd_0_5.csv');
out(11).data = load_csv('testdata_kd_1_5.csv');
out(12).data = load_csv('testdata_Kp_0_07_Ki_0_001_Kd_1_7.csv');
out(13).data = load_csv('testdata_kp_0_1_ki_0_0002_kd_2_5.csv');
%% Proportional Gain Analysis
% CTE
for k=1:6
    figure(1);hold on;
    plot(out(k).data.cte,'.-');
    ylabel('\bfCTE (P ERROR)'); 
    xlabel('\bfTime'); 
end
title('\bfCTE for Different kP values');
grid minor;
legend('kP 0.01','kP 0.05','kP 0.07','kP 0.1','kP 0.3','kP 0.5');
%% Integral Gain Analysis
% I Error
for k=7:9
    figure(2);hold on;
    plot(out(k).data.i_error,'.-');
    ylabel('\bfI ERROR'); 
    xlabel('\bfTime'); 
end
title('\bfI Error for Different kI values');
grid minor;
legend('kI 0.01','kI 0.001','kI 0.0001');
% CTE
figure(3);
plot(out(2).data.cte,'.-');hold on;
plot(out(8).data.cte,'.-');hold off;
ylabel('\bfCTE'); 
xlabel('\bfTime'); 
title('\bfPI vs P Control Responses');
grid minor;
legend('kP 0.05','kP 0.05 kI 0.001');
%% Derivative Gain Analysis
% D Error
for k=10:11
    figure(4);hold on;
    plot(out(k).data.d_error,'.-');
    ylabel('\bfD ERROR'); 
    xlabel('\bfTime'); 
end
title('\bfD Error for Different kD values');
grid minor;
legend('kI 0.5','kD 1.5');
% CTE
figure(5);
plot(out(8).data.cte,'.-');hold on;
plot(out(11).data.cte,'.-');hold off;
ylabel('\bfCTE'); 
xlabel('\bfTime'); 
title('\bfPI vs PID Control Responses');
grid minor;
legend('kP 0.05 kI 0.001','kP 0.05 kI 0.001 kD 1.5');
%% Fine Tuning Gains Analysis
% CTE
figure(6);
plot(out(11).data.cte,'.-');hold on;
plot(out(13).data.cte,'.-');hold off;
ylabel('\bfCTE'); 
xlabel('\bfTime'); 
title('\bf Fine Tuning PID Gains');
grid minor;
legend('kP 0.05 kI 0.001 kD 1.5','kP 0.1 kI 0.0002 kD 2.5');