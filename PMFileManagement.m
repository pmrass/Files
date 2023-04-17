classdef PMFileManagement
    %PMFILEMANAGEMEN For manipulating files
    %   for example adding or changing prefixes;


    
    properties (Access = private)
        
        MainFolder % change this so that using PMFile array as basis for this;
        
        
        OldPreFixString
        NewPreFixString
        DeleteUntilCharacter =   ''
        
        SelectedFileNames
        Content
        
    end
    
    
    methods % INITIALIZE
        
        function obj = PMFileManagement(varargin)
            %PMFILEMANAGEMEN Construct an instance of this class
            %   takes 0, 1, 2, or 3 arguments:
            % 1: main folder
            % 2: selected filenames (2 arguments)
            %       or OldPreFixString (3 arguments:
            % 3: NewPreFixString;
            NumberOfArguments = length(varargin);
            switch NumberOfArguments
                case 0
                case 1
                     obj.MainFolder =       varargin{1};
                     
                case 2
                    obj.MainFolder =        varargin{1};
                    obj.SelectedFileNames = varargin{2};
                    
                case 3
                     obj.MainFolder =        varargin{1};
                     obj.OldPreFixString = varargin{2};
                     obj.NewPreFixString = varargin{3};
                    
                    
                    
                otherwise
                    error('Invalid number of arguments')
                
            end
           
            
        end
        
        function obj = set.MainFolder(obj, Value)
            assert(ischar(Value), 'Wrong argument type')
            obj.MainFolder = Value;
            if exist(obj.MainFolder) ~= 7
                    mkdir(obj.MainFolder) 
            end
        end
        
        function obj = set.SelectedFileNames(obj, Value)
             if ischar(Value)
                Value = {Value}; 
             end
             
            assert(iscellstr(Value) && isvector(Value), 'Wrong input type')
            obj.SelectedFileNames = Value;
         end
        
        function obj = set.OldPreFixString(obj, Value)
            assert(ischar(Value), 'Wrong argument type.')
            obj.OldPreFixString = Value;
        end
        
        function obj = set.NewPreFixString(obj, Value)
            assert(ischar(Value), 'Wrong argument type.')
            obj.NewPreFixString = Value;
         end
        
        
    end
    
    methods % SUMMARY

        function obj = showSummary(obj)
            fprintf('\n*** This PMFileManagement object can be used to manipulte files.\n')
            fprintf('It has the main folder "%s".\n', obj.MainFolder)
            fprintf('When changing filenames by prefix it detects "%s" and changes to "%s".\n', obj.OldPreFixString, obj.NewPreFixString)
            

        end

        end
    
    methods % SETTERS

        function obj = setMainFolder(obj, Value)


            obj.MainFolder = Value;
    end
        
        function obj =      setPrefixStrings(obj, old, new)
            % SETPREFIXSTRINGS set prefix-strings
            % takes 2 arguments:
            % 1: string: "old" prefix:
            % 2: string: "new" prefix
             obj.OldPreFixString = old;
             obj.NewPreFixString = new;
        end
         
        function obj =      resetSelectedFileNames(obj, List)
            obj.SelectedFileNames =  List; 
        end
        
    end
    
    methods % GETTERS

            function FileNames =            getFileNames(obj) 
                % GETFILENAMES returns list with all filenames in folder
                myFile =         PMFile(obj.MainFolder);
                FileNames =      myFile.getFileNamesInDirectory;
            end

            function paths =                getSelectedPaths(obj)
              paths  =   cellfun(@(x) [obj.MainFolder, '/', x], obj.SelectedFileNames, 'UniformOutput', false);  
            end

            function MainFolder =           getMainFolder(obj)
            MainFolder =  obj.MainFolder;
            end

            function SelectedFileNames =    getSelectedFileNames(obj)
            SelectedFileNames = obj.SelectedFileNames;
            end

       end

    methods % EXECUTION RENAME
        
        function addPrefixToFiles(obj)
            % ADDPREFIXTOFILES adds prefix
            % each file getts "new" prefix attached at front of filename;
            % "old" prefix is irrelevant
            FileNameList =         obj.getFileNames;
            
            for FileIndex = 1 : length(FileNameList)
                OriginalFileName=           [obj.MainFolder '/' FileNameList{FileIndex}];
                FileNameWithPrefix=           [obj.MainFolder '/' obj.NewPreFixString FileNameList{FileIndex}];
                movefile(OriginalFileName,FileNameWithPrefix)
            end
        end
        
        function replaceStringsInFile(obj)
            % REPLACEPREFIXSTRINGS replaces the "old" prefix-string with the "new" prefix-string in the each file in the selected folder;
            
            ListWithAllFileNamesInMainFolder = obj.getFileNames;
            LengthOfReplacedString = length(obj.OldPreFixString);
            
            for FileIndex = 1 : size(ListWithAllFileNamesInMainFolder,1)
                
                OldFileName =               ListWithAllFileNamesInMainFolder{FileIndex};
                ListWithMatches =           strfind(OldFileName, obj.OldPreFixString);
                if length(ListWithMatches) == 1  
                    
                    FirstPart =             OldFileName(1 : ListWithMatches - 1);
                    LastPart =              OldFileName(ListWithMatches + LengthOfReplacedString : end);
                    NewName =               [FirstPart  obj.NewPreFixString LastPart];
                    
                    movefile([obj.MainFolder '/'  OldFileName], [obj.MainFolder '/'  NewName]) % rename file
                    
                end          

            end        
            
        end

        function obj =      renameFile(obj, OldFileName, NewFileName)
            
            myFile =    PMFile(obj.MainFolder, OldFileName);
            myFile =    myFile.renameFileWith(NewFileName);
            
        
        end
        
        function removePrefixFromFile(obj)
            for FileIndex = 1: size(obj.getFileNames,1)
                Search =    strfind(obj.getFileNames{FileIndex}, obj.OldPreFixString);
                if length(Search) == 1
                    FileNameNew = obj.getFileNames{FileIndex}(Search + length(obj.OldPreFixString)  : end);
                     NewFilename_Complete=           [obj.MainFolder '/'  FileNameNew];
                    movefile([obj.MainFolder '/' obj.getFileNames{FileIndex}], NewFilename_Complete)
                end
            end     
        end
        
        function deletePrefixFromFiles(obj)

            ListWithFilesCell =             obj.getFileNames;
            FolderName =                    obj.MainFolder;
            
            DeletUntilFirst =               obj.DeleteUntilCharacter;
            
            NumberOfFiles =     size(ListWithFilesCell,1);
        
            for FileIndex = 1:NumberOfFiles

                %% get complete old filename
                FileNameOld =                   ListWithFilesCell{FileIndex};
                OldFilename_Complete=           [FolderName '/' FileNameOld];


                %% get complete new filename
                if ~isempty(DeletUntilFirst)
                    DeleteUntil =               find(FileNameOld == DeletUntilFirst,1, 'first');
                    FileNameNew =               FileNameOld(DeleteUntil+1:end);

                else
                     FileNameNew =       FileNameOld;

                end
                NewFilename_Complete=           [FolderName '/'  FileNameNew];
                
                %% rename:
                movefile(OldFilename_Complete,NewFilename_Complete)

            end
            
        end
        
        function renameFiles_AddZerosToNumbersSurroundedBy(obj, Value)
            OldFileNames =      obj.getFileNames;
            NewFileNames =      cellfun(@(x) PMString(x).addZeroToNumbersSurroundedBy('_').getString, OldFileNames, 'UniformOutput', false);
            cellfun(@(old, new) obj.renameFile(old, new), OldFileNames, NewFileNames)
            
        end

    end
    
    methods % COPY
        
        
    end



 

end

