% This configuration file defines the tests for "Lab 1".
warning('off', 'all');

% --- Script Names ---
solution_script_name = 'solution.m';
student_script_name = glob('ma1_ind_2_*.m'){1,1};

global AUTOGRADER_INPUTS
global AUTOGRADER_INDEX
AUTOGRADER_INDEX = 1;
AUTOGRADER_INPUTS = {{'15'},{'30'},{'10'}};


% --- Test Definitions ---
% A cell array of the variable nam'es to check.
variables_to_test = { };

% An array of the points for each corresponding variable test.
max_points = 4.5;
terminal_test_points = 1.4; %4.9/length(AUTOGRADER_INPUTS) - ;
file_check_points = .3;
%test_fraction = ones(1, length(variables_to_test)) / length(variables_to_test);
test_fraction = 0; %No Variables to test
test_points = (max_points - terminal_test_points - file_check_points) * test_fraction;

% A cell array of names for each test as they will appear on Gradescope.
test_names = variables_to_test;
