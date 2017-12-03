classdef errorCalculate
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods    
        
        function mse = callMSE(obj, data)
                
            total = (data(:,1) - data(:,2)).^2;
                
            mse = mean(total);
        end
        
        
        function mape = callMAPE(obj, data)   
            
            error = (data(:,2) - data(:,1));
                
            total = mean(abs(error./data(:,2)));
                
            mape = total * 100;  
            
        end 
        
        function sep = callSEP(obj, data)
            
            total = (data(:,1) - data(:,2)).^2;
            
            sep = sqrt(mean(total)) * 100/mean(data(:,2));
            
        end
    end
    
    
end

