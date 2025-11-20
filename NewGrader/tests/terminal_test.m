function [json_parts, student_run_error] = terminal_test(student_run_error,task)

    solution_script_name = task.solution_file
    student_script_name = task.student_file
    test_points = task.term_points

    json_parts = {};
    feedback = '';

    %run terminal output test

    fprintf("\nRunning Terminal Test\n\n")

  try
    reference_output = strip_output(evalc(['run ' solution_script_name]));
    fprintf("\nReference Output:\n%s\n",reference_output)
    student_output = strip_output(evalc(['run ' student_script_name]));
    fprintf("\nStudent Output:\n%s\n\n",student_output)

  catch ME
    student_run_error = true;
    student_error_message = json_escape(ME.message);
  end
  if (student_run_error)
    % If the student's code failed to run, fail all tests.
    output_msg = sprintf('Your script failed to run. Error: %s', student_error_message);
    json_parts{end+1} = build_json_test('Script Execution', test_points, 0, output_msg, 'visible');
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
      json_parts{end+1} = build_json_test("TerminalTest", test_points, score, feedback, 'visible');

    else
      feedback = sprintf('Output matches!'); % Or simply let the test pass
      json_parts{end+1} = build_json_test("TerminalTest", test_points, test_points, feedback, 'visible');
    end


end
disp(feedback)

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
