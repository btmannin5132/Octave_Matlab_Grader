function has_clear = check_for_clear(filename)
    % Initializes flag
    has_clear = false;

    if ~exist(filename, 'file')
        % File doesn't exist, cannot check.
        return;
    end

    % Open the file for reading (text mode 'rt')
    fid = fopen(filename, 'rt');
    if fid == -1
        % Error opening file
        return;
    end

    % Read the entire file content into a single string.
    % The 't' in 'rt' handles system-specific line endings better.
    file_content = fread(fid, '*char')';

    % Close the file
    fclose(fid);

    % --- THE IMPROVED REGULAR EXPRESSION ---
    % Pattern breakdown:
    % (^|\n): Match the start of the file OR a newline character. This ensures
    %         we only match 'clear' if it starts a line.
    % \s*:   Match zero or more whitespace characters (indentation).
    % clear: Match the exact word 'clear'.
    % (\s|$|;): Match the end of the command: either whitespace, end of string, or a semicolon.
    pattern = '(\n|^)\s*clear(\s|$|;|%\s*|//\s*)';

    % Use regexpi for case-insensitive search
    % The 'once' flag stops after the first match
    if ~isempty(regexpi(file_content, pattern, 'once'))
        has_clear = true;
    end
endfunction
