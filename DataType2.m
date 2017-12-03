classdef DataType2
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function data = getData(obj, normalizeData)
           
            dataSet = [];
            count = 0;
            [row, column] = size(normalizeData);
            
            for days = 5:row   
                       
                    count = count + 1;
                    dataSet(count, :) = [normalizeData(days, column - 2) normalizeData(days, column - 1) normalizeData(days - 4, column) normalizeData(days - 3, column) normalizeData(days - 2, column) normalizeData(days - 1, column) normalizeData(days, column)];

           end
            
            %Return the data
            data = dataSet;
            
        end
        
        
    end
    
end

