function [phase, i, q] = importfile(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  [PHASE, I, Q] = IMPORTFILE1(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as column
%  vectors.
%
%  [PHASE, I, Q] = IMPORTFILE1(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  [phase, i, q] = importfile1("/tmp/RFMicrowaveToolbox/+adi/+internal/adar1000_phase_table.csv", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 21-Sep-2022 12:58:10

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["phase", "i", "q"];
opts.VariableTypes = ["double", "categorical", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["i", "q"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
phase = tbl.phase;
i = tbl.i;
q = tbl.q;
end