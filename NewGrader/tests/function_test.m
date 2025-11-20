  % --- Helper Function for Function Tests ---
  function [json_parts, student_run_error] = function_test(student_run_error,task)
    funcJson = {};
    json_parts = {};
    function_tests = task.func_args;
    solution_script_name = task.solution_file;
    student_script_name = task.student_file;
    function_points = task.func_points_per_Test;
    function_outputs = task.num_outputs;
    output = "";

    fprintf("\nRunning Function Test\n\n")
    try

      for i = 1:size(function_tests)(1)
        test_args= function_tests(i,:);
        max_score = function_points(i);

        test_name = sprintf('\nCheck function ''%s'' with arguments: %s', student_script_name, test_args);
        score = 0;
        output = 'Function not found or defined correctly.';

        % Get the correct output from the solution file
        fprintf('%s\n',test_name)
        solution_output = cell(1, function_outputs);
        student_output = solution_output;

        solFunc = strrep(solution_script_name, '.m', '');
        solcmd = sprintf('%s(%s);', solFunc, test_args);
        [solution_output{:}] = eval(solcmd)

        try
          % Run the student's function
          stuFunc = strrep(student_script_name, '.m', '');
          stucmd = sprintf('%s(%s);', stuFunc, test_args)
          [student_output{:}] = eval(stucmd)
          %student_output = feval(strrep(student_script_name, '.m', ''), test_args{:});

          solution_vec = cell2mat(solution_output); % Converts {[wireLen], [springMass]} to [wireLen, springMass]
          student_vec = cell2mat(student_output);          % Gets the [wireLength, springMass] vector from the single output cell

          expected = round((solution_vec .* 10e10)) ./ (10e10);
          actual = round((student_vec .* 10e10)) ./ (10e10);

          if isequal(actual, expected)
            score = max_score;
            output = sprintf('Function ''%s'' passed the test.', student_script_name);
          else
            output = sprintf(['Function ''%s'' returned an incorrect value. ' ...
            'Expected: %s, Got: %s'], ...
            student_script_name, mat2str(cell2mat(solution_output)), mat2str(cell2mat(student_output)));
          end
        catch ME
          output = sprintf('Function ''%s'' failed to execute. Error: %s', student_script_name, ME.message);
          score = 0;
        end

        disp(output);
        json_parts{end+1} = build_json_test(test_name, max_score, score, output, 'visible');

        try
          reference_output = strip_output(evalc(solcmd));
          student_output = strip_output(evalc(stucmd));

        catch ME
          student_run_error = true;
          student_error_message = json_escape(ME.message);
        end
        if (student_run_error)
          % If the student's code failed to run, fail all tests.
          output_msg = sprintf('Your script failed to run. Error: %s', student_error_message);
          json_parts{end+1} = build_json_test('Script Execution', sum(test_points), 0, output_msg, 'visible');
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
              feedback = sprintf('Difference found at character index %d.\nExpected: ''%c'' (ASCII %d)\nYour: ''%c'' (ASCII %d)\n\nExpected output segment:\n "%s"\nYour output segment:\n"%s"\n', ...
              diff_idx, reference_output(diff_idx), double(reference_output(diff_idx)), ...
              student_output(diff_idx), double(student_output(diff_idx)), ...
              reference_output, ...
              student_output);
            end
            %error(feedback); % This will fail the test and show the feedback
            score = 0;
            %teststr = sprintf("Terminal Test for %s(%s)",strrep(student_script_name, '.m', ''),(mat2str(cell2mat(test_args)))
            disp(feedback)
            json_parts{end+1} = build_json_test("Terminal Test", .1, score, feedback, 'visible');

          else
            feedback = sprintf('Output matches!'); % Or simply let the test pass
            %teststr = sprintf("Terminal Test for %s(%s)",strrep(student_script_name, '.m', ''),(mat2str(cell2mat(test_args)))
            disp(feedback);
            json_parts{end+1} = build_json_test("Terminal Test", .1, .1, feedback, 'visible');
          end
          end
  end

        catch ME
          student_run_error = true;
          disp(output)
          json_parts{end+1} = build_json_test('Function Autograder Error', sum(function_points), 0, ['An error occurred during function testing: ' ME.message], 'visible');

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


  function output_cells = wrap(func_handle, varargin)

  n_outputs = max(nargout(func_handle));

  % Create a cell array to store the outputs
  output_cells = cell(1, n_outputs);

  % Call the function with all inputs and collect all outputs.
  % The [output_cells{:}] syntax is crucial here, as it "unpacks"
  % the cell array to act as a comma-separated list of output variables.
  [output_cells{:}] = func_handle(varargin{:});

  % Initialize the output struct

end

