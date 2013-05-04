function testTree_old( t, test_set, selected_column, skosenie_stromu )
%TESTTREE_OLD otestuje strom na testovacej mnozine a zobrazi ROC krivky
%   t - uz natrenovany strom zhora
%   test_set - testovacia mnozina, bez stlpca ktory testujete
%   selected_column - ten stlpec ktory sa snazite otestovat
%   BACHA - nezabudnite zredukovat aj ten selected_column!!
%   skosenie_stromu - o kolko chcete zredukovat pocet listov

if(skosenie_stromu > 0)
    t = prune(t,skosenie_stromu);
end;

a = t.eval(test_set);

%plotroc(output2binary(selected_column), output2binary(a));

[m, n] = size(a);

mini = min(selected_column);    % malo by byt 1
maxi = max(selected_column);    % dufam ze idu hodnoty normalne: 1,2,3..
threshold = 0.5;
step = (maxi - mini - threshold) / 100;

negative = zeros(100, 1);
for j=1:100
    b = abs(a - selected_column);
    negative(j) = sum(b > threshold);
    threshold = threshold + step;
end;

x = 1:100;
y = 100 - ((negative / m) * 100);

figure;
plot(x,y);
xlim([1 100]);
ylim([0 100]);
