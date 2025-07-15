% load big mat file
Y=load('test.mat');
R=Y.output;

% list of subjects
s = LEth.bySubject(R);

for i=1:length(s.SubjID)
    fprintf('%d %s\n', i, s.SubjID{i});
end