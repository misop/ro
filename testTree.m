function testTree(database, selected_column, pocet_validacii, redukcia)
%TESTTREE otestuje strom na testovacej mnozine a zobrazi ROC krivky
%   database - shrooms, pripadne ina databaza uz nacitana
%   selected_column - cislo stlpca ktory sa snazite otestovat
%   pocet_validacii - kolko krat validuje, vysledky priemeruje
%   redukcia - 0 PCA, 1 - FA (LDA nefungovalo)

[d_riadky, d_stlpce] = size(database);
% pre kazdu dimenziu mame cislo -> vysledna ROC krivka
ROCs = zeros((d_stlpce-1), 1);
for pocet_dimenzii = 1:(d_stlpce-1)
    idx = 1;
    pocet_casti = 5;
    result = zeros(pocet_validacii, 1);
    for validacia = 1:pocet_validacii

        % rozdeli databazu na dany pocet casti
        indices = crossvalind('Kfold', database(:,selected_column), pocet_casti);
        % priradi patricne indexy pre dane casti, pricom
        % pocet_casti - 1 = trenovacia mnozina
        % 1 - testovacia mnozina
        mI1 = indices ~= idx;
        mI2 = indices == idx;
        % priradi databazu pre dane indexy
        training = database(mI1, :);
        testing = database(mI2, :);

        % vyselektne ten stlpec ktory testujeme
        [train_column, train_set] = takeColumn(training, selected_column);
        [test_column, test_set] = takeColumn(testing, selected_column);

        % zredukuje pocet dimenzii
        if(pocet_dimenzii < (d_stlpce-1))
            if(redukcia == 0)
                train_set = compute_mapping(train_set, 'PCA', pocet_dimenzii);
                test_set = compute_mapping(test_set, 'PCA', pocet_dimenzii);
            elseif(redukcia == 1)
                train_set = compute_mapping(train_set, 'FA', pocet_dimenzii);
                test_set = compute_mapping(test_set, 'FA', pocet_dimenzii);
            end;
        end;
        
        % samotny stromovy algoritmus
        % ---------------------------
        % ----------START------------
        % ---------------------------
        
        % natrenuj strom
        t = classregtree(train_set, train_column);

        % otestuj strom
        a = t.eval(test_set);

        % porovnaj vysledky s nasim stlpcom
        [mm, nn] = size(a);
        threshold = 0.5;

        % zisti kolko je "negativnych" vysledkov
        b = abs(a - test_column);
        negatives = sum(b > threshold);
        
        % skos na percenta
        result(validacia) = 100 - ((negatives / mm) * 100);
      
        % ---------------------------
        % -----------END-------------
        % ---------------------------
        
        % updatni idx, nech kazdym cyklom zvolim inu cast na testovanie
        idx = idx + 1;
        if(idx > pocet_casti)
            idx = pocet_casti;
        end;
    end;
    % vloz hodnoty do nasho pola, ktore potom vykreslime
    % malo by byt v percentach
    ROCs(pocet_dimenzii) = mean(result);
end;

x = 1:(d_stlpce-1);
y = ROCs;

figure;
plot(x,y);
xlim([1 (d_stlpce-1)]);
ylim([0 100]);
