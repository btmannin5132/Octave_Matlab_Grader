% This configuration file defines the tests for "Lab 1".

% --- Script Names ---
solution_script_name = 'ma2_ind_1_solution.m';
try
  student_script_name = glob('ma2_ind_1_springs_*.m'){1,1};
catch
  student_script_name = "ma2_ind_1_springs_YourUserName.m";
end
##% --- Test Definitions ---
##% A cell array of the variable names to check.
##variables_to_test = {'scalar_a', 'vector_b', 'user_greeting'};
##
##% An array of the points for each corresponding variable test.
##test_points = [2.0, 3.0, 2.0];
##
##% A cell array of names for each test as they will appear on Gradescope.
##test_names = {
##    'Check scalar variable ''scalar_a''',
##    'Check vector ''vector_b''',
##    'Check string ''user_greeting'''
##};

% A cell array of test cases, where each cell contains {function_name, {arguments}}
function_tests = {
      {[10 12],10},
     {[2.5 3],6},
     {[15.75 20],3}
     };

% An array of the points for each corresponding function test.
function_points = [1.36666666667, 1.36666666667,1.36666666667];
