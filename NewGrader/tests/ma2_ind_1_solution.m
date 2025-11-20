function [wireLen, springMass] = ma2_ind_1_solution(diams,numCoils)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: Spring 2025
%
% Function Call:
%     [wireLen, springMass] = ma3_ind_1_springs_solution(diams,numCoils)
%
% Input Arguments:
%     diams:    two-element vector with inner spring diameter as first element
%               and outer spring diameter as second element (cm)
%     numCoils: number of coils in the spring (unitless) (scalar)
%
% Output Arguments:
%     wireLen:  spring wire length (cm)
%     springMass:   spring mass (g)
%
% Description:
%     This program accepts spring diameters and number of coils and determins the spring
%     wire length and mass
%
% Assignment Information:
%     Assignment:     16.3.1 MA3 Ind 1
%     Team ID:        LC0 - 00
%     Author:         Name, login@purdue.edu
%     Date:           e.g. 03/24/2025
%
% Contributor:
%     Name, login@purdue [repeat for each]
%
%     My contributor(s) helped me:
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%     Note that if you helped somebody else with their code, you
%     have to list that person as a contributor here as well.
%
% Academic Integrity Statement:
%     I have not used source code obtained from any unauthorized
%     source, either modified or unmodified; nor have I provided
%     another student access to my code.  The project I am
%     submitting is my own original work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
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


%% ____________________
%% RESULTS

% -- Test Case 1
% [wireLen, springMass] = ma3_ind_1_springs_solution([10 12],10);
% Wire length: 345.58 cm
% Spring Mass: 10866.27 g

% -- Test Case 2
% [wireLen, springMass] = ma3_ind_1_springs_solution([2.5 3],6);
% Wire length: 51.84 cm
% Spring Mass: 101.87 g

% -- Test Case 3
% [wireLen, springMass] = ma3_ind_1_springs_solution([15.75 20],3);
% The spring must have at least 4 coils
% Wire length: -78.00 cm
% Spring Mass: -78.00 g

% -- Test Case 4
% [wireLen, springMass] = ma3_ind_1_springs_solution([5 5.8 6.2],12);
% Inputs have incorrect dimensions
% Wire length: -110.00 cm
% Spring Mass: -110.00 g

% -- Test Case 5
% [wireLen, springMass] = ma3_ind_1_springs_solution([14.5 15],10);
% The inner diameter value is larger than allowed
% Wire length: -27.00 cm
% Spring Mass: -27.00 g

% -- Test Case 6
% [wireLen, springMass] = ma3_ind_1_springs_solution([6 5.5],8);
% The inner diameter value is larger than allowed
% Wire length: -27.00 cm
% Spring Mass: -27.00 g

% -- Test Case 7
% [wireLen, springMass] = ma3_ind_1_springs_solution([0.5 2],15);
% Diameter values must be between 2.5 and 30 cm, inclusive
% Wire length: -99.00 cm
% Spring Mass: -99.00 g