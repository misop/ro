%trenovacia vzorka
train = mushs;
%testovacia vzorka
test = mushs;
%vystup trenovacej
targetTrain = c;
%vystup testovacej
targetTest = c;

%treba najprv vyhdoit columny co hodia chybu :-)
%ak nezostane ziaden tak sa neda rozdelit

O1 = NaiveBayes.fit(train, targetTrain);
C1 = O1.predict(test);
confusion = confusionmat(targetTest, C1)