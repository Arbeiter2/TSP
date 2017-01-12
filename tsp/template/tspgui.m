function tspgui()


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
SEL_F = 'rws';
DATASET_NAME = 'unused';
CROSSOVER = 'xalt_edges';   % default blank
MUTATION_OP = 'inversion';
PATH_REP = 1; % tour encoding
RUNCOUNT = 1;
%	1 : adjacency representation
%	2 : path representation
%   3 : ordinal representation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read an existing population
% 1 -- to use the input file specified by the filename
% 0 -- click the cities yourself, which will be saved in the file called
%USE_FILE=0;
%FILENAME='data/cities.xy';
%if (USE_FILE==0)
%    % get the input cities
%    fg1 = figure(1);clf;
%    %subplot(2,2,2);
%    axis([0 1 0 1]);
%    title(NVAR);
%    hold on;
%    x=zeros(NVAR,1);y=zeros(NVAR,1);
%    for v=1:NVAR
%        [xi,yi]=ginput(1);
%        x(v)=xi;
%        y(v)=yi;
%        plot(xi,yi, 'ko','MarkerFaceColor','Black');
%        title(NVAR-v);
%    end
%    hold off;
%    set(fg1, 'Visible', 'off');
%    dlmwrite(FILENAME,[x y],'\t');
%else
%    XY=dlmread(FILENAME,'\t');
%    x=XY(:,1);
%    y=XY(:,2);
%end

% load the data sets
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1);
    datasets{i} = strcat('datasets/', datasetslist(i+2).name);
end

% benchmarks
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
benchmarklist = dir('TSPBenchmark/');
benchmarks=cell( size(benchmarklist,1)-2,1);
benchmarks=cell( size(benchmarklist,1)-2 ,1);
for i=1:size(benchmarks,1);
    benchmarks{i} = strcat('TSPBenchmark/', benchmarklist(i+2).name);
end

datasets = vertcat(datasets, benchmarks);

% start with first dataset
DATASET_NAME=datasets{1};
data = load([datasets{1}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

% datasets

% initialise the user interface
fh = figure('Visible','off','Name','TSP Tool','Position',[0,0,1024,768]);
ah1 = axes('Parent',fh,'Position',[.1 .55 .4 .4]);
plot(x,y,'ko')
ah2 = axes('Parent',fh,'Position',[.55 .55 .4 .4]);
axes(ah2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');
ah3 = axes('Parent',fh,'Position',[.1 .1 .4 .4]);
axes(ah3);
title('Histogram');
xlabel('Distance');
ylabel('Number');

ph = uipanel('Parent',fh,'Title','Settings','Position',[.55 .05 .45 .45]);
datasetpopuptxt = uicontrol(ph,'Style','text','String','Dataset','Position',[0 290 130 20]);
datasetpopup = uicontrol(ph,'Style','popupmenu','String',datasets,'Value',1,'Position',[130 290 230 20],'Callback',@datasetpopup_Callback);

llooppopuptxt = uicontrol(ph,'Style','text','String','Loop Detection','Position',[260 260 130 20]);
llooppopup = uicontrol(ph,'Style','popupmenu','String',{'off','on'},'Value',1,'Position',[390 260 50 20],'Callback',@llooppopup_Callback); 

mutationtxt = uicontrol(ph,'Style','text','String','Mutation op','Position',[20 260 90 20]);
mutation= uicontrol(ph,'Style','popupmenu', 'Value',1,'String',{'inversion','inversion2'}, 'Value',1,'Position',[130 260 100 20],'Callback',@mutation_Callback);

ncitiesslidertxt = uicontrol(ph,'Style','text','String','# Cities','Position',[0 230 130 20]);
%ncitiesslider = uicontrol(ph,'Style','slider','Max',128,'Min',4,'Value',NVAR,'Sliderstep',[0.012 0.05],'Position',[130 230 150 20],'Callback',@ncitiesslider_Callback);
ncitiessliderv = uicontrol(ph,'Style','text','String',NVAR,'Position',[280 230 50 20]);
nindslidertxt = uicontrol(ph,'Style','text','String','# Individuals','Position',[0 200 130 20]);
nindslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',NIND,'Sliderstep',[0.001 0.05],'Position',[130 200 150 20],'Callback',@nindslider_Callback);
nindsliderv = uicontrol(ph,'Style','text','String',NIND,'Position',[280 200 50 20]);
genslidertxt = uicontrol(ph,'Style','text','String','# Generations','Position',[0 170 130 20]);
genslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',MAXGEN,'Sliderstep',[0.001 0.05],'Position',[130 170 150 20],'Callback',@genslider_Callback);
gensliderv = uicontrol(ph,'Style','text','String',MAXGEN,'Position',[280 170 50 20]);
mutslidertxt = uicontrol(ph,'Style','text','String','Pr. Mutation','Position',[0 140 130 20]);
mutslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_MUT*100),'Sliderstep',[0.01 0.05],'Position',[130 140 150 20],'Callback',@mutslider_Callback);
mutsliderv = uicontrol(ph,'Style','text','String',round(PR_MUT*100),'Position',[280 140 50 20]);
crossslidertxt = uicontrol(ph,'Style','text','String','Pr. Crossover','Position',[0 110 130 20]);
crossslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_CROSS*100),'Sliderstep',[0.01 0.05],'Position',[130 110 150 20],'Callback',@crossslider_Callback);
crosssliderv = uicontrol(ph,'Style','text','String',round(PR_CROSS*100),'Position',[280 110 50 20]);
elitslidertxt = uicontrol(ph,'Style','text','String','% elite','Position',[0 80 130 20]);
elitslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(ELITIST*100),'Sliderstep',[0.01 0.05],'Position',[130 80 150 20],'Callback',@elitslider_Callback);
elitsliderv = uicontrol(ph,'Style','text','String',round(ELITIST*100),'Position',[280 80 50 20]);
representation= uicontrol(ph,'Style','popupmenu', 'Value',1,'String',{'adjacency','path','ordinal'}, 'Value',1,'Position',[170 50 130 20],'Callback',@representation_Callback);
crossover = uicontrol(ph,'Style','popupmenu', 'String',{'xalt_edges','xovsp','xovmp','xovscx'}, 'Value',1,'Position',[10 50 130 20],'Callback',@crossover_Callback);
%inputbutton = uicontrol(ph,'Style','pushbutton','String','Input','Position',[55 10 70 30],'Callback',@inputbutton_Callback);
runcountslidertxt = uicontrol(ph,'Style','text','String','Run Count','Position',[0 20 130 20]);
runcountslider = uicontrol(ph,'Style','slider','Max',100,'Min',1,'Value',RUNCOUNT,'Sliderstep',[0.01 0.05],'Position',[130 20 150 20],'Callback',@runcount_Callback);
runcountsliderv = uicontrol(ph,'Style','text','String',RUNCOUNT,'Position',[280 20 50 20]);

