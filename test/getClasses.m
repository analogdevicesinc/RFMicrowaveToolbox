function sysobjs = getClasses()
    cpwd = pwd;
    [filepath,~,~] = fileparts(mfilename('fullpath'));
    cd(filepath)
    cd('..');

    filelist = dir(fullfile('+adi'));
    
    sysobjs = {};

    for fi = 1:length(filelist)
        if ~filelist(fi).isdir
        name = filelist(fi).name;
        if strcmp(name, 'Contents.m') || strcmp(name, 'Version.m')
            continue;
        end
        name = name(1:end-2);
        sysobjs = [sysobjs(:)', {name}];
%         if strcmp(name,'Rx.m') || strcmp(name,'Tx.m')
%             ffile = [filelist(fi).folder, filesep, name];
%             parts = strsplit(ffile,filesep);
%             name = parts{end-1}; name = name(2:end);
%             if strcmp(name,'common') || strcmp(name,'commonrf')
%                 continue;
%             end
%             if strcmp(name,'AD916x')
%                 continue
%             end
%             rxtx = parts{end}; rxtx = rxtx(1:end-2);
%             sysobjs = [sysobjs(:)', {[name,'.',rxtx]}];
        end
    end
    cd(cpwd);
end