<<<<<<< HEAD
function mdds(Database)
% cities = ...
% {'Atl','Chi','Den','Hou','LA','Mia','NYC','SF','Sea','WDC'};
% D = [    0  587 1212  701 1936  604  748 2139 2182   543;
%        587    0  920  940 1745 1188  713 1858 1737   597;
%       1212  920    0  879  831 1726 1631  949 1021  1494;
%        701  940  879    0 1374  968 1420 1645 1891  1220;
%       1936 1745  831 1374    0 2339 2451  347  959  2300;
%        604 1188 1726  968 2339    0 1092 2594 2734   923;
%        748  713 1631 1420 2451 1092    0 2571 2408   205;
%       2139 1858  949 1645  347 2594 2571    0  678  2442;
%       2182 1737 1021 1891  959 2734 2408  678    0  2329;
%        543  597 1494 1220 2300  923  205 2442 2329     0];
% [Y,eigvals] = cmdscale(D);
% plot(Y(:,1),Y(:,2),'.')
% text(Y(:,1)+25,Y(:,2),cities)
% xlabel('Miles')
% ylabel('Miles')

D = pdist(Database, 'Euclidean');
[Y,eigvals] = cmdscale(D);
figure; plot(Y(:,1),Y(:,2),'.');
=======
function mdds(mushs, c)
[m, n] = size(mushs);
d = max(c);
hold all
for i = 1:d
    idxs = []; mat = []; D = []; M = [];
    idxs = (c == i);
    mat = mushs(idxs, :);
    D = pdist(mat);
    [k, l] = size(D);
    if l == 0
        continue;
    end
    [out, eigvals] = cmdscale(D);
    % plot(Y(:,1),Y(:,2),'.')
    X = out(:,1);
    Y = out(:,2);
    scatter(X, Y, 50, '.');
end
hold off
>>>>>>> mdds
