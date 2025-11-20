function cleaned_str = strip_output(input_str)

    temp_str = regexprep(input_str, '\r', '');
    temp_str = regexprep(temp_str, '^[ \t]*\w+[ \t]*=[ \t]*\n+', '', 'lineanchors');

    lines = strsplit(temp_str, '\n');
    cleaned_lines = {};

    for i = 1:length(lines)
        line = lines{i};

        % Remove leading and trailing horizontal whitespace from the current line
        line = regexprep(line, '^[ \t]*|[ \t]*$', '');

        line = regexprep(line, '[ \t]+', ' ');

        % Only keep the line if it's not empty after cleaning.
        if (!isempty(line))
            cleaned_lines{end+1} = line;
        end
    end
    % Join the cleaned lines back together with a single, uniform newline character.
    cleaned_str = strjoin(cleaned_lines, '\n');

endfunction
