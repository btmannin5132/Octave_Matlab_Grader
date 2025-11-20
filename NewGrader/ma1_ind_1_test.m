%% INITIALIZATION
tank_r = 1.25; % tank inner radius (m)
tank_l = 5.5; % tank inner length (m)
tank_h = tank_r*2 ; % tank height (diameter) (m)
min_height = 0.2; % volume capacity limit (%)
sensors_inc = 0.1; % tank has sensors every 0.1 m in height


%% ____________________
%% CALCULATIONS
% Calculate the max tank volume (m^3) at 100% capacity
max_tank_volume = tank_l*(acos((tank_r-tank_h)/tank_r))*tank_r^2-...
    (tank_r-tank_h)*sqrt(2*tank_r*tank_h-tank_h^2);

% Calculate the volume (m^3) when the tank is 20% full
threshold = min_height*max_tank_volume;

% Initialize the loop
fluid_height = tank_h; % assume tank is full (m)
idx = 1; % initialize the index
% calcluate volume of tank when fluid_height = tank_h (m^3)
fluid_vol = tank_l*(acos((tank_r-fluid_height)/tank_r)*tank_r^2-...
        (tank_r-fluid_height)*sqrt(2*tank_r*fluid_height-fluid_height^2));

% Loop
while fluid_vol(idx) > threshold
    idx = idx + 1;
    fluid_height(idx) = fluid_height(idx-1) - sensors_inc;
    fluid_vol(idx) = tank_l*(acos((tank_r-fluid_height(idx))/tank_r)*tank_r^2-...
        (tank_r-fluid_height(idx))*sqrt(2*tank_r*fluid_height(idx)-fluid_height(idx)^2));
end

numIterations = idx-1; %The number of iterations is one less than then index value
final_fluid_height = fluid_height(idx);
final_fluid_vol = fluid_vol(idx);

%% ____________________
%% OUTPUTS
fprintf('Number of iterations = %g\n',numIterations)
fprintf('Remaining volume = %.2f m^3\n',final_fluid_vol)
fprintf('Fluid height= %.2f m\n',final_fluid_height)
disp('WARNING: The tank is now below 20 % capacity. Please refill.')