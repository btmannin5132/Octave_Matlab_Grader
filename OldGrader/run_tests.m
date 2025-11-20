function run_tests()
  clear
  addpath('tests');
  student_run_error = false;
  % --- 1. Load Configuration ---
  try
    run('test_config.m');
    clc
  catch
    error_out('{"tests": [{"name": "Autograder Error", "score": 0, "max_score": 1, "output": "Could not find or run test_config.m. Please contact instructor."}]}')
    disp("Still errored")
    return;
  end

  json_parts = {}; % A cell array to hold the JSON for each test

  % --- 2. File Presence Test ---
  if exist(student_script_name, 'file')
    json_parts{end+1} = build_json_test('File Presence', .1, .1, 'Required script was found.', 'visible');
  else
    output_msg = sprintf('Required file ''%s'' not found in submission.', student_script_name);
    json_parts{end+1} = build_json_test('File Presence', .1, 0, output_msg, 'visible');
    % If the file doesn't exist, write the result and stop.
    finalize_json(json_parts);
    return;
  end

##  [varJson, student_run_error]  = varTest(student_run_error);
##  json_parts = horzcat(json_parts,varJson);
##
##  [termJson, student_run_error]  = terminalTest(student_run_error);
##  json_parts = horzcat(json_parts,termJson);

 [funcJson, student_run_error]  = functionTest(student_run_error);
  json_parts = horzcat(json_parts,funcJson);

  finalize_json(json_parts);
end

% --- Helper Functions ---

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

