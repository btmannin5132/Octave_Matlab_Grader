function ma2_ind_1_springs_shaw286(d, n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: Fall 2025
%
% Description: This program computes the wire length and spring mass of
% several sample dimensions and prints a relevant error if the inputs
% are invalid.
%
% Assignment Information:
%     Assignment:     16.3.2 MA2 Ind 1 (for MATLAB 1 Team task 1)
%     Team ID:        LC3 - 13 (e.g. LC1 - 01; for section LC1, team 01)
%     Author:         Ethan Shaw, shaw286@purdue.edu
%     Date:           11/16/2025
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

%% INITIALIZATION
density = 7.861;
d0 = d(1);
di = d(2);
relative_d = .95 * di;
%% CALCULATIONS
wire_length = .5 * pi * n * (d0 + di);
spring_mass = density * wire_length * (d0 - di) ^ 2;
%% FORMATTED TEXT & FIGURE DISPLAYS
if size(d) ~= 2
    disp('Inputs have incorrect dimensions');
    disp('Wire length: -110.00 cm');
    disp('Spring Mass: -110.00 g');
elseif d0 > relative_d
    disp('The inner diameter value is larger than allowed')
    disp('Wire length: -27.00 cm');
    disp('Spring Mass: -27.00 g');
elseif d0 < 2.5 || d0 > 30
    disp('Diameter values must be between 2.5 and 30 cm, inclusive')
    disp('Wire length: -99.00 cm');
    disp('Spring Mass: -99.00 g');
elseif di < 2.5 || di > 30
    disp('Diameter values must be between 2.5 and 30 cm, inclusive')
    disp('Wire length: -99.00 cm');
    disp('Spring Mass: -99.00 g');
elseif n < 4
    disp('The spring must have at least 4 coils')
    disp('Wire length: -78.00 cm');
    disp('Spring Mass: -78.00 g');
else
    fprintf('Wire length: %.2f cm\n', wire_length);
    fprintf('Spring Mass: %.2f g\n', spring_mass);
end
%% COMMAND WINDOW OUTPUT
% ma2_ind_1_springs_shaw286([10, 12], 10)
% Wire length: 345.58 cm
% Spring Mass: 10866.27 g
% ma2_ind_1_springs_shaw286([2.5, 3], 6)
% Wire length: 51.84 cm
% Spring Mass: 101.87 g
% ma2_ind_1_springs_shaw286([15.75, 20], 3)
% The spring must have at least 4 coils
% Wire length: -78.00 cm
% Spring Mass: -78.00 g
% ma2_ind_1_springs_shaw286([5, 5.8, 6.2], 12)
% Inputs have incorrect dimensions
% Wire length: -110.00 cm
% Spring Mass: -110.00 g
% ma2_ind_1_springs_shaw286([14.5, 15], 10)
% The inner diameter value is larger than allowed
% Wire length: -27.00 cm
% Spring Mass: -27.00 g
% ma2_ind_1_springs_shaw286([6, 5.5], 8)
% The inner diameter value is larger than allowed
% Wire length: -27.00 cm
% Spring Mass: -27.00 g
% ma2_ind_1_springs_shaw286([0.5, 2], 15)
% Diameter values must be between 2.5 and 30 cm, inclusive
% Wire length: -99.00 cm
% Spring Mass: -99.00 g

end