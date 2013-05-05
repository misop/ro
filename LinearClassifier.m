function [vektor] = LinearClassifier( data_set, selected_column, threshold, max_it )
%LINEARCLASSIFIER Skusi pouzit Linearny Klassifier na data
%   data_set - matica dat ("shrooms"), bez stlpca ktory testujete
%   selected_column - ten stlpec ktory sa snazite otestovat
%   threshold - threshold po ktory akceptujeme chybu
if(max(selected_column) > 2)
    return;
end;
if nargin < 4
    max_it = 2000;
end

[m, n] = size(data_set);
vektor = ones(1, n);
target = selected_column > 1;
found = false;
chyba = 0;

for i=1:max_it
    dots = (vektor * data_set.')';
    dots = dots > 0;
    error = abs(dots - target);
    chyba = (sum(error) / m) * 100;
    if(chyba < threshold)
        found = true;
        break;
    else
        k = ceil(1 + (sum(error)-1).*rand);
        idx = 0;
        for j = 1:m
            if(error(j) > 0)
                idx = idx + 1;
                if(idx == k)
                    if target(j) == 0
                        vektor = vektor - data_set(j,:);
                    else
                        vektor = vektor + data_set(j,:);
                    end
                end;
            end;
        end;
    end;
end;

if(found == true)
    disp('nasiel sa oddelujuci vektor');
    disp(chyba);
    disp(vektor);
else
    disp('nenasiel sa oddelujuci vektor');
    disp(chyba);
    disp(vektor);
end;
