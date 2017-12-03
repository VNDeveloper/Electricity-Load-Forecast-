filename = 'Train&Test.xls';
range = 'K2:K762';
dataType = DataType1;
allRawData = xlsread(filename, range);

data = dataType.getData(allRawData);
fis = anfis(data)