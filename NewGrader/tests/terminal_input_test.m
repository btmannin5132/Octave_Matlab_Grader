function [json_parts, student_run_error] = terminal_input_test(student_run_error,task)
    global AUTOGRADER_INDEX
    global AUTOGRADER_INPUTS
    json_parts = {};
    feedback = '';
    AUTOGRADER_INDEX = 1;
    %run terminal output test
    solution_script_name = task.solution_file;
    student_script_name = task.student_file;
    AUTOGRADER_INDEX = 1;
    AUTOGRADER_INPUTS = task.term_args;
    test_points = task.term_points;
    args_per_test = task.inputs_per_Test;

fprintf("\nRunning Terminal Test with stream inputs in file %s\n",student_script_name)

while AUTOGRADER_INDEX <= length(AUTOGRADER_INPUTS)
  %disp(AUTOGRADER_INDEX)
  terminalValues = AUTOGRADER_INPUTS(AUTOGRADER_INDEX,:);
  testName = sprintf("Terminal Test with input vlaues: [ %s ]\n\n",terminalValues);
  fprintf(testName);
  try
	warning('off', 'all');

    reference_output = strip_output(evalc(['run ' solution_script_name]));
    fprintf("Reference Output:\n%s\n\n",reference_output)
    AUTOGRADER_INDEX = AUTOGRADER_INDEX-args_per_test;
	  old_index = AUTOGRADER_INDEX;
	  warning('off', 'all');

    student_output = strip_output(evalc(['run ' student_script_name]));
    fprintf("Student Output:\n%s\n\n",student_output)

	if old_index == AUTOGRADER_INDEX
		output_msg = sprintf('Your script did not take in any inputs.  Make sure you are using the input() command and not hard-coding the input values.');
		json_parts{end+1} = build_json_test(testName, test_points, 0, output_msg, 'visible')
    disp(output_msg)
        return;
	end
  catch ME
    student_run_error = true;
    student_error_message = json_escape(ME.message);
  end
  if (student_run_error)
    % If the student's code failed to run, fail all tests.
    output_msg = sprintf('Your script failed to run. Error: %s', student_error_message);
    json_parts{end+1} = build_json_test(testName, test_points, 0, output_msg, 'visible');
    disp(output_msg)
  else
    if ~strcmp(student_output, reference_output)
      % Find where they differ
      min_len = min(length(student_output), length(reference_output));

      % Find first differing character
      diff_idx = find(student_output(1:min_len) ~= reference_output(1:min_len), 1, 'first');

      if isempty(diff_idx) % Strings are identical up to the min length, one is longer
        if length(student_output) > length(reference_output)
          feedback = sprintf('Your output is too long. Expected length: %d, Your length: %d. Extra characters starting at index %d: "%s"', ...
          length(reference_output), length(student_output), min_len + 1, student_output(min_len+1:end));
        else
          feedback = sprintf('Your output is too short. Expected length: %d, Your length: %d. Missing characters starting at index %d: "%s"', ...
          length(reference_output), length(student_output), min_len + 1, reference_output(min_len+1:end));
        end
      else % Differences within the common length
        feedback = sprintf('Difference found at character index %d.\nExpected: ''%c'' (ASCII %d)\nYour: ''%c'' (ASCII %d)\n\nExpected output segment: "...%s..."\nYour output segment:     "...%s..."', ...
        diff_idx, reference_output(diff_idx), double(reference_output(diff_idx)), ...
        student_output(diff_idx), double(student_output(diff_idx)), ...
        reference_output, ...
        student_output);
      end
      %error(feedback); % This will fail the test and show the feedback
      score = 0;

      json_parts{end+1} = build_json_test(testName, test_points, score, feedback, 'visible');

    else
      feedback = sprintf('Output matches!\n'); % Or simply let the test pass
      json_parts{end+1} = build_json_test(testName, test_points, test_points, feedback, 'visible');
    end


end
  disp(feedback)
end
end

function json_str = build_json_test(name, max_score, score, output, visibility)
  % Manually constructs a JSON object string for a single test.
  json_str = sprintf(['{"name": "%s", "max_score": %.1f, "score": %.1f, ' ...
  '"output": "%s", "visibility": "%s"}'], ...
  json_escape(name), max_score, score, json_escape(output), visibility);
endfunction

function str = json_escape(str_in)
  % Escapes characters for safe JSON embedding.
  str = strrep(str_in, '\', '\\');
  str = strrep(str, '"', '\"');
  str = strrep(str, sprintf('\n'), '\n');
end
