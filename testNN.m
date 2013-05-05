function testNN(database, selected_column, pocet_validacii, redukcia)
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL
% Created Mon Apr 22 18:51:26 CEST 2013

[d_riadky, d_stlpce] = size(database);
% pre kazdu dimenziu mame cislo -> vysledna ROC krivka
ROCs = zeros((d_stlpce-1), 1);
for pocet_dimenzii = 1:(d_stlpce-1)
    result = zeros(pocet_validacii, 1);
    display(pocet_dimenzii);
    for validacia = 1:pocet_validacii
        display(validacia);
        
        %  ci sa ma pouzit kross validacia alebo nie
        if(pocet_validacii > 1)
            % rozdeli databazu na dany pocet casti
            indices = crossvalind('Kfold', database(:,selected_column), pocet_validacii);
            % priradi patricne indexy pre dane casti, pricom
            % trenovacia mnozina = pocet_casti - 1
            % testovacia mnozina = 1
            mI1 = indices ~= validacia;
            mI2 = indices == validacia;
            % priradi databazu pre dane indexy
            training = database(mI1, :);
            testing = database(mI2, :);
        else
            training = database;
            testing = database;            
        end;

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
            elseif(redukcia == 2)
                 train_set = fastica(train_set', 'numOfIC', pocet_dimenzii, 'stabilization', 'on')';
                 test_set = fastica(test_set', 'numOfIC', pocet_dimenzii, 'stabilization', 'on')';
            elseif(redukcia == 3)
                 train_set = myICA(train_set',pocet_dimenzii,false)';
                 test_set = myICA(test_set',pocet_dimenzii,false)';
            end;
        end;
        
        % samotny NN algoritmus
        % ---------------------
        % --------START--------
        % ---------------------
        
        %sem das testovaciu mnozinu bez stlpika na urcenie
        inputs = train_set';
        %sem das stlpik na urcenie prekonvertovany funkciu output2binary
        it = output2binary2(train_column)';
        %sem das testovaciu mnozinu bez stlpika
        test = test_set';
        %sem das stlpik skonvertovany output2binary
        %c = output2binary2(test_column)';

        % Create a Pattern Recognition Network
        hiddenLayerSize = 10;
        net = patternnet(hiddenLayerSize);

        % Choose Input and Output Pre/Post-Processing Functions
        % For a list of all processing functions type: help nnprocess
        net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
        net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;

        % For help on training function 'trainlm' type: help trainlm
        % For a list of all training functions type: help nntrain
        net.trainFcn = 'trainlm';  % Levenberg-Marquardt

        % Choose a Performance Function
        % For a list of all performance functions type: help nnperformance
        net.performFcn = 'mse';  % Mean squared error

        % Choose Plot Functions
        % For a list of all plot functions type: help nnplot
        net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
          'plotregression', 'plotfit'};


        % Train the Network
        [net,tr] = train(net,inputs,it);

        % Test the Network
%         outputs = net(test);
%         errors = abs(gsubtract(tt,outputs));
%         result(validacia) = (1 - mean(mean(errors))) * 100;
        % pre kazdy zisti kde bola max pravdepodobnost a vrati
        % rate ako SOM aj confusion maticu :)
        outputs = net(test);

        [m,n] = size(test_set);
        correct = [];
        outs = [];
        for i = 1:m
            [maxim, ind] = max(outputs(:,i));
            outs = [outs ind];
            correct = [correct (ind == test_column(i))];
        end;
        result(validacia) = (sum(correct)/m) * 100;
        %[confusion, order] = confusionmat(outs, c')
        %toto som pridal vykresli ti to roc krivku :)
        % outs = sim(net, test);
        % plotroc(target, outs);
        % figure, plotconfusion(target, outs)

        % View the Network
        %view(net)

        % ---------------------------
        % -----------END-------------
        % ---------------------------
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
