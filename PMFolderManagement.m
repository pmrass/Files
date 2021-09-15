classdef PMFolderManagement
    %PMFOLDERMANAGEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        Folders
    end
    
    methods
        function obj = PMFolderManagement(varargin)
            %PMFOLDERMANAGEMENT Construct an instance of this class
            %   Detailed explanation goes here
            NumberOfArguments = length(varargin);
            switch NumberOfArguments
                case 1
                    obj.Folders = varargin{1};
                otherwise
                    error('Wrong input.')
                
            end
            
        end
        
        function obj = set.Folders(obj, Value)
            assert(iscellstr(Value) && isvector(Value), 'Wrong input.')
           obj.Folders = Value; 
        end
        
        function Folder = getFirstValidFolder(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            check = cellfun(@(x) exist(x) == 7, obj.Folders);
            
            FirstMatch = find(check == 1, 1, 'first');
            if isempty(FirstMatch)
               Folder = '';
            else
                Folder = obj.Folders{FirstMatch};
            end
            
        end
    end
    
    methods (Access = private)
        
    end
end




