classdef PMString
    %PMSTRING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Value = ''
    end
    
    methods
        function obj = PMString(varargin)
            %PMSTRING Construct an instance of this class
            %   Detailed explanation goes here
            NumberOfArguments= length(varargin);
            switch NumberOfArguments
                case 0
                case 1
                    obj.Value = varargin{1};
                otherwise
                    error('Invalid number of arguments')
                
            end
           
        end
        
        function obj = set.Value(obj, Value)
            assert(ischar(Value) || iscellstr(Value), 'Invalid argument type')
           obj.Value = Value; 
        end
        
        
        function truncated = getTruncatedStringsBefore(obj, Character, varargin)
            
            NumberOfArguments = length(varargin);
            switch NumberOfArguments
                case 0
                    Number = 1;
                case 1
                    Number = varargin{1};
                otherwise
                    error('Wrong input.')
            end
            
            MyString = obj.Value;
            
            if ischar(MyString)
               MyString = {MyString}; 
            end
            truncated = cellfun(@(x) obj.getTruncatedStringBefore(x, Character, Number), MyString, 'UniformOutput', false);
             
        end
        
        function MyString = getTruncatedStringBefore(obj, MyString, Character, Number)
            Position =                      find(MyString == Character,  Number, 'first');
            CutOffNumber =                  Position(Number);
            MyString(CutOffNumber:end) =    [];
            
        end
        
        
        function Position = findNumbersSurroundedBy(obj, TargetCharacter)
            targetCharacter = getPositionsOfCharacter(obj, TargetCharacter);
            result =        getPositionsOfNumbers(obj);
            two =           mergeTwoResult(obj, targetCharacter, result);
            Position =      strfind(two, '212')+1;
        end
        
        function obj = addZeroToNumbersSurroundedBy(obj, TargetCharacter)
            Positions = findNumbersSurroundedBy(obj, TargetCharacter);
            if length(Positions) > 1
                printString(obj)
                warning('Multiple targets. Only first one changed.')
            
            end
            
            if length(Positions) == 1
                oldValue = obj.Value;
                obj.Value = [oldValue(1:Positions-1) '0' oldValue(Positions:end)];
            end
        end
        
        function obj= printString(obj)
           fprintf('%s\n\', obj.getString) 
        end
        
        function string = getString(obj)
            string = obj.Value;
        end
        
        
        function result = getPositionsOfCharacter(obj, TargetCharacter)
            result = obj.Value;
            for index = 1:length(obj.Value)
                Current = obj.Value(index);
                if Current == TargetCharacter
                   result(index) = '1';
                else
                    result(index) = '0';
                end
                
            end
        end
        
        function result = getPositionsOfNumbers(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            result = obj.Value;
            for index = 1:length(obj.Value)
                Current = str2double(obj.Value(index));
                if isnan(Current)
                   result(index) = '0';
                else
                    result(index) = '1';
                end
                
            end
 
        end
        
        function two = mergeTwoResult(obj, one, two)
            for index=1:length(one)
               if one(index) == '1'
                   two(index) = '2';
               end
            end
            
        end
        
    end
end

