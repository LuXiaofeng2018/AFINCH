function AFPlotQmMeaEst(iy)
%%
% Plot Monthly Measured and Estimated Flows
%
% global iy
WY = WY + 1;
QEstAdjInciy = reshape([AFstruct.(HSR)(iy,StaHist(iy).StaNdx).QEstAdjInc]',12,[])';
QMeaAdjInciy = reshape([AFstruct.(HSR)(iy,StaHist(iy).StaNdx).QMeaAdjInc]',13,[])';
% 
if ~exist('SRho','var')
    SRho = zeros(Ny,12);
end
%
figure(20);
clf(20);
set(gcf,'NumberTitle','Off','Name',...
    ['Relation between the measured and estimated monthly adjusted ',...
    'incremental flows for WY ',int2str(WY)]);
for im=1:12,
    subplot(4,3,im);
    NdxGT0 = find(QMeaAdjInciy(:,im)>=0 & QEstAdjInciy(:,im)>=0);
    if length(QMeaAdjInciy(:,im))-length(NdxGT0)>0
        fprintf(1,['For WY= %u, iy= %u, and im= %u there are %u ',...
            'positive indices and %u negative indices.\n'],...
            WY,iy,im,length(NdxGT0),length(QMeaAdjInciy(:,im))-length(NdxGT0));
    end
    plot(sqrt(QMeaAdjInciy(NdxGT0,im)),sqrt(QEstAdjInciy(NdxGT0,im)),'rx');
    if im<4
       title([MonthName{im},' ',num2str(WY-1)]);
    else
       title([MonthName{im},' ',num2str(WY  )]);
    end
    SRho(iy,im) = corr(QMeaAdjInciy(NdxGT0,im),QEstAdjInciy(NdxGT0,im),...
        'type','Spearman');
    YLim = get(gca,'YLim'); YLoLim = YLim(1)+.10*(YLim(2)-YLim(1));
    XLim = get(gca,'XLim'); XUpLim = XLim(2)-.22*(XLim(2)-XLim(1));
    line([XLim(1)+1 XLim(2)-1],[XLim(1)+1 XLim(2)-1],'Color','k');
    text(XUpLim*.95,YLoLim*1.05,['r_S^{2}= ',...
        num2str(SRho(iy,im)^2,'%6.4f')],'FontSize',8,'Color','r');
    if ismember(im,7)
        ylabel({'SQUARE ROOT OF ESTIMATED FLOW, IN CUBIC FEET PER SECOND'});
    end
    if ismember(im,[10,11,12])
        xlabel({'SQUARE ROOT OF MEASURED','FLOW, IN CUBIC FEET PER SECOND'});
    end
end
