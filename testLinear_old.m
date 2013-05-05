learn = mushs;
learnT = c;
test = mushs;
testT = c;

w = LinearClassifier(learn, learnT, 0, 5000);
dots = (w * test.')';
dots = (dots > 0) + 1;
[m, x] = size(test);

outs = [];
for i = 1:m
    outs = [outs (dots(i) == testT(i))];
end
rate = sum(outs)/m
[confusion, order] = confusionmat(dots, testT)