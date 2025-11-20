function val = input(prompt,mode)
warning('off', 'all');

    # Define the global variables used to store the sequence of answers and the current index.
global AUTOGRADER_INPUTS
global AUTOGRADER_INDEX
%disp(AUTOGRADER_INDEX)
    # 1. Check if the index is valid and within the bounds of the answers array
    if (exist("AUTOGRADER_INPUTS") && ...
        AUTOGRADER_INDEX <= length(AUTOGRADER_INPUTS))

        # Get the current input string from the cell array
        input_str = AUTOGRADER_INPUTS(AUTOGRADER_INDEX,:);

        # Display the prompt and the value to simulate user input
        disp([prompt, input_str]);

        # 2. Advance the index for the next call
        AUTOGRADER_INDEX = AUTOGRADER_INDEX + 1;
        %disp(AUTOGRADER_INDEX)

        if (nargin == 2 && strcmp(mode, "s"))
        # Mode 's' returns the raw string
          val = input_str;
        else
        # Default mode evaluates the string as an expression
          val = eval(input_str);
        endif

    else
        # Fall back to the built-in function or throw an error
        # (throwing an error is better for autograding to catch missed inputs)
        error("input: Ran out of predefined autograder inputs!");
    endif

endfunction
