classdef PMFileManagementViewer < handle
    %PMFILEMANAGEMENTVIEWER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        FileManager
        GraphicObjects
        
    end
    
    methods
        
        function obj = PMFileManagementViewer(fileManager)
            %PMFILEMANAGEMENTVIEWER Construct an instance of this class
            %   Detailed explanation goes here
            obj.FileManager =                               fileManager;
            obj =                                           obj.createViews;
            obj.GraphicObjects.FolderName.String =          fileManager.getMainFolder;
            
            obj.GraphicObjects.EditField.Callback =         @obj.RenameSelectedFile;
            obj.GraphicObjects.FileList.Callback =          @obj.UpdateEditField;
            
            obj =                                           obj.resetSelectedFiles;
            
            
        end
        
        function SelectedFileNames = getSelectedFileNames(obj)
            SelectedFileNames = obj.FileManager.getSelectedFileNames;
            
        end
        
        function FileManager = getFileManager(obj)
            FileManager = obj.getFileManager;
        end
        
      
        
        function obj = resetSelectedFiles(obj)
            NewList =                                   obj.getFileListUpdatedByUserEntry;
            obj.GraphicObjects.FileList.String =       NewList;
             obj.FileManager =                          obj.FileManager.resetSelectedFileNames(NewList);

        end
        
        
        
        
        function obj = UpdateEditField(obj,src,~)
            if isempty(obj.GraphicObjects.FileList.Value)
            else
                String =                                obj.FileManager.getSelectedFileNames{obj.GraphicObjects.FileList.Value, 1};
                obj.GraphicObjects.EditField.String =   String;
            end
            
        end
        

        

        function obj = RenameSelectedFile(obj,src,~)
            
            OldFileName =           obj.getOldFileName; % this has to be done first;
            obj =                   obj.resetSelectedFiles;
           
           obj.FileManager =        obj.FileManager.renameFile(OldFileName, obj.getNewFileName);
                 
        end
        
        function OldFileNames = getFileNames(obj)
            OldFileNames = obj.GraphicObjects.FileList.String;
        end
        
     
        
        function OldFileName = getOldFileName(obj)
            OldFileName =               obj.FileManager.getSelectedFileNames{obj.GraphicObjects.FileList.Value,1};
        end
        
        function List = getFileListUpdatedByUserEntry(obj)
             List =              obj.FileManager.getSelectedFileNames;
             if ~isempty(obj.GraphicObjects.EditField.String)
                List{obj.GraphicObjects.FileList.Value,1} =        obj.GraphicObjects.EditField.String;
             end
        end
        
        function NewFileName = getNewFileName(obj)
             NewFileName =      obj.GraphicObjects.EditField.String;
            
        end
        
        function obj = setCallbacks(obj, varargin)
            NumberOfArguments = length(varargin);
            switch NumberOfArguments
                case 1
                    obj.GraphicObjects.EditField.Callback =          varargin{1};
                otherwise
                    error('Wrong input.')
            end
            
        end
    end
    
    methods (Access = private)
        
          function obj = createViews(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            ExportMovieWindow=                                  figure;
            ExportMovieWindow.Units=                            'normalized';
            ExportMovieWindow.Position=                         [ 0.2 0.72 0.4 0.2];
            ExportMovieWindow.Name=                             'File management';
            ExportMovieWindow.MenuBar=                          'none';
            ExportMovieWindow.Tag=                              'ExportMovieWindow';

            FolderNameTitle=                                    uicontrol;
            FolderNameTitle.Style=                              'Text';
            FolderNameTitle.Units=                              'normalized';
            FolderNameTitle.Position=                           [0.05 0.8 0.4 0.1];
            FolderNameTitle.String=                             'Folder name:';

            FolderName=                                         uicontrol;
            FolderName.Style=                                   'text';
            FolderName.Units=                                   'normalized';
            FolderName.Position=                                    [0.5 0.8 0.45 0.1];
            FolderName.Tag=                                     'MovieName';

            EditTitle=                                        uicontrol;
            EditTitle.Style=                                    'Text';
            EditTitle.Units=                                    'normalized';
            EditTitle.Position=                                 [0.05 0.7 0.4 0.1];
            EditTitle.String=                                   'Edit:';

            EditField=                                          uicontrol;
            EditField.Style=                                    'Edit';
            EditField.Units=                                    'normalized';
            EditField.Position=                                 [0.5 0.7 0.45 0.1];
            EditField.Tag=                                      'MovieName';
                        
            FileList=                                           uicontrol;
            FileList.Style=                                     'listbox';
            FileList.Units=                                     'normalized';
            FileList.Position=                                  [0.05 0.02 0.8 0.6];
            FileList.String=                                    '';
            FileList.Value=                                     1;

            obj.GraphicObjects.FolderName=                      FolderName;
            obj.GraphicObjects.FileList=                        FileList;
            obj.GraphicObjects.EditTitle=                       EditTitle;
            obj.GraphicObjects.EditField=                       EditField;
            
            obj.GraphicObjects.ExportMovieWindow=               ExportMovieWindow;

        end

    end
end

