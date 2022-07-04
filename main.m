function main()

if ~isdeployed
    disp('adding paths');
    addpath(genpath('/N/u/brlife/git/encode'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('wma_tools'))
end

config = loadjson('config.json');

if isfield(config,'fe')
    disp('using life input')
    load(config.fe)
    feORwbfg=fe;
    fibNum=length(feORwbfg.fg.fibers);
else
    disp('using tck input')
    feORwbfg=fgRead(config.track);
    fibNum=length(feORwbfg.fibers);
end

if isfield(config,'output')
    disp(['loading (deprecated) > ' config.output])
    load(config.output)
elseif isfield(config,'classification')
    disp(['loading > ' config.classification])
    load(config.classification)
else
    disp('no classification input')
end

if ~notDefined('classification')
    if length(classification.index)~=fibNum
        error('\n mismatch between classification structure and input fibergroup \n Hint: check stream count \n classificiation %i \n track %i', length(classification.index),length(feORwbfg.fibers))
        exit
    end
end

if notDefined('classification')
    disp('running wma_quantWBFG -------------------------------------')
    [results] = wma_quantWBFG(feORwbfg);
else
    disp('running wma_quantAllWMNorm---------------------------------')
    [results] = wma_quantAllWMNorm(feORwbfg,classification);
end

disp('generating graph ------------------------------------------')

tableArray{1,1}='wbfg';
tableArray{1,2}=results.WBFG.stream_count;
tableArray{1,3}=results.WBFG.volume;
tableArray{1,4}=results.WBFG.avg_stream_length;
tableArray{1,5}=results.WBFG.stream_length_stdev;
tableArray{1,6}=results.WBFG.avgFullDisp;
tableArray{1,7}=results.WBFG.stDevFullDisp;
tableArray{1,8}=results.WBFG.LogFitA;
tableArray{1,9}=results.WBFG.LogFitB;
tableArray{1,10}=results.WBFG.length_total;

%endpointDensity1
tableArray{1,11}=nan;
%endpointDensity2
tableArray{1,12}=nan;
%avgEndpointDist1
tableArray{1,13}=nan;
%avgEndpointDist2
tableArray{1,14}=nan;
%stDevEndpointDist1
tableArray{1,15}=nan;
%stDevEndpointDist2
tableArray{1,16}=nan;
%midpointDensity
tableArray{1,17}=nan;
%avgMidpointDist
tableArray{1,18}=nan;
%stDevMidpointDist
tableArray{1,19}=nan;
%norms.volumeProp
tableArray{1,20}=1;
%norms.countProp
tableArray{1,21}=1;
%norms.wireProp
tableArray{1,22}=1;

fieldNames={'stream_count', 'volume','avg_stream_length','stream_length_stdev','avgFullDisp','stDevFullDisp',...
    'LogFitA','LogFitB','length_total','endpointDensity1','endpointDensity2','avgEndpointDist1','avgEndpointDist2',...
    'avgEndpointDist2','stDevEndpointDist1','stDevEndpointDist2','endpointDensity1','endpointDensity2','midpointDensity',...
    'avgMidpointDist','stDevMidpointDist','norms.volumeProp','norms.countProp','norms.wireProp'};

fullFieldNames={'structureID','StreamlineCount', 'volume','averageStreamlineLength','streamlineLengthStdev','averageFullDisplacement','fullDisplacementStdev',...
    'ExponentialFitA','ExponentialFitB','StreamlineLengthTotal','endpoint1Density','Endpoint2Density','AverageEndpointDistanceFromCentroid1',...
    'AverageEndpointDistanceFromCentroid2','stdevOfEndpointDistanceFromCentroid1','stdevEndpointDistanceFromCentroid2','MidpointDensity',...
    'averageMidpointDistanceFromCentroid','stDevOfMidpointDistanceFromCentroid','TotalVolumeProportion','TotalCountProportion','TotalWiringProportion'};

%conditionals=11:19;

disp('parsing fiber structure')
[~, fe] = bsc_LoadAndParseFiberStructure(feORwbfg);

% if both fe and class are present
figure
rangeSet=11:250;
if ~notDefined('fe') & ~notDefined('classification')
    %readout stats
    textBoxHandle=subplot(2,5,[1 6]);
    textBoxPos=get(textBoxHandle,'position');
    annotation('textbox',...
        [textBoxPos(1) textBoxPos(2) textBoxPos(3) textBoxPos(4)],...
        'String',{['Raw Stream Count: ', num2str(results.WBFG.stream_count)],...
        ['Total Stream Volume: ', num2str(results.WBFG.volume)],...
        ['Raw fit curve A: ', num2str(results.WBFG.LogFitA)],...
        ['Raw fit curve B: ', num2str(results.WBFG.LogFitB)],...
        ['Raw Mean stream length: ', num2str(results.WBFG.avg_stream_length)],...
        ['Raw stream length stDev: ', num2str(results.WBFG.stream_length_stdev)],...
        ['LiFE RMSE: ', num2str(results.LiFEstats.RMSE.WB)],...
        ['LiFE All Vox Error: ', num2str(results.LiFEstats.RMSE.WB_norm_total)],...
        ['LiFE Survivors count: ', num2str(results.LiFEstats.posWBFG.stream_count)],...
        ['LiFE Survivors pct: ', num2str((results.LiFEstats.posWBFG.stream_count/results.WBFG.stream_count)*100)],...
        ['Nonzero fit curve A: ', num2str(results.LiFEstats.posWBFG.LogFitA)],...
        ['Nonzero fit curve B: ', num2str(results.LiFEstats.posWBFG.LogFitB)],...
        ['Raw Identified Streams: ', num2str(sum(classification.index>0))],...
        ['Raw Identified Streams Proportion: ', num2str(sum(classification.index>0)/results.WBFG.stream_count)]},...
        'FontSize',14,...
        'FontName','Arial',...
        'LineStyle','--',...
        'EdgeColor',[1 1 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9  0.9 0.9],...
        'Color',[0.84 0.16 0]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

    %unused
    %['Avg stream Asym ratio: ', num2str(results.WBFG.avgAsymRat)],...
    %['stream Asym ratio stDev: ', num2str(results.WBFG.avgAsymRat)],...
    % ['Tracts Segmented: ', num2str(sum(length(rightNames)+length(interHemiNames)))],...

    posBool=fe.life.fit.weights>0;

    % Plot comparing pre and post life streamline proportion by length
    subplot(2,5,2)
    hold on
    plot ((rangeSet),results.WBFG.lengthProps(rangeSet),'b', 'LineWidth',1.25)
    plot ((rangeSet),(results.WBFG.LogFitA*exp(results.WBFG.LogFitB*(rangeSet-10))),'c', 'LineWidth',1.25)
    %plot ((rangeSet),lognpdf(rangeSet,results.WBFG.LogFitA,results.WBFG.LogFitB),'c', 'LineWidth',1.25)

    plot ((rangeSet),results.LiFEstats.posWBFG.lengthProps(rangeSet),'r', 'LineWidth',1.25)
    plot ((rangeSet),(results.LiFEstats.posWBFG.LogFitA*exp(results.LiFEstats.posWBFG.LogFitB*(rangeSet-10))),'m', 'LineWidth',1.25)


    title({'Normalized WBFG & NonZero Weighted',' Stream Count Comparison'})
    legend('WBFG','WBFG Fit','NonZero','NonZero Fit')
    xlabel('Streamline Length (mm)')
    ylabel('Whole Brain proportion')

    % Plot illustrating the bias in the validated streamlines as assocaited
    % with length
    subplot(2,5,3)
    hold on
    plot ((rangeSet),(results.WBFG.lengthProps(rangeSet)-results.LiFEstats.posWBFG.lengthProps(rangeSet))*10000,'g', 'LineWidth',1.25)
    plot ((rangeSet),(zeros(1,length(rangeSet)))*10000,'r', 'LineWidth',1.25)
    title({'Survival Bias','Relative to Streamline Length'})
    ylim([-50,50])
    legend('WBFG ratio - Validated ratio','No Bias')
    xlabel('Streamline Length (mm)')
    ylabel('Survival bias (%)')

    %plot looking at cumulative fiber length proportions
    cumValid=zeros(1,length(results.WBFG.lengthProps));
    cumWBFG=cumValid;
    for ilengths=5:length(results.WBFG.lengthProps)
        cumValid(ilengths)=results.LiFEstats.posWBFG.lengthProps(ilengths)+sum(cumValid(ilengths-1));
        cumWBFG(ilengths)=results.WBFG.lengthProps(ilengths)+sum(cumWBFG(ilengths-1));
    end

    subplot(2,5,7)
    hold on
    plot (((rangeSet)),cumWBFG((rangeSet)),'b', 'LineWidth',1.25)
    plot (((rangeSet)),cumValid((rangeSet)),'r', 'LineWidth',1.25)
    title({'Cumulative portion of fibers','in connectome, by length'})
    legend('WBFG','Validated')
    xlabel('Streamline Length (mm)')
    ylabel('Portion of tracts less than or equal to length')

    %% Seg Case -- Plots Specific to segmentation output

    %set values
    classBool=classification.index>0;
    [WBFGclassHist, ~]=histcounts(results.WBFG.lengthData(classBool),(1:300));
    [validClassHist, ~]=histcounts(results.WBFG.lengthData(classBool & posBool),(1:300));

    % Plot comparing pre and post life classified streamline proportion by length
    subplot(2,5,8)
    hold on
    plot ((rangeSet),(WBFGclassHist(rangeSet)/results.WBFG.stream_count)*100,'b', 'LineWidth',1.25)
    plot ((rangeSet),(validClassHist(rangeSet)/results.LiFEstats.posWBFG.stream_count)*100,'r', 'LineWidth',1.25)
    title({'Classified Streamline Proportion','Comparison: WBFG & Surviving'})
    legend('WBFG, AFQ classified','Validated & AFQ classified')
    xlabel('Streamline Length (mm)')
    ylabel('Proportion of Whole Brain Streamlines Classified (%)')

    %% computation for seg bar plots
    %count plot
    classificationGrouping = wma_classificationStrucGrouping_v2(classification);
    countPlotInput=zeros(2,(length(classificationGrouping.names)));
    volPlotInput=zeros(2,(length(classificationGrouping.names)));

    for itracts=1:length(classificationGrouping.names)
        fprintf('\n %s',classificationGrouping.names{itracts})
        tractIndexes=unique(classification.index(classificationGrouping.index==itracts));
        for iVariants=1:length(tractIndexes)
            countPlotInput(iVariants,itracts)=results.WBFG.tractStats{tractIndexes(iVariants)}.norms.countProp;
            volPlotInput(iVariants,itracts)=results.WBFG.tractStats{tractIndexes(iVariants)}.norms.volumeProp;
        end
    end

    bottomPlot1=subplot(2,5,[4,5]);
    hold on
    bar(100*countPlotInput')
    title({' proportion of connectome',' streamlines in tract'})
    legend('Left','Right')
    xlabel('Tract')
    ylabel('% classificaiton input streamlines in tract (%)')
    ylim([-0 max(max(countPlotInput))*133])
    set(gca,'xtick',[1:1:length(classificationGrouping.names)])
    set(gca,'XTickLabel',classificationGrouping.names, 'FontSize',8,'FontName','Times')
    bottomPlot1.XTickLabelRotation=-45;

    bottomPlot2=subplot(2,5,[9,10]);
    hold on
    bar((volPlotInput')*100)
    title({'Proportion of wm volume','occupied by tract'})
    legend('Left','Right')
    xlabel('Tract')
    ylabel('% wm volume proportion occupied by tract (%)')
    ylim([-0 max(max(volPlotInput))*133])
    set(gca,'xtick',[1:1:length(classificationGrouping.names)])
    set(gca,'XTickLabel',classificationGrouping.names, 'FontSize',8,'FontName','Times')
    bottomPlot2.XTickLabelRotation=-45;

    fig = gcf;
    fig.Position = [100 50 2200 1250];

    % if only fe is passed
elseif ~notDefined('fe') & notDefined('classification')
    textBoxHandle=subplot(3,2,[1 3 5]);
    textBoxPos=get(textBoxHandle,'position');
    annotation('textbox',...
        [textBoxPos(1) textBoxPos(2) textBoxPos(3) textBoxPos(4)],...
        'String',{['Raw Stream Count: ', num2str(results.WBFG.stream_count)],...
        ['Total Stream Volume: ', num2str(results.WBFG.volume)],...
        ['Raw fit curve A: ', num2str(results.WBFG.LogFitA)],...
        ['Raw fit curve B: ', num2str(results.WBFG.LogFitB)],...
        ['Raw Mean stream length: ', num2str(results.WBFG.avg_stream_length)],...
        ['Raw stream length stDev: ', num2str(results.WBFG.stream_length_stdev)],...
        ['LiFE RMSE: ', num2str(results.LiFEstats.RMSE.WB)],...
        ['LiFE All Vox Error: ', num2str(results.LiFEstats.RMSE.WB_norm_total)],...
        ['Nonzero fit curve A: ', num2str(results.LiFEstats.posWBFG.LogFitA)],...
        ['Nonzero fit curve B: ', num2str(results.LiFEstats.posWBFG.LogFitB)],...
        ['LiFE Survivors count: ', num2str(results.LiFEstats.posWBFG.stream_count)],...
        ['LiFE Survivors pct: ', num2str((results.LiFEstats.posWBFG.stream_count/results.WBFG.stream_count)*100)]},...
        'FontSize',14,...
        'FontName','Arial',...
        'LineStyle','--',...
        'EdgeColor',[1 1 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9  0.9 0.9],...
        'Color',[0.84 0.16 0]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

    %unused
    %['Avg stream Asym ratio: ', num2str(results.WBFG.avgAsymRat)],...
    %['stream Asym ratio stDev: ', num2str(results.WBFG.avgAsymRat)],...
    % ['Tracts Segmented: ', num2str(sum(length(rightNames)+length(interHemiNames)))],...

    posBool=fe.life.fit.weights>0;

    % Plot comparing pre and post life streamline proportion by length
    subplot(3,2,2)
    hold on
    plot ((rangeSet),results.WBFG.lengthProps(rangeSet),'b', 'LineWidth',1.25)
    plot ((rangeSet),(results.WBFG.LogFitA*exp(results.WBFG.LogFitB*(rangeSet-10))),'c', 'LineWidth',1.25)
    %plot ((rangeSet),lognpdf(rangeSet,results.WBFG.LogFitA,results.WBFG.LogFitB),'c', 'LineWidth',1.25)

    plot ((rangeSet),results.LiFEstats.posWBFG.lengthProps(rangeSet),'r', 'LineWidth',1.25)
    plot ((rangeSet),(results.LiFEstats.posWBFG.LogFitA*exp(results.LiFEstats.posWBFG.LogFitB*(rangeSet-10))),'m', 'LineWidth',1.25)

    title({'Normalized WBFG & NonZero Weighted',' Stream Count Comparison'})
    legend('WBFG','WBFG Fit','NonZero','NonZero Fit')
    xlabel('Streamline Length (mm)')
    ylabel('Whole Brain proportion')

    % Plot illustrating the bias in the validated streamlines as assocaited
    % with length
    subplot(3,2,4)
    hold on
    plot ((rangeSet),(results.WBFG.lengthProps(rangeSet)-results.LiFEstats.posWBFG.lengthProps(rangeSet))*10000,'g', 'LineWidth',1.25)
    plot ((rangeSet),(zeros(1,length(rangeSet)))*10000,'r', 'LineWidth',1.25)
    title({'Survival Bias','Relative to Streamline Length'})
    ylim([-50,50])
    legend('WBFG ratio - Validated ratio','No Bias')
    xlabel('Streamline Length (mm)')
    ylabel('Survival bias (%)')

    %plot looking at cumulative fiber length proportions
    cumValid=zeros(1,length(results.WBFG.lengthProps));
    cumWBFG=cumValid;
    for ilengths=5:length(results.WBFG.lengthProps)
        cumValid(ilengths)=results.LiFEstats.posWBFG.lengthProps(ilengths)+sum(cumValid(ilengths-1));
        cumWBFG(ilengths)=results.WBFG.lengthProps(ilengths)+sum(cumWBFG(ilengths-1));
    end

    subplot(3,2,6)
    hold on
    plot (((rangeSet)),cumWBFG((rangeSet)),'b', 'LineWidth',1.25)
    plot (((rangeSet)),cumValid((rangeSet)),'r', 'LineWidth',1.25)
    title({'Cumulative portion of fibers','in connectome, by length'})
    legend('WBFG','Validated')
    xlabel('Streamline Length (mm)')
    ylabel('Portion of tracts less than or equal to length')

    fig = gcf;
    fig.Position = [100 100 1200 1000];

    %% no life, but with classification
elseif notDefined('fe') & ~notDefined('classification')
    %readout stats
    textBoxHandle=subplot(3,4,[1 5 9]);
    textBoxPos=get(textBoxHandle,'position');
    annotation('textbox',...
        [textBoxPos(1) textBoxPos(2) textBoxPos(3) textBoxPos(4)],...
        'String',{['Raw Stream Count: ', num2str(results.WBFG.stream_count)],...
        ['Total Stream Volume: ', num2str(results.WBFG.volume)],...
        ['Raw fit curve A: ', num2str(results.WBFG.LogFitA)],...
        ['Raw fit curve B: ', num2str(results.WBFG.LogFitB)],...
        ['Raw Mean stream length: ', num2str(results.WBFG.avg_stream_length)],...
        ['Raw stream length stDev: ', num2str(results.WBFG.stream_length_stdev)],...
        ['Raw Identified Streams: ', num2str(sum(classification.index>0))],...
        ['Raw Identified Streams Proportion: ', num2str(sum(classification.index>0)/results.WBFG.stream_count)]},...
        'FontSize',14,...
        'FontName','Arial',...
        'LineStyle','--',...
        'EdgeColor',[1 1 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9  0.9 0.9],...
        'Color',[0.84 0.16 0]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

    %unused
    %['Avg stream Asym ratio: ', num2str(results.WBFG.avgAsymRat)],...
    %['stream Asym ratio stDev: ', num2str(results.WBFG.avgAsymRat)],...
    % ['Tracts Segmented: ', num2str(sum(length(rightNames)+length(interHemiNames)))],...

    %posBool=fe.life.fit.weights>0;

    % Plot comparing pre and post life streamline proportion by length
    subplot(3,4,2)
    hold on
    plot ((rangeSet),results.WBFG.lengthProps(rangeSet),'b', 'LineWidth',1.25)
    plot ((rangeSet),(results.WBFG.LogFitA*exp(results.WBFG.LogFitB*(rangeSet-10))),'c', 'LineWidth',1.25)
    %plot ((rangeSet),lognpdf(rangeSet,results.WBFG.LogFitA,results.WBFG.LogFitB),'c', 'LineWidth',1.25)

    title({'Normalized WBFG & NonZero Weighted',' Stream Count Comparison'})
    legend('WBFG','WBFG Fit')
    xlabel('Streamline Length (mm)')
    ylabel('Whole Brain proportion')

    %plot looking at cumulative fiber length proportions
    cumValid=zeros(1,length(results.WBFG.lengthProps));
    cumWBFG=cumValid;
    for ilengths=5:length(results.WBFG.lengthProps)
        cumWBFG(ilengths)=results.WBFG.lengthProps(ilengths)+sum(cumWBFG(ilengths-1));
    end

    subplot(3,4,3)
    hold on
    plot (((rangeSet)),cumWBFG((rangeSet)),'b', 'LineWidth',1.25)
    title({'Cumulative portion of fibers','in connectome, by length'})
    legend('WBFG')
    xlabel('Streamline Length (mm)')
    ylabel('Portion of tracts less than or equal to length')

    %% Seg Case -- Plots Specific to segmentation output

    %set values
    classBool=classification.index>0;
    [WBFGclassHist, ~]=histcounts(results.WBFG.lengthData(classBool),(1:300));

    % Plot comparing pre and post life classified streamline proportion by length
    subplot(3,4,4)
    hold on
    plot ((rangeSet),(WBFGclassHist(rangeSet)/results.WBFG.stream_count)*100,'b', 'LineWidth',1.25)
    title({'Classified Streamline Proportion','Comparison: WBFG & Surviving'})
    legend('WBFG, classified')
    xlabel('Streamline Length (mm)')
    ylabel('Proportion of Whole Brain Streamlines Classified (%)')



    %% computation for seg bar plots
    %count plot
    classificationGrouping = wma_classificationStrucGrouping_v2(classification);
    countPlotInput=zeros(2,(length(classificationGrouping.names)));
    volPlotInput=zeros(2,(length(classificationGrouping.names)));

    for itracts=1:length(classificationGrouping.names)
        fprintf('\n %s',classificationGrouping.names{itracts})
        tractIndexes=unique(classification.index(classificationGrouping.index==itracts));
        for iVariants=1:length(tractIndexes)
            countPlotInput(iVariants,itracts)=results.WBFG.tractStats{tractIndexes(iVariants)}.norms.countProp;
            volPlotInput(iVariants,itracts)=results.WBFG.tractStats{tractIndexes(iVariants)}.norms.volumeProp;
        end
    end

    bottomPlot1=subplot(3,4,[6 7 8]);
    hold on
    bar(100*countPlotInput')
    title({'log10 of proportion of connectome',' streamlines in tract'})
    legend('Left','Right')
    xlabel('Tract')
    ylabel('% classificaiton input streamlines in tract (%)')
    ylim([-0 max(max(countPlotInput))*133])
    set(gca,'xtick',[1:1:length(classificationGrouping.names)])
    set(gca,'XTickLabel',classificationGrouping.names, 'FontSize',8,'FontName','Times')
    bottomPlot1.XTickLabelRotation=-45;

    bottomPlot2=subplot(3,4,[10 11 12]);
    hold on
    bar((volPlotInput')*100)
    title({'Proportion of wm volume','occupied by tract'})
    legend('Left','Right')
    xlabel('Tract')
    ylabel('% wm volume proportion occupied by tract (%)')
    ylim([-0 max(max(volPlotInput))*133])
    set(gca,'xtick',[1:1:length(classificationGrouping.names)])
    set(gca,'XTickLabel',classificationGrouping.names, 'FontSize',8,'FontName','Times')
    bottomPlot2.XTickLabelRotation=-45;

    fig = gcf;
    fig.Position = [100 100 1600 1000];
    %% no classification no fe
elseif notDefined('fe') & notDefined('classification')
    %readout stats
    textBoxHandle=subplot(2,2,[1 3]);
    textBoxPos=get(textBoxHandle,'position');
    annotation('textbox',...
        [textBoxPos(1) textBoxPos(2) textBoxPos(3) textBoxPos(4)],...
        'String',{['Raw Stream Count: ', num2str(results.WBFG.stream_count)],...
        ['Total Stream Volume: ', num2str(results.WBFG.volume)],...
        ['Raw fit curve A: ', num2str(results.WBFG.LogFitA)],...
        ['Raw fit curve B: ', num2str(results.WBFG.LogFitB)],...
        ['Raw Mean stream length: ', num2str(results.WBFG.avg_stream_length)],...
        ['Raw stream length stDev: ', num2str(results.WBFG.stream_length_stdev)]},...
        'FontSize',14,...
        'FontName','Arial',...
        'LineStyle','--',...
        'EdgeColor',[1 1 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9  0.9 0.9],...
        'Color',[0.84 0.16 0]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

    %unused
    %['Avg stream Asym ratio: ', num2str(results.WBFG.avgAsymRat)],...
    %['stream Asym ratio stDev: ', num2str(results.WBFG.avgAsymRat)],...
    % ['Tracts Segmented: ', num2str(sum(length(rightNames)+length(interHemiNames)))],...

    %posBool=fe.life.fit.weights>0;

    % Plot comparing pre and post life streamline proportion by length
    subplot(2,2,2)
    hold on
    plot ((rangeSet),results.WBFG.lengthProps(rangeSet),'b', 'LineWidth',1.25)
    plot ((rangeSet),(results.WBFG.LogFitA*exp(results.WBFG.LogFitB*(rangeSet-10))),'c', 'LineWidth',1.25)
    %plot ((rangeSet),lognpdf(rangeSet,results.WBFG.LogFitA,results.WBFG.LogFitB),'c', 'LineWidth',1.25)

    title({'Normalized WBFG',' Stream Count Comparison'})
    legend('WBFG','WBFG Fit')
    xlabel('Streamline Length (mm)')
    ylabel('Whole Brain proportion')

    %plot looking at cumulative fiber length proportions
    cumValid=zeros(1,length(results.WBFG.lengthProps));
    cumWBFG=cumValid;
    for ilengths=5:length(results.WBFG.lengthProps)
        cumWBFG(ilengths)=results.WBFG.lengthProps(ilengths)+sum(cumWBFG(ilengths-1));
    end

    subplot(2,2,4)
    hold on
    plot (((rangeSet)),cumWBFG((rangeSet)),'b', 'LineWidth',1.25)
    title({'Cumulative portion of fibers','in connectome, by length'})
    legend('WBFG')
    xlabel('Streamline Length (mm)')
    ylabel('Portion of tracts less than or equal to length')

    fig = gcf;
    fig.Position = [100 100 1400 600];
end

%gets figure handle
figHandle=gcf;

if ~exist('image', 'dir')
    mkdir('image');
end
saveas(gcf,'image/image.svg');

if ~exist('tractmeasures', 'dir')
    mkdir('tractmeasures');
end
save('tractmeasures/tractomeResultStruc.mat','results')
%which('tractmeasures/tractomeResultStruc.mat')

%results.WBFG.tractStats
disp('creating resultSummary')

%making it outside conditional
if or(isfield(config,'output'),isfield(config,'classification'))
    for itracts=1:length(results.WBFG.tractStats)
        tableArray{itracts+1,1}=results.WBFG.tractStats{itracts}.name;
        tableArray{itracts+1,2}=results.WBFG.tractStats{itracts}.stream_count;
        tableArray{itracts+1,3}=results.WBFG.tractStats{itracts}.volume;
        tableArray{itracts+1,4}=results.WBFG.tractStats{itracts}.avg_stream_length;
        tableArray{itracts+1,5}=results.WBFG.tractStats{itracts}.stream_length_stdev;
        tableArray{itracts+1,6}=results.WBFG.tractStats{itracts}.avgFullDisp;
        tableArray{itracts+1,7}=results.WBFG.tractStats{itracts}.stDevFullDisp;
        tableArray{itracts+1,8}=nan;
        tableArray{itracts+1,9}=nan;
        tableArray{itracts+1,10}=results.WBFG.tractStats{itracts}.length_total;
        
        if ~isfield(results.WBFG.tractStats{itracts},'endpointDensity1')
            %endpointDensity1
            tableArray{itracts+1,11}=nan;
            %endpointDensity2
            tableArray{itracts+1,12}=nan;
            %avgEndpointDist1
            tableArray{itracts+1,13}=nan;
            %avgEndpointDist2
            tableArray{itracts+1,14}=nan;
            %stDevEndpointDist1
            tableArray{itracts+1,15}=nan;
            %stDevEndpointDist2
            tableArray{itracts+1,16}=nan;
            %midpointDensity
            tableArray{itracts+1,17}=nan;
            %avgMidpointDist
            tableArray{itracts+1,18}=nan;
            %stDevMidpointDist
            tableArray{itracts+1,19}=nan;
        else
            %endpointDensity1
            tableArray{itracts+1,11}=results.WBFG.tractStats{itracts}.endpointDensity1;
            %endpointDensity2
            tableArray{itracts+1,12}=results.WBFG.tractStats{itracts}.endpointDensity2;
            %avgEndpointDist1
            tableArray{itracts+1,13}=results.WBFG.tractStats{itracts}.avgEndpointDist1;
            %avgEndpointDist2
            tableArray{itracts+1,14}=results.WBFG.tractStats{itracts}.avgEndpointDist2;
            %stDevEndpointDist1
            tableArray{itracts+1,15}=results.WBFG.tractStats{itracts}.stDevEndpointDist1;
            %stDevEndpointDist2
            tableArray{itracts+1,16}=results.WBFG.tractStats{itracts}.stDevEndpointDist2;
            %midpointDensity
            tableArray{itracts+1,17}=results.WBFG.tractStats{itracts}.midpointDensity;
            %avgMidpointDist
            tableArray{itracts+1,18}=results.WBFG.tractStats{itracts}.avgMidpointDist;
            %stDevMidpointDist
            tableArray{itracts+1,19}=results.WBFG.tractStats{itracts}.stDevMidpointDist;
        end
        %norms.volumeProp
        tableArray{itracts+1,20}=results.WBFG.tractStats{itracts}.norms.volumeProp;
        %norms.countProp
        tableArray{itracts+1,21}=results.WBFG.tractStats{itracts}.norms.countProp;
        %norms.wireProp
        tableArray{itracts+1,22}=results.WBFG.tractStats{itracts}.norms.wireProp;
    end
    tableOut = cell2table(tableArray, 'VariableNames',fullFieldNames);

else
    warning('no input classification found')
end
if exist('tableOut','var')
    if ~exist('resultsSummary', 'dir')
        mkdir('resultsSummary')
    end
    writetable(tableOut,'resultsSummary/tractmeasures.csv');
end

disp('all done ------------------------------------------')

end
