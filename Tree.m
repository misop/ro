function t = Tree( train_set, selected_column, cislo_stlpca )
%TREE vrati decission tree
%   train_set - trenovacia mnozina ("shrooms"), bez stlpca ktory testujete
%   selected_column - ten stlpec ktory sa snazite otestovat
%   cislo_stlpca - cislo stlpca ktory chcete testovat, koli peknemu vypisu
%
%
%   napisem vam tu "testovaci" priklad ako zavolat tieto funkcie
%   -----------------------------------------------------------------------
%
%   load shrooms
%   [c, x] = takecolumn(shrooms, 1);
%   t = Tree(x, c, 1);
%
%   -----------------------------------------------------------------------

N = 22; idx = 1;
names = cell(1,N);
cislo_stlpca = cislo_stlpca-1;
for i=0:N
    if(i == cislo_stlpca)
        continue;
    end;
    switch i
        case 0   
            names{idx} = 'edible';
        case 1   
            names{idx} = 'cap-shape';
        case 2   
            names{idx} = 'cap-surface';
        case 3   
            names{idx} = 'cap-color';
        case 4   
            names{idx} = 'bruises';
        case 5   
            names{idx} = 'odor';    
        case 6   
            names{idx} = 'gill-attachment';
        case 7   
            names{idx} = 'gill-spacing';
        case 8   
            names{idx} = 'gill-size';
        case 9   
            names{idx} = 'gill-color';
        case 10  
            names{idx} = 'stalk-shape'; 
        case 11  
            names{idx} = 'stalk-root';
        case 12  
            names{idx} = 'stalk-surface-above-ring';
        case 13  
            names{idx} = 'stalk-surface-below-ring';
        case 14  
            names{idx} = 'stalk-color-above-ring';
        case 15  
            names{idx} = 'stalk-color-below-ring'; 
        case 16  
            names{idx} = 'veil-type';
        case 17  
            names{idx} = 'veil-color';
        case 18  
            names{idx} = 'ring-number';
        case 19  
            names{idx} = 'ring-type';
        case 20  
            names{idx} = 'spore-print-color'; 
        case 21  
            names{idx} = 'population';
        case 22  
            names{idx} = 'habitat';      
    end;
    idx = idx + 1;
end
t = classregtree(train_set, selected_column,'names', names);
view(t);
