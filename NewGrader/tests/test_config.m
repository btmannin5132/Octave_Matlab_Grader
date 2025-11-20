warning("off", "all")
tasks = {
  struct(
      'student_file', 'ma2_ind_1_springs_',
      'solution_file', 'ma2_ind_1_solution.m', 
      'file_check_points', .1,
      % General Terminal Check
      'term_check', false,
      'term_points', 2,
      % if grader is expecting terminal input:
      'input_test', false,  
      'term_args', {'','',''}, % List inputs in order for all tests  
      'inputs_per_Test', 2,
      'input_poits_per_test', [1,1,1],
      % if the grader is expecting a function
      'func_test', true,
      'func_args', {{[10 12],10}, {[2.5 3],6}, {[15.75 20],3}}, %each function call gets own cell      
      'num_outputs', 1,   % Number of return values
      'func_points_per_Test', [1,1,1]

    % Make sure all of your ponts add to what you want!
  )
  
  % You can add more structs here to test additional
};
% --- Script Names ---
