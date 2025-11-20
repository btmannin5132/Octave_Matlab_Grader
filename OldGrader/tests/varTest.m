  %variable testing
  %Collect solution variables
  function [json_parts,student_run_error] = varTest(student_run_error)
    run('test_config.m');
    json_parts = {};

  try
    disp("Solution Terminal output:");
    [solution_vars,solution_data] = runSubmission(solution_script_name, variables_to_test);
    %disp("solution ran properly");
    % Save all current variables to a structure

    disp("solution data")
    disp(solution_data)
  catch ME
    output_msg = sprintf('An error occurred while running the solution script. Please try again.  If problem persists, please contact instructor.\\n');
    student_run_error = true;
    disp(output_msg);
    json_parts{end+1} = build_json_test('Script Execution', sum(test_points), 0, output_msg, 'visible');

  end

  % Clear all variables except for the ones we want to keep
  %clearvars -except solution_data student_run_error;
  %run('test_config.m');

  %Collect submission variables

  try
    disp("Student Terminal output:");
    [student_vars,student_data] = runSubmission(student_script_name, variables_to_test);

  disp("student data")
  disp(student_data)
  catch ME
    student_run_error = true;
    student_error_message = json_escape(ME.message);
  end

  if (student_run_error)
    output_msg = sprintf('An error occurred while running your submission script. Please check file name and your variables are labeled accordingly. \n');
    json_parts{end+1} = build_json_test('Script Execution', sum(test_points), 0, output_msg, 'visible');
    disp(output_msg);
  else

    for i = 1:length(variables_to_test)
      varCheck = 0;
      valCheck = 0;
      try
        student_data.(variables_to_test{1,i});
        varCheck = 1;
      end
      try
          if isequal(student_data.(variables_to_test{1,i}), solution_data.(variables_to_test{1,i}))
            valCheck = 1;
          endif

          end
      #solution_data.(variables_to_test{1,i})
      if varCheck == 0
        output_msg = sprintf('Variable \"%s\" not found in submission.  Please name variables as requested and submit again.', variables_to_test{1,i});
        json_parts{end+1} = build_json_test(test_names{i,1}, test_points(i), 0, output_msg, 'visible');
        disp(output_msg);
      elseif valCheck == 0
        output_msg = sprintf('Variable \"%s\" not correct.  expected value: %s, given value: %s', variables_to_test{1,i}, num2str(solution_data.(variables_to_test{1,i})), num2str(student_data.(variables_to_test{1,i})));
        json_parts{end+1} = build_json_test(test_names{i,1}, test_points(i), 0, output_msg, 'visible');
        disp(output_msg);
      elseif (varCheck ==1 & valCheck == 1)
        output_msg = sprintf('Checked Variable \"%s\": Correct!', variables_to_test{1,i});
        disp(output_msg);
        json_parts{end+1} = build_json_test(test_names{i,1}, test_points(i), test_points(i), output_msg, 'visible');
      end

    end

  endif
end

function json_str = build_json_test(name, max_score, score, output, visibility)
  % Manually constructs a JSON object string for a single test.
  json_str = sprintf(['{"name": "%s", "max_score": %.1f, "score": %.1f, ' ...
  '"output": "%s", "visibility": "%s"}'], ...
  json_escape(name), max_score, score, json_escape(output), visibility);
end

function str = json_escape(str_in)
  % Escapes characters for safe JSON embedding.
  str = strrep(str_in, '\', '\\');
  str = strrep(str, '"', '\"');
  str = strrep(str, sprintf('\n'), '\n');
end