runbutton = uicontrol(ph,'Style','pushbutton','String','START','Position',[310 50 50 30],'Callback',@runbutton_Callback);

set(fh,'Visible','on');


    function datasetpopup_Callback(hObject,eventdata)
        dataset_value = get(hObject,'Value');
        dataset = datasets{dataset_value};
        % load the dataset
        data = load([dataset]);
        DATASET_NAME=dataset;
        x=data(:,1)/max([data(:,1);data(:,2)]);
        y=data(:,2)/max([data(:,1);data(:,2)]);
        %x=data(:,1);y=data(:,2);
        NVAR=size(data,1); 
        set(ncitiessliderv,'String',size(data,1));
        axes(ah1);
        plot(x,y,'ko') 
    end
    function llooppopup_Callback(hObject,eventdata)
        lloop_value = get(hObject,'Value');
        if lloop_value==1
            LOCALLOOP = 0;
        else
            LOCALLOOP = 1;
        end
    end
    function ncitiesslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(ncitiessliderv,'String',slider_value);
        NVAR = round(slider_value);
    end
    function nindslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(nindsliderv,'String',slider_value);
        NIND = round(slider_value);
    end
    function genslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(gensliderv,'String',slider_value);
        MAXGEN = round(slider_value);
    end
    function mutslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(mutsliderv,'String',slider_value);
        PR_MUT = round(slider_value)/100;
    end
    function mutation_Callback(hObject,eventdata)
        mutation_value = get(hObject,'Value');
        mutation_ops = get(hObject,'String');
        MUTATION_OP = mutation_ops(mutation_value);
        MUTATION_OP = MUTATION_OP{1};
    end
    function crossslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(crosssliderv,'String',slider_value);
        PR_CROSS = round(slider_value)/100;
    end
    function elitslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(elitsliderv,'String',slider_value);
        ELITIST = round(slider_value)/100;
        GGAP = 1-ELITIST;
    end
    function crossover_Callback(hObject,eventdata)
        crossover_value = get(hObject,'Value');
        crossovers = get(hObject,'String');
        CROSSOVER = crossovers(crossover_value);
        CROSSOVER = CROSSOVER{1};
    end
    function runcount_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(runcountsliderv,'String',slider_value);
        RUNCOUNT = slider_value;
    end
    function runbutton_Callback(hObject,eventdata)
        %set(ncitiesslider, 'Visible','off');
        set(nindslider,'Visible','off');
        set(genslider,'Visible','off');
        set(mutslider,'Visible','off');
        set(crossslider,'Visible','off');
        set(elitslider,'Visible','off');
        
        % only adjacency can only use xalt_edges
        if PATH_REP == 1
            CROSSOVER = 'xalt_edges';  % default crossover operator for adjacency
        elseif strcmp(CROSSOVER, 'xalt_edges')
            CROSSOVER = 'xovmp';  % classic single-point crossover
        end
        [pathstr,name,ext] = fileparts(DATASET_NAME);
        filename = strcat(name, ext);

        for run=1:RUNCOUNT
            [gen, minimum] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, MUTATION_OP, CROSSOVER, LOCALLOOP, ah1, ah2, ah3, SEL_F, PATH_REP, filename);
            end_run(gen);
        end
        [pathstr,name,ext] = fileparts(DATASET_NAME);
        
        tail = strjoin({num2str(NIND), num2str(MAXGEN), num2str(gen), MUTATION_OP, CROSSOVER, strcat('mut', num2str(100 * PR_MUT), 'pc')}, '-');

        export_fig(ah1, strcat('../images/', name, '-tour-', tail, '.png'));
        export_fig(ah2, strcat('../images/', name, '-evolution-', tail, '.png'));
        export_fig(ah3, strcat('../images/', name, '-histogram-', tail, '.png'));        
    end
    function representation_Callback(hObject,eventdata)
        rep_value = get(hObject,'Value');
        rep_str = get(hObject,'String');
        PATH_REP = rep_value;
    end
    function inputbutton_Callback(hObject,eventdata)
        [x y] = input_cities(NVAR);
        axes(ah1);
        plot(x,y,'ko')
    end
    function end_run(gen)
        %set(ncitiesslider,'Visible','on');
        set(nindslider,'Visible','on');
        set(genslider,'Visible','on');
        set(mutslider,'Visible','on');
        set(crossslider,'Visible','on');
        set(elitslider,'Visible','on');
    end
end
