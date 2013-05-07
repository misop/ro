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
