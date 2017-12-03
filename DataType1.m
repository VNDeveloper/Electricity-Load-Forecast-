classdef DataType1
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      
        
    end
    
    methods

        function data = getData(obj, normalizeData)
            dataSet = [];
            count = 0;
            [row, column] = size(normalizeData);
            
           %This loops is for to get the specific data structure with 4
           %inputs and 1 outputs. The inputs is from the same hours but the
           %days from before
           for days = 5:row   
                                   
                    count = count + 1;
                    dataSet(count, :) = [normalizeData(days - 4) normalizeData(days - 3) normalizeData(days - 2) normalizeData(days - 1) normalizeData(days)];

           end
            
            %Return the data
            data = dataSet;
           
        end 


    end
    
end

