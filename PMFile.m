classdef PMFile
    %PMFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        FolderName
        FileName
        Content
        
    end
    
    methods % initialization
        function obj = PMFile(varargin)
            %PMFILE Construct an instance of this class
            %   takes 0, 1 or 2 arguments:
            % 1: character-string of folder name:
            % 2: character-string of file name;
            
            NumberOfArguments = length(varargin);
            switch NumberOfArguments
                case 0
                case 1
                    obj.FolderName = varargin{1};
                    
                case 2
                    obj.FolderName = varargin{1};
                    obj.FileName = varargin{2};
                    
                otherwise
                    error('Invalid number of arguments')
                
            end

        end
        
          function obj = set.FolderName(obj, Value)
            if ischar(Value)
                 obj.FolderName = Value;
            else
                error('Wrong argument type')
            end
           
        end
        
          function obj = set.FileName(obj, Value)
            assert(ischar(Value), 'Wrong argument type')
            obj.FileName = Value;
         end
        
        
    end
    
    methods % summary
        
        function obj = showSummary(obj)
            fprintf('\n*** This PMFile object can access data in the file with the following path:\n')
            fprintf('Folder: "%s"\n', obj.FolderName)
            fprintf('Filename: "%s"\n', obj.FileName)
        end
        
    end
    
    methods % getters
        
        function MainFolder = getFolderName(obj)
            MainFolder =  obj.FolderName;
        end
        
         function name = getFileNameWithoutExtension(obj)
            [~, name, ~] = fileparts(obj.getFileName);
        end

        function FileName = getFileName(obj)
            FileName =  obj.FileName;
        end

        function extension = getExtension(obj)
            [~, ~, extension] = fileparts(obj.getFileName);
        end
                
        
    end
    
    methods % read file
        
        function obj = open(obj)
               if exist(obj.getPath)== 2
                    open(obj.getPath)
                else
                    disp('PDF for selected file was not found.')
               end
        end
        
         function content = getContent(obj)
            if isempty(obj.Content)
                obj.Content =       fileread(obj.getPath);
            end
            content = obj.Content;
         end
        
        
    end
    
    methods % write file
        
        
        function obj =  writeCellString(obj, MyTextCell, varargin)
            
            switch length(varargin)
                case 0
                    SuppressNewLine = false;
                case 1
                    assert(islogical(varargin{1}) && isscalar(varargin{1}), 'Wrong input.')
                    SuppressNewLine = varargin{1};
 
            end
            
            
             if obj.folderExists
             else
                 mkdir(obj.FolderName)
             end
            
            fid =                  fopen(obj.getPath, 'wt');
            NumberOfRows=           size(MyTextCell, 1);
            NumberOfColumns =       size(MyTextCell, 2);
           
            for CurrentRow= 1 : NumberOfRows
                 ColumnText = '';
                for ColumnIndex = 1: NumberOfColumns
                    ColumnText = sprintf('%s%s', ColumnText, MyTextCell{CurrentRow, ColumnIndex});
                end
                
                if SuppressNewLine
                     fprintf(fid, '%s', ColumnText);
                else
                     fprintf(fid, '%s\n', ColumnText);
                end
               
            end
            
            fclose(fid);
        end
        
    end
    
    methods % edit filenames
        
         function obj = replaceFileByOldestDuplicateTaggedWith(obj, Tag)
            % REPLACEFILEBYOLDESTDUPLICATETAGGEDWITH delete all duplicates except the most recent one;
            % then rename the "base" file with most recent duplicate
            obj =     obj.deleteFilesWithNames(obj.getNamesOfDuplicatesExceptRecentWithTag(Tag));
            
            if obj.getNumberOfDuplicateFilesWithTag(Tag) >= 1
                obj =     obj.deleteFile;
            end
            
            obj =     obj.renameMostRecentDuplicateWithTag(Tag);
        end
        
    end
    
     methods % read directories
         
        function FileNames =   getFileNamesInDirectory(obj)
            ListWithFiles=              dir(obj.FolderName);
            ListWithFilesCell=          (struct2cell(ListWithFiles))';

            RowsWithDirectories=        cell2mat(ListWithFilesCell(:,5))==1;
            ListWithFilesCell(RowsWithDirectories,:)=    [];

            ListWithFilesCell=          ListWithFilesCell(:,1);
            RowToDelete =               cellfun(@(x) x(1) == '.', ListWithFilesCell); % delete hidden files that start with '.'
            ListWithFilesCell(RowToDelete,:) =          [];
            FileNames =                 ListWithFilesCell;
        end
        
        
        function exists = folderExists(obj)
            
            exists = exist(obj.FolderName);
            
            if exists == 7
                exists = true;
            else
                exists = false;
            end
            
        end
        
         function exists = fileExists(obj)
            
            exists = exist(obj.getPath);
            
            if exists == 2
                exists = true;
            else
                exists = false;
            end
            
        end
        
        
       
     
        
        
          
     end
     
     methods % write directories/ paths
         
        function obj = deleteFile(obj)
            obj = obj.deleteFilesWithNames({obj.FileName});
        end
        
        function obj = deleteFilesWithNames(obj, Names)
            paths = obj.getPathsForFileNames(Names);
            cellfun(@(x) delete(x), paths)
        end
        
        function obj = renameMostRecentDuplicateWithTag(obj, Tag) 
            ToBeOverwrittenName = obj.getNameOfMostRecentDuplicateWithTag(Tag);
            cellfun(@(x) obj.renameSourceFileNameWithTargetFileName(x, obj.FileName), ToBeOverwrittenName);
        end
        
        function obj = renameSourceFileNameWithTargetFileName(obj, Source, Target)
             if ~isequal(Target, Source)
                
                 fprintf('Moving file %s to file %s.\n', [obj.FolderName '/' Source], [obj.FolderName '/' Target])
                 
                movefile([obj.FolderName '/' Source], [obj.FolderName '/' Target])
            end
        end
        
        function obj =    renameFileWith(obj, NewFileName)
            if ~isequal(obj.FileName, NewFileName)
                movefile([obj.FolderName '/' obj.FileName], [obj.FolderName '/' NewFileName])
            end
        end
         
         
         
     end
    
    methods
  
        function duplicateFileNames = getDuplicateFileNamesWithTagAndNumbers(obj, Tag, Numbers)
            duplicateFileNames = arrayfun(@(x) [obj.getFileNameWithoutExtension, Tag, num2str(x), obj.getExtension], Numbers, 'UniformOutput', false);
        end

        function duplicateFileNames = getNameOfMostRecentDuplicateWithTag(obj, Tag)
              maximum =             max(obj.getNumbersOfDuplicatesWithTag(Tag));
             duplicateFileNames =   getDuplicateFileNamesWithTagAndNumbers(obj, Tag, maximum);
        end
        
        function obj = deleteAllDuplicatesWithTag(obj, Tag)
            DuplicateNames = obj.getNamesOfAllDuplicatesWithTag(Tag);
            paths =         obj.getPathsForFileNames(DuplicateNames);
            
        end

    end
    
    methods (Access = private)
        
        function path = getPath(obj)
             path  =    [obj.FolderName, '/', obj.FileName];   
        end
        
        function paths = getPathsForFileNames(obj, Names)
             paths  =    cellfun(@(x) [obj.FolderName, '/',x], Names, 'UniformOutput', false);
        end
        
    end
    
    methods (Access = private) % duplicates
       
          function number = getNumberOfDuplicateFilesWithTag(obj, Tag)
            number = length(obj.getNumbersOfDuplicatesWithTag(Tag));
        end
        
        function duplicateFileNames = getNamesOfDuplicatesExceptRecentWithTag(obj, Tag)
            numbers = obj.getNumbersOfDuplicatesWithTag(Tag);
            [~, rows] = max(numbers);
            numbers(rows) = [];
            duplicateFileNames = getDuplicateFileNamesWithTagAndNumbers(obj, Tag, numbers);
        end
        
          function numbers = getNumbersOfDuplicatesWithTag(obj, Tag)
            DuplicateNames =    obj.getNamesOfAllDuplicatesWithTag(Tag);
            [~, Names, ~] =        cellfun(@(x) fileparts(x), DuplicateNames, 'UniformOutput', false);
              start = length(obj.getFileNameWithoutExtension) + 2;
              numbers = cellfun(@(x) str2double(x(start:end)), Names);
          end
          
        function DuplicateNames = getNamesOfAllDuplicatesWithTag(obj, Tag)
            [~, name, ~] =         fileparts(obj.getFileName);
            myComparison =          [name, Tag];
            FileNames =             obj.getFileNamesInDirectory;
            rows =                  cellfun(@(x) contains(x, myComparison), FileNames);
            DuplicateNames =        FileNames(rows, :);
        end
        
    end
    
end

