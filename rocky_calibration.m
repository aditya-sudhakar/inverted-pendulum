%Rocky Calibration

format longg

step_mag = 300;

measurement_delta_time = 0.02;  % 20 ms

time = 0:measurement_delta_time:measurement_delta_time * (length(left) - 1);

plot(time, left, 'b', time, right, 'r')
legend("Left", "Right")
title("Velocity over time")
xlabel("Time (s)")

left_steady_state = left(time > 1);
left_steady_state_average = mean(left_steady_state)
left_K = left_steady_state_average / step_mag

right_steady_state = right(time > 1);
right_steady_state_average = mean(right_steady_state)
right_K = right_steady_state_average / step_mag

time_constant_pcnt = 1-exp(-1)

left_time_constant_target = time_constant_pcnt * left_steady_state_average
left_time_constant = find(left>left_time_constant_target, 1, 'first') * measurement_delta_time

right_time_constant_target = time_constant_pcnt * right_steady_state_average
right_time_constant = find(right>right_time_constant_target, 1, 'first') * measurement_delta_time

a = 1/(right_time_constant)
b = right_K

%Gyro calibration

measured_length = 0.5;  % meter
g = 9.8;

measurement_delta_time = 0.05  % 50 ms
time = 0:measurement_delta_time:measurement_delta_time * (length(gyro) - 1);

plot(time, gyro)
xlabel("seconds")
ylabel("angle")
gyro_interest = gyro; %gyro((time > 10) & (time < 35))
findpeaks(gyro_interest)

[pks, locs] = findpeaks(gyro_interest);
peak_times = time(locs)
freq = (length(peak_times) - 1)/(peak_times(end) - peak_times(1)) * pi * 2

effective_length = (g / freq^2)
