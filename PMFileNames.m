classdef PMFileNames
    %PMFILENAMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = PMFileNames(inputArg1,inputArg2)
            %PMFILENAMES Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function Filename = getFileNameFromStrings(obj,ExperimentNames)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
                 if iscell(ExperimentNames) && length(ExperimentNames) >= 2
                Filename = 'Pooled';

            else
                names  =                ExperimentNames';
                names =                 cellfun(@(x) [x ', '], names, 'UniformOutput', false);
                Filename =       horzcat(names{:});
                Filename(end-1 : end) = [];
                
            end

        end
    end
end

