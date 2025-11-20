function output_cells = wrap(func_handle, varargin)

  n_outputs = max(nargout(func_handle));

  % Create a cell array to store the outputs
  output_cells = cell(1, n_outputs);

  % Call the function with all inputs and collect all outputs.
  % The [output_cells{:}] syntax is crucial here, as it "unpacks"
  % the cell array to act as a comma-separated list of output variables.
  [output_cells{:}] = func_handle(varargin{:});

end
