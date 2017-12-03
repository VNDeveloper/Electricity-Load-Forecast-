classdef NormalizeData
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        aValue
        bValue
        
    end
    
    methods
        
        function data = normalization(obj,filename, range)
            
            %Data From 1997
            %A - C is the date
            %Row of data 2-366
            %DEF 1, 2 ,3 hours
            
            %get the raw data out of the excel
            allRawData = xlsread(filename, range);
            
            %to find the size of the data 
            [row, column] = size(allRawData);
            compareMax = 0;
            compareMin = 0;
            %To find out the min and max value
            for c = 1:column
               
                maxVal = max(allRawData(:,c));
                minVal = min(allRawData(:,c));
                
                if maxVal > compareMax
                    
                   Rmax = maxVal;
                    
                end
                
                if minVal < compareMin
                
                    Rmin = minVal;
                    
                elseif (c == 1)  
                    
                    Rmin = minVal;
                    
                end
                 
                compareMax = maxVal;
                compareMin = minVal;
                
            end
            
            
           %to loop through each column of the data 
           for n = 1:column 
              
               extractData = allRawData(:,n);
                
                %calculate A and B
                A = 1/(Rmax - Rmin);
                B = (-1/(Rmax-Rmin))*Rmin;
                
                %calculated the normalize data
                normalizeData(:,n) = A*extractData + B;
                
            
           end
            data = {normalizeData; A; B};
            
        end
        
    end
    
end

