function [deg] = func_V1_BOLD5000(stim_event_filenames, TS_V1_filenames_sub, denoising_file_suffix)


runs=importdata(stim_event_filenames);

for rs = 1 : length(runs);
filename_to_import=[runs(rs) + "_onsets_vect.txt"];
EV(:,rs)=importdata(filename_to_import);
EV2TR(:,rs)=round(EV(:,rs)/2);
end



runs_TS=importdata(TS_V1_filenames_sub);

for rs = 1 : length(runs_TS);
filename_to_import=[runs_TS(rs) + denoising_file_suffix];
TS_denoised(:,rs)=importdata(filename_to_import);
% added here
TS_denoised(:,rs)=zscale(TS_denoised(:,rs),1,0);
end

for rs = 1 : length(runs);
K_visibility(:,rs)=visibility2(TS_denoised(:,rs));
% added here
K_visibility(:,rs)=zscale(K_visibility(:,rs),1,0);
end

onset=transpose(EV2TR(:,1))
predictedpeakidx = onset+3




for z = 1 : length(EV2TR)
k=transpose(K_visibility(:,z));
fMRI=transpose(TS_denoised(:,z));

[~,idxVIS]=sort(k,'descend');
idxVIS=sort(idxVIS(1:length(onset)),'descend');

[~,idxfMRI]=sort(fMRI,'descend');
idxfMRI=sort(idxfMRI(1:length(onset)),'descend');


accuracyVIS=zeros(1,length(predictedpeakidx));
accuracyfMRI=zeros(1,length(predictedpeakidx));
    
winACC=2; % Accuracy on window

for i = 1:length(predictedpeakidx)
        
        accuracyVIS(i)=sum(predictedpeakidx(i)-winACC <= idxVIS & predictedpeakidx(i)+winACC >= idxVIS)>0;
        accuracyfMRI(i)=sum(predictedpeakidx(i)-winACC <= idxfMRI & predictedpeakidx(i)+winACC >= idxfMRI)>0;
        
end

AccuracyValuesVIS(z)=sum(accuracyVIS)/length(onset);
AccuracyValuesfMRI(z)=sum(accuracyfMRI)/length(onset);

end


%figure;
%histogram(AccuracyValuesVIS)
%title("+/- 2 TP")
%hold on
%histogram(AccuracyValuesfMRI)
%hold off

data = [AccuracyValuesfMRI',AccuracyValuesVIS'];
x = 1:2;
colors = [0.4 0.3 0.6; 0.4660 0.6740 0.1880]

boxplot(data, x, 'symbol', '', 'Widths',0.8);
ylim([0.3 1])
ylabel('Accuracy', 'FontSize',12, 'FontWeight','bold')

h = findobj(gca,'Tag','Box');
%set(findobj('Tag','Box'),'LineWidth',3)
bx = findobj('Tag','boxplot');
set(bx.Children,'LineWidth',2);
set(gca,'XTickLabel',{'fMRI TS','VG Degree'}, 'fontsize', 12,'FontWeight','bold')
%'Ytick',[0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
set(h,'Color',[0 0 0]); pbaspect([1 1 0.6])

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.8);

end
outfilename_fig=[stim_event_filenames + "boxplot.jpg"]
box off
saveas(gca,outfilename_fig)


% make peristim plot

count = 0;
A=TS_denoised';
B=K_visibility';
for k = 1 : size(A,1)
for l = 1:length(onset)
count = count + 1;
        peristimulusfMRI(count,:)=A(k,onset(l)+1:onset(l)+7);
        peristimulusVIS(count,:)=B(k,onset(l)+1:onset(l)+7);
end; end

figure;
        subplot(1,2,1)
        %plot(peristimulusfMRI','LineWidth',0.5,'color',[0.4660 0.6740 0.1880])
        hold on
	xtickVals = [1, 2, 3, 4, 5, 6, 7];
	xtickLabs = [0, 2, 4, 6, 8, 10, 12];
%	xtickangle(-45)
        errorbar(mean(peristimulusfMRI,1),std(peristimulusfMRI,0,1)./(sqrt(length(onset)-1)),'LineWidth',3,'color',[0.7, 0.7, 0.7]);
	set(gca,'xtick', xtickVals, 'xticklabel', xtickLabs,'YTick',[], 'fontsize',12.5,'fontweight','bold',  'xlim', [0.7,7.3], 'ylim', [0.375,0.61]);
	plot(mean(peristimulusfMRI,1),'LineWidth',3,'Marker','.','MarkerSize',25,'color',[0.4660 0.6740 0.1880])
	pbaspect([1 1.75 1])
        hold off
       subplot(1,2,2)
        %plot(peristimulusfMRI','LineWidth',0.5,'color',[0.4660 0.6740 0.1880])
        hold on
	xtickVals = [1, 2, 3, 4, 5, 6, 7];
	xtickLabs = [0, 2, 4, 6, 8, 10, 12];
%	xtickangle(-45)
        errorbar(mean(peristimulusVIS,1),std(peristimulusVIS,0,1)./(sqrt(length(onset)-1)),'LineWidth',3,'color',[0.7, 0.7, 0.7]);
	set(gca,'xtick', xtickVals, 'xticklabel', xtickLabs,'YTick',[], 'fontsize',12.5,'fontweight','bold',  'xlim', [0.7,7.3],'ylim', [0.11,0.26]);
        plot(mean(peristimulusVIS,1),'LineWidth',3,'Marker','.','MarkerSize',25,'color',[0.4 0.3 0.6])
	pbaspect([1 1.75 1])

%        hold off
%        
%        subplot(1,2,2)
%        %plot(peristimulusVIS','LineWidth',0.5,'color',[0.4 0.3 0.6])
%        hold on
%        errorbar(mean(peristimulusVIS,1),std(peristimulusVIS,0,1)./(sqrt(length(onset)-1)),'LineWidth',3,'color',[0.7, 0.7, 0.7]);
%	set(gca,'XTick',[3 6 9 12 16 20],'YTick',[], 'fontsize',12.5,'fontweight','bold');
%        plot(mean(peristimulusVIS,1),'LineWidth',3,'Marker','.','MarkerSize',25,'color',[0.4 0.3 0.6])
%        hold off
