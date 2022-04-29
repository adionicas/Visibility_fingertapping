Generate synthetic signal across noise levels:

```matlab
noise_std_vals=[0.100 0.125 0.175 0.200 0.225 0.250 0.275 0.300 0.325 0.350 0.375 0.400 0.425 0.450 0.475 0.500 0.525 0.550 0.575 0.600 0.625 0.650 0.675 0.700 0.725 0.750 0.775 0.800 0.825 0.850 0.875 0.900 0.925 0.950 0.975 1]

for z=1:length(noise_std_vals)

nperm=1000; % Number of iterations for measuring accuracy values 
tlength=20; 

dograph='no'; % Change this to yes if you want figures....beware of the for loop for assessing significance

t = 1:1:tlength; % Tps per HRF
h = gampdf(t,7); % GAM NB: 6 is the peak . Update, modified after bc with the val 6, the actual peak is 5 s post onset
h = h/max(h); % scale to 1
timepoints=4000;

boldtimeseries=zeros(1,timepoints);
onset=tlength:40:timepoints-(tlength*2); % onset timepoints

    for l = 1:length(onset)
        
        boldtimeseries(onset(l):onset(l)+length(t)-1)=h; % put hrf in timeseries...ugly as shit
        
    end

AccuracyValuesVIS=nan(1,nperm);
AccuracyValuesfMRI=nan(1,nperm);

for p = 1:nperm
    
    noise = noise_std_vals(z).*randn(1,timepoints); % Gaussian noise, second parameter is the std of noise... increase to make timeseries noisier
    %noise = 1 + (-1-1).*rand(1,timepoints); % Uniformly distributed noise
    
    fMRI=boldtimeseries+noise; % fMRI is signal + a lot of noise
    
    
    [NN,k]=visibility(fMRI); % Compute visibility

% calc correclations between noise and fMRI and K


    noise_k_corr(z,p)=corr(k, noise','type','kendall');
    noise_fMRI_corr(z,p)=corr(fMRI',noise','type','kendall');
    
    
    
    peristimulusBOLD=zeros(length(onset),length(t)); % Allocate peristimulus
    peristimulusfMRI=zeros(length(onset),length(t));
    peristimulusVIS=zeros(length(onset),length(t));
    
    for l = 1:length(onset)
        
        
        peristimulusBOLD(l,:)=boldtimeseries(onset(l):onset(l)+length(t)-1); %Fill peristimulus
        peristimulusfMRI(l,:)=fMRI(onset(l):onset(l)+length(t)-1);
        peristimulusVIS(l,:)=k(onset(l):onset(l)+length(t)-1);
        
    end
    
    
    
    predictedpeakidx=sort(find(boldtimeseries==max(boldtimeseries)),'descend');
    [~,idxVIS]=sort(k,'descend');
    idxVIS=sort(idxVIS(1:length(onset)),'descend');
    
    [~,idxfMRI]=sort(fMRI,'descend');
    idxfMRI=sort(idxfMRI(1:length(onset)),'descend');
    
    
    accuracyVIS=zeros(1,length(predictedpeakidx));
    accuracyfMRI=zeros(1,length(predictedpeakidx));
    
    winACC=6; % Accuracy on window
    
    for i = 1:length(predictedpeakidx)
        
        accuracyVIS(i)=sum(predictedpeakidx(i)-(winACC/2) <= idxVIS & predictedpeakidx(i)+(winACC/2) >= idxVIS)>0;
        accuracyfMRI(i)=sum(predictedpeakidx(i)-(winACC/2) <= idxfMRI & predictedpeakidx(i)+(winACC/2) >= idxfMRI)>0;
        
    end
    
    if strcmpi(dograph,'yes')
        
        fprintf('Accuracy for Visibility is: %.2f\n', sum(accuracyVIS)/length(onset));
        fprintf('Accuracy for fMRI is: %.2f\n', sum(accuracyfMRI)/length(onset));
    end
    
    AccuracyValuesVIS(p)=sum(accuracyVIS)/length(onset);
    AccuracyValuesfMRI(p)=sum(accuracyfMRI)/length(onset);
    
end


All_accuracy_vis(z,:)=AccuracyValuesVIS;
All_accuracy_fMRI(z,:)=AccuracyValuesfMRI;

end


All_accuracy_vis_mean=mean(All_accuracy_vis,2);
All_accuracy_fMRI_mean=mean(All_accuracy_fMRI,2);

```
