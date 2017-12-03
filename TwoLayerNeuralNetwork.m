classdef TwoLayerNeuralNetwork
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       
       
    end
    
    methods
        
        %This function will need to know the input data output data and it
        %will generate weight depend on the number of user input. The
        %funtion will then return the new weight
        function  results = neuralNet (obj, epochSize, normalizeData, h1Size, h2Size)
            
            trainingFinish = false;
            trainTest = false;
            %Initilize the classes
            dataType = DataType1;
            denormalizeData = DenormalizeData;
            
            %denormalize the train data for testing later
            denormalizeTrainData = denormalizeData.denormalizeSetData(normalizeData{1}((362):(730), :), normalizeData{2}, normalizeData{3});

            %get the training data
            trainData = dataType.getData(normalizeData{1}((362):(730),:));
            
            %Initialize the weights for the neural network
            [noOfData, noOfInput] = size(trainData);
            
            for epochs = 1: epochSize
                
        
                %Determine the number of input for matrix multiplication 
                %Initialise value for the min and max range
                h1MinRange = 0;
                h1MaxRange = 0;
                h2MinRange = 0;
                h2MaxRange = 0;
                maxRange = 0;
                minRange = 0;
                h2MMinRange = 0;
                h2MMaxRange = 0;
                h1MMinRange = 0;
                h1MMaxRange = 0;
                mMinRange = 0;
                mMaxRange = 0;
                
                learnRate = 0.2;
                momentum = 0.2;
                
                if epochs <= 1
                    
                    disp('Training Start');
                    %Determine the maximum amount of weight needed for the
                    %input data
                    noOfInputWeight = noOfData*(noOfInput-1);
                    %The weights for the input 
                    inputWeight = 0.5*(2*rand(noOfInputWeight, h1Size)-1);
                    %The weights for the input bias
                    inputBiasWeight = 0.5*(2*rand(noOfData, h1Size) - 1);

                    %Determine the amount of weight needed for the hidden layer one
                    noOfh1Weight = noOfData*h1Size;
                    %The weight for hidden layer 1
                    h1Weight = 0.5*(2*rand(noOfh1Weight, h2Size) - 1);
                    %The bias weight for hidden layer 1
                    h1BiasWeight = 0.5*(2*rand(noOfData, h2Size) - 1);

                    %Determine the amount of weight needed for the ouput
                    noOfh2Weight = noOfData*h2Size;
                    %The weight for hidden layer 2 (The output will alwaus have one
                    %neuron)
                    h2Weight = 0.5*(2*rand(noOfh2Weight, 1) - 1);
                    %The bias weight for hidden layer 2 (The output will always
                    %have the value of one)
                    h2BiasWeight = 0.5*(2*rand(noOfData, 1) - 1);
                    
                end
                
                
                %Run through all the input 
                for n = 1 : noOfData
                    
                   %---- FEEDFORWARD WOOOOOOOOOOOO -----%
                   
                   %Calculate previous range
                   
                   %Calculate the minimum range for the weight
                   minRange = minRange + 1;
                   %Calculate the maximum range for the weight
                   maxRange = maxRange + (noOfInput-1);
                   %Calculate the sum for the input
                   sumOfInput = trainData(n,1:(noOfInput-1))*inputWeight((minRange):(maxRange), :) + 1 * inputBiasWeight(n,:);
                    
                   %The value for the four neurons 
                   h1LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfInput));
                   
                   %Calculate the minimum range for the first hidden layer
                   h1MinRange = h1MinRange + 1;
                   %Calculate the maximum range for the first hidden layer
                   h1MaxRange = h1MaxRange + h1Size;
                   %Calculate the sum of the first hidden layer
                   sumOfH1 = h1LayerNeurons*h1Weight((h1MinRange):(h1MaxRange), :) + 1 * h1BiasWeight(n,:);
                   
                   %Calculate the neurons for the h2Neuron
                   h2LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfH1));
                   
                   %Calculate the minimum range for the second hidden layer
                   h2MinRange = h2MinRange + 1;
                   %Calculate the maximum range for the second hidden layer
                   h2MaxRange = h2MaxRange + h2Size;
                   %Calculate the sum for the second hidden layer
                   sumOfH2 = h2LayerNeurons*h2Weight((h2MinRange):(h2MaxRange), :) + 1 * h2BiasWeight(n,:);
                   
                   %Calculate the output
                   outputValue = 1./(1 + 2.71828182845904523536.^-(sumOfH2));
              
                   
                   %----- BACKPROPAGATION BOOOOOOOOOOOOOOO -----%
                   %Calculate the errorInfo between the output to the
                   %second hidden layer
                   errorInfo = (trainData(n,noOfInput) - outputValue)*(outputValue * (1-outputValue));
                   
                   %Calculate the weight correction for the hidden layer 2
                   %weight                        
                   if n >= 2
                       
                       h2MMinRange = h2MMinRange + 1;
                       h2MMaxRange = h2MMaxRange + h2Size;
                       
                       h2WeightCorrection((h2MinRange):(h2MaxRange), :) = learnRate*(errorInfo*h2LayerNeurons') + momentum.*h2WeightCorrection((h2MMinRange):(h2MMaxRange), :);

                       
                   else
                       
                       h2WeightCorrection((h2MinRange):(h2MaxRange), :) = learnRate*(errorInfo*h2LayerNeurons');

                       
                   end
                       

                       
                   
                   %Calculate the weight correction for the bias of the
                   %hidden layer 2
                   
                   if n >= 2
                      
                       h2BiasWeightCorrection(n,:) = learnRate*(errorInfo) + momentum.*h2BiasWeightCorrection(n-1,:);
                       
                   else
                       h2BiasWeightCorrection(n,:) = learnRate*(errorInfo);

                   end
                   
                   %Calculate the sum weight of hidden one
                   %The column is the amount of weight and the row
                   %represent the neuron that it connected to 
                   dHidden = (errorInfo*(h2Weight((h2MinRange):(h2MaxRange), :)')).*((h2LayerNeurons.*(1 - h2LayerNeurons)));
                   
                   
                        %Calculate weight correction between hidden layer 1 and
                       %hidden layer 2
                   
                   if n >= 2
                       
                       h1MMinRange = h1MMinRange + 1;
                       h1MMaxRange = h1MMaxRange + h1Size;
                       
                       h1WeightCorrection((h1MinRange):(h1MaxRange), :) = (learnRate.*(dHidden'*h1LayerNeurons))' + momentum.*h1WeightCorrection((h1MMinRange):(h1MMaxRange), :);

                       
                   else
                       h1WeightCorrection((h1MinRange):(h1MaxRange), :) = (learnRate.*(dHidden'*h1LayerNeurons))';
                       
                   end
                   
                   %Calculate weight correction between hidden layer 1 and
                   %hidden layer 2
                   
                   if n >= 2
                      
                       h1BiasWeightCorrection(n,:) = learnRate.*(dHidden) + momentum.*h1BiasWeightCorrection((n-1),:);
                       
                   else
                       h1BiasWeightCorrection(n,:) = learnRate.*(dHidden);
                       
                   end
                   %Calculate delta value for input
                   dInput = (dHidden*(h1Weight((h1MinRange):(h1MaxRange), :)')).*((h1LayerNeurons.*(1-h1LayerNeurons)));
                   
                   %Calculate the weight correction term for input
                   if n >=2 
                       
                       mMinRange = mMinRange + 1;
                       mMaxRange = mMaxRange + (noOfInput-1);
                       inputWeightCorrection((minRange):(maxRange), :) = learnRate.*(dInput'*trainData(n,1:(noOfInput-1)))' + momentum.*inputWeightCorrection((mMinRange):(mMaxRange), :);

                   else    
                        inputWeightCorrection((minRange):(maxRange), :) = learnRate.*(dInput'*trainData(n,1:(noOfInput-1)))';
                                              
                   end
                   
                   %Caluclate the weight correction term for input bias
                  
                   if n >=2 
                      
                       inputBiasWeightCorrection(n,:) = learnRate.*(dInput) + momentum.*inputBiasWeightCorrection((n-1),:);

                       
                   else    
                        inputBiasWeightCorrection(n,:) = learnRate.*(dInput);

                   end
                   %Update range
                   minRange = maxRange;
                   h1MinRange = h1MaxRange;
                   h2MinRange = h2MaxRange;
                   
                   if (n >= 2)
                       
                        h2MMinRange = h2MMaxRange;
                        h1MMinRange = h1MMaxRange;
                        mMinRange = mMaxRange;
                   end
                   
                end
                                                    

                inputWeight = inputWeight + inputWeightCorrection;
                inputBiasWeight = inputBiasWeight  + inputBiasWeightCorrection;
                
                h1Weight = h1Weight + h1WeightCorrection;
                h1BiasWeight = h1BiasWeight + h1BiasWeightCorrection;
                               
                h2Weight = h2Weight + h2WeightCorrection;
                h2BiasWeight = h2BiasWeight + h2BiasWeightCorrection;
                
                if (epochs == epochSize)
                    trainingFinish = true;
                    disp('Training Finish');
                end
            end
            
            %FeedForward to test the training
            if(trainingFinish == true)
                                            
                %Initialise value for the min and max range
                h1MinRange = 0;
                h1MaxRange = 0;                
                h2MinRange = 0;
                h2MaxRange = 0;
                maxRange = 0;
                minRange = 0;
               
               
                for t = 1 : noOfData

                   %---- FEEDFORWARD WOOOOOOOOOOOO -----%

                       %Calculate the minimum range for the weight
                       minRange = minRange + 1;
                       %Calculate the maximum range for the weight
                       maxRange = maxRange + (noOfInput-1);
                       %Calculate the sum for the input
                                              
                       sumOfInput = trainData(t,1:(noOfInput-1))*inputWeight((minRange):(maxRange), :) + 1 * inputBiasWeight(t,:);
                       %The value for the four neurons 
                       h1LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfInput));

                       %Calculate the minimum range for the first hidden layer
                       h1MinRange = h1MinRange + 1;
                       %Calculate the maximum range for the first hidden layer
                       h1MaxRange = h1MaxRange + h1Size;
                       %Calculate the sum of the first hidden layer
                       sumOfH1 = h1LayerNeurons*h1Weight((h1MinRange):(h1MaxRange), :) + 1 * h1BiasWeight(t,:);

                       %Calculate the neurons for the h2Neuron
                       h2LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfH1));

                       %Calculate the minimum range for the second hidden layer
                       h2MinRange = h2MinRange + 1;
                       %Calculate the maximum range for the second hidden layer
                       h2MaxRange = h2MaxRange + h2Size;
                       %Calculate the sum for the second hidden layer
                       sumOfH2 = h2LayerNeurons*h2Weight((h2MinRange):(h2MaxRange), :) + 1 * h2BiasWeight(t,:);

                       %Calculate the output
                       trainOutPut(t,:) = 1./(1 + 2.71828182845904523536.^-(sumOfH2));
                       
                 
                       
                       %Update range
                       minRange = maxRange;
                       h1MinRange = h1MaxRange;
                       h2MinRange = h2MaxRange;
                       
                    
                end     
                
                
                if t == noOfData
                  denormalizeTrainingOutput = denormalizeData.denormalizeSetData(trainOutPut, normalizeData{2}, normalizeData{3});

                   trainTest = true; 
                    
                end
            end
               
            
            %FeedForward to test the accuracy of neural network
            if(trainTest == true)
            
                
                rawDenormalizeData = denormalizeData.denormalizeSetData(normalizeData{1}((727):(761), :), normalizeData{2}, normalizeData{3});
                testData = dataType.getData(normalizeData{1}((727):(761), :));
                
                disp('Testing start')
                %Initialise value for the min and max range
                h1MinRange = 0;
                h1MaxRange = 0;               
                h2MinRange = 0;
                h2MaxRange = 0;
                maxRange = 0;
                minRange = 0;
               
                %Initialize the weights for the neural network
                [testDataSize, testDataInput] = size(testData);
                
                for testDataCount = 1:testDataSize

      
                   %---- FEEDFORWARD WOOOOOOOOOOOO -----%

                       %Calculate the minimum range for the weight
                       minRange = minRange + 1;
                       %Calculate the maximum range for the weight
                       maxRange = maxRange + (testDataInput-1);
                       %Calculate the sum for the input
                                              
                       sumOfInput = testData(testDataCount,1:(testDataInput-1))*inputWeight((minRange):(maxRange), :) + 1 * inputBiasWeight(testDataCount,:);
                       %The value for the four neurons 
                       h1LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfInput));

                       %Calculate the minimum range for the first hidden layer
                       h1MinRange = h1MinRange + 1;
                       %Calculate the maximum range for the first hidden layer
                       h1MaxRange = h1MaxRange + h1Size;
                       %Calculate the sum of the first hidden layer
                       sumOfH1 = h1LayerNeurons*h1Weight((h1MinRange):(h1MaxRange), :) + 1 * h1BiasWeight(testDataCount,:);

                       %Calculate the neurons for the h2Neuron
                       h2LayerNeurons = 1./(1 + 2.71828182845904523536.^-(sumOfH1));

                       %Calculate the minimum range for the second hidden layer
                       h2MinRange = h2MinRange + 1;
                       %Calculate the maximum range for the second hidden layer
                       h2MaxRange = h2MaxRange + h2Size;
                       %Calculate the sum for the second hidden layer
                       sumOfH2 = h2LayerNeurons*h2Weight((h2MinRange):(h2MaxRange), :) + 1 * h2BiasWeight(testDataCount,:);

                       %Calculate the output
                       finalOutPut(testDataCount,:) = 1./(1 + 2.71828182845904523536.^-(sumOfH2));
                       
                 

                       %Update range
                       minRange = maxRange;
                       h1MinRange = h1MaxRange;
                       h2MinRange = h2MaxRange;
                       
                    
                end                
              
                denormalizeOutput = denormalizeData.denormalize(finalOutPut, normalizeData{2}, normalizeData{3});

             
            end
            
            disp('Testing Finish');
            rawTestData = dataType.getData(rawDenormalizeData);
            rawTrainData = dataType.getData(denormalizeTrainData);
            results = {denormalizeOutput; rawTestData(:, noOfInput); learnRate; momentum; denormalizeTrainingOutput; rawTrainData(:, testDataInput)};

            
        end
      
    end
    
end

