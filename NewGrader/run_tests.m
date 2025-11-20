function run_tests()

  clear
  global AUTOGRADER_INDEX
  global AUTOGRADER_INPUTS

  addpath('tests');
  student_run_error = false;
  % --- 1. Load Configuration ---
  try
    run('test_config.m');
    %disp(tasks)
    %disp("found test_config")
catch
    error_out('{"tests": [{"name": "Autograder Error", "score": 0, "max_score": 1, "output": "Could not find or run test_config.m. Please contact instructor."}]}')
    %disp("Still errored")
    return;
  end

  json_parts = {}; % A cell array to hold the JSON for each test

  % --- 2. File Presence Test ---
    [filejson, student_run_error,tasks]  = file_check(tasks,student_run_error);
    json_parts = horzcat(json_parts,filejson);



for taskid = 1:length(tasks)
  student_Script = tasks{taskid}.student_file;
  if check_for_clear(student_Script)
    student_run_error = true;
    output_msg = sprintf('Your %s file contains the "clear" command, which is not allowed as it removes necessary variables for testing. Please remove it and try again.',student_Script);
    disp(output_msg);
    json_parts{end+1} = build_json_test('clear check', 1, 0, output_msg, 'visible');
    % If the file doesn't exist, write the result and stop.
    finalize_json(json_parts);
    continue;
  end

    funcCheck = tasks{taskid}.func_test;
    termCheck = tasks{taskid}.term_check;
    inputCheck = tasks{taskid}.input_test;
    if funcCheck == true
        %disp("In loop")
        [funcJson, student_run_error]  = function_test(student_run_error,tasks{taskid});
        json_parts = horzcat(json_parts,funcJson);
    end
    if termCheck == true
      if inputCheck == false
      [termJson, student_run_error]  = terminal_test(student_run_error,tasks{taskid});
      json_parts = horzcat(json_parts,termJson);
      else
      [termJson, student_run_error]  = terminal_input_test(student_run_error,tasks{taskid});
      json_parts = horzcat(json_parts,termJson);
      end
    end

end
##  [varJson, student_run_error]  = varTest(student_run_error);
##  json_parts = horzcat(json_parts,varJson);
##
##  [termJson, student_run_error]  = terminalTest(student_run_error);
##  json_parts = horzcat(json_parts,termJson);

%  [funcJson, student_run_error]  = functionTest(student_run_error);
%   json_parts = horzcat(json_parts,funcJson);

  finalize_json(json_parts);
end


function json_str = build_json_test(name, max_score, score, output, visibility)
  % Manually constructs a JSON object string for a single test.
  json_str = sprintf(['{"name": "%s", "max_score": %.1f, "score": %.1f, ' ...
  '"output": "%s", "visibility": "%s"}'], ...
  json_escape(name), max_score, score, json_escape(output), visibility);
endfunction

function finalize_json(json_parts)
  % Joins all test JSON parts and writes the final results.json file.
  final_json_str = sprintf('{"tests": [%s]}', strjoin(json_parts, ','));
  fid = fopen('/autograder/results/results.json', 'w');
  fprintf(fid, '%s', final_json_str);
  fclose(fid);
end

function str = json_escape(str_in)
  % Escapes characters for safe JSON embedding.
  str = strrep(str_in, '\', '\\');
  str = strrep(str, '"', '\"');
  str = strrep(str, sprintf('\n'), '\n');
end

function error_out(json_str)
  % Helper to write a JSON error and exit.
  fid = fopen('/autograder/results/results.json', 'w');
  fprintf(fid, '%s', json_str);
  fclose(fid);
end

