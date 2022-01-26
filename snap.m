function snap(h,uniqName)
% set defaults
showFile = 1;

% set paths
snapPath = fileparts(mfilename('fullpath'));
runFile = matlab.desktop.editor.getActiveFilename;
[~,runName] = fileparts(runFile);
curDate = datestr(now,'yyyymmddHHMMSS');
snapBaseName = strjoin({curDate,uniqName,runName},'-');

% make dirs if needed
figsDir = fullfile(snapPath,'figs');
if ~exist(figsDir,'dir')
    mkdir(figsDir);
end
codeDir = fullfile(snapPath,'code');
if ~exist(codeDir,'dir')
    mkdir(codeDir);
end

% save figure
saveFigName = fullfile(figsDir,[snapBaseName,'.png']);
saveas(h,saveFigName);

% write text on saved figure
I = imread(saveFigName);
I = insertText(I,[0,0],snapBaseName,'FontSize',max([5,round(size(I,2)/50)]),...
    'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
imwrite(I,saveFigName);

% copy code
status = copyfile(runFile,fullfile(codeDir,[snapBaseName,'.m']));
if status
    fprintf("%s snap success\n",snapBaseName);
    if showFile
        if ismac
            system(['open "', figsDir, '" &']);
        elseif ispc
            winopen(figsDir);
        end
    end
end