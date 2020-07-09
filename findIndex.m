function index = findIndex(name,string)
% findIndex finds the index of a string in an array of strings
nameIndex = strfind(name,string);
index = find(not(cellfun('isempty',nameIndex)));
end

