%%%%%
%Running the submissions separate like this allows for the variables to stay local
%%%%%

function [vars,data] = runSubmission(script_name,variables_to_test)

    run(script_name);
    % Save all current variables to a structure
    vars = whos();
    data = struct();

        for i = 1:length(vars)
      if sum(strcmp(vars(i).name,variables_to_test))>0
        var_name = vars(i).name;
        data.(var_name) = eval(var_name);
      endif
  end
