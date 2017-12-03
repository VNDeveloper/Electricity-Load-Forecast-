classdef DenormalizeData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function denormalizeData = denormalize(obj, outputValue, aValue, bValue)
                        
                
                %Change the position of the output for the layout            
                denormalizeData = (outputValue - bValue)/aValue;
                          
            
        end
        
        function denormalize = denormalizeSetData(obj, data, aValue, bValue)
            
           [row, column] = size(data);
           
           for a = 1: row
              
                  
               denormalizeData(a,:) = (data(a,:) - bValue)/aValue;
                
               
           end
           
           denormalize = denormalizeData;
            
        end
      
    end
    
end

