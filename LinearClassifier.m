function [vektor] = LinearClassifier( data_set, selected_column, max_it, zobraz )
%LINEARCLASSIFIER Skusi pouzit Linearny Klassifier na data
%   data_set - matica dat ("shrooms"), bez stlpca ktory testujete
%   selected_column - ten stlpec ktory sa snazite otestovat
%   max_it - maximalny pocet iteracii
%   zobraz - ci ma zobrazit vysledny vektor

unikaty = unique(selected_column);
[pocet_unikatnych_prvkov, fuuuu] = size(unikaty);
if(pocet_unikatnych_prvkov ~= 2)
    display('Musis mat PRESNE 2 prvky vo vybranej columne');
    return;
end;

if nargin < 4
    if nargin < 3
        max_it = 2000;
    end
    zobraz = true;
end

[m, n] = size(data_set);
vektor = ones(1, n);
target = selected_column == unikaty(1);
min_threshold = 100;
min_vektor = ones(1, n);

for i=1:max_it
    % dot product
    dots = (vektor * data_set.')';
    % tie co su pod nulou a nad nulou su zvlast kategorie
    dots = dots > 0;
    % kolko sme urcili zle
    error = abs(dots - target);
    chyba = (sum(error) / m) * 100;
    % zapametaj si najmensiu chybu aby sme to potom mohli vypisat
    if(chyba < min_threshold)
        min_threshold = chyba;
        min_vektor = vektor;
    end;
    if(chyba == 0)
        break;
    end;
    % tu nahodne vyberem jeden ktory priratam/odratam
    k = ceil(1 + (sum(error)-1).*rand);
    idx = 0;
    % skoda ze to nejde rychlejsie ako cyklom
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

vektor = min_vektor;
if(zobraz == true)
    disp('najmensia chyba pre dany pocet iteracii je:');
    disp(min_threshold);
    disp(vektor);
end;
