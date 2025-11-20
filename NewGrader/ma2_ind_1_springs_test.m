function [wireLen, springMass] = ma2_ind_1_springs_test(diams,numCoils)

%% INITIALIZATION
metalDen = 7.861;   % spring wire density (g/cm^3)

%% ____________________
%% CALCULATIONS

if numel(diams) ~= 2 || numel(numCoils) ~= 1
    fprintf(2,"Inputs have incorrect dimensions\n")
    wireLen = -110;
    springMass = wireLen;
elseif diams(1) > 0.95*diams(2)
    fprintf(2,"The inner diameter value is larger than allowed\n")
    wireLen = -27;
    springMass = wireLen;
elseif ~all(diams >= 2.5 & diams <= 30)
    fprintf(2,"Diameter values must be between 2.5 and 30 cm, inclusive\n")
    wireLen = -99;
    springMass = wireLen;
elseif numCoils < 4
    fprintf(2,"The spring must have at least 4 coils\n")
    wireLen = -78;
    springMass = wireLen;
else
    % calculate wire length
    wireLen = pi*numCoils*(diams(2) + diams(1))/2;

    % calculate spring mass
    springMass = metalDen*wireLen*(diams(2) - diams(1))^2;
end

%% ____________________
%% FORMATTED TEXT DISPLAY

% diplay the wire length and spring mass values
fprintf("Wire length: %.2f cm\n",wireLen)
fprintf("Spring Mass: %0.2f g\n",springMass)
end