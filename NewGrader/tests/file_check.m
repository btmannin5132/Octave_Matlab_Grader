function [json_parts,student_run_error,tasks] = file_check(tasks,student_run_error)
    json_parts = {};
    for task_id = 1:length(tasks)
        % 1. Extract the struct from the cell
        current_task_struct = tasks{task_id}; 
        
        student_file_name = current_task_struct.student_file;

        try
            % Find the file list using the original name
            file_list = glob([student_file_name, '*.m']);

            if ~isempty(file_list)
                % 2. Modify the temporary struct, using the mandatory index (1)
                % This resolves the "structure array is empty" error.
                current_task_struct(1).student_file = file_list{1,1};
            else
                % Trigger the catch block if no file is found
                error('No student file found by glob.'); 
            end
        
        catch
            % Fallback: Use the default file name if glob fails or finds nothing
            current_task_struct(1).student_file = [student_file_name, '{user_or_team}.m'];
        end
        
        % 3. Place the modified struct back into the cell array
        tasks{task_id} = current_task_struct; 
        %filestr = tasks{task_id}.student_file;
        %fprintf('%s\n',filestr)
        score =tasks{task_id}.file_check_points;
    if exist(student_file_name, 'file')
        json_parts{end+1} = build_json_test('File Presence', score, score, 'Required script was found.', 'visible');
    else
        output_msg = sprintf('Required file ''%s'' not found in submission.', student_file_name);
        json_parts{end+1} = build_json_test('File Presence', score, 0, output_msg, 'visible');
        % If the file doesn't exist, write the result and stop.
        end
    end
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