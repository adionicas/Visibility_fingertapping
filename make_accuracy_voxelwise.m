function [] = make_accuracy_voxelwise(input_func_img, func_mask, TR, winACC, onsets_filename, output_filename_VGDS, output_filename_ACC)

nifti_img_this_run = load_nii(input_func_img{1})
nifti_img_this_run_data=nifti_img_this_run.img;

ntps = size(nifti_img_this_run_data,4);

mask=load_nii(func_mask{1});
mask_mat=mask.img;


    onsets = importdata(onsets_filename);
    onsets_TR = round(onsets/TR)';
    predictedpeakidx = onsets_TR+6/TR;

tic
for i = 1 : size(nifti_img_this_run_data,1)
for j = 1 : size(nifti_img_this_run_data,2)
for k = 1 : size(nifti_img_this_run_data,3)
if mask_mat(i,j,k)==1
degrees_this_run(i,j,k,:)=visibility2(nifti_img_this_run_data(i,j,k,:));

	k_vis= squeeze(degrees_this_run(i,j,k,:))';
	[~,idxVIS]=sort(k_vis,'descend');
	idxVIS=sort(idxVIS(1:length(onsets_TR)),'descend');
	accuracyVIS=zeros(1,length(predictedpeakidx));

		for t = 1:length(predictedpeakidx)
			accuracyVIS(t)=sum(predictedpeakidx(t)-winACC <= idxVIS & predictedpeakidx(t)+winACC >= idxVIS)>0;
		end
accuracy_this_run(i,j,k) = sum(accuracyVIS)/length(onsets_TR);
else degrees_this_run(i,j,k,1:ntps)=0; accuracy_this_run(i,j,k) = 0;
end % if statement
end; end; end % i j k

VGDS_nifti_output=nifti_img_this_run;
VGDS_nifti_output.img=degrees_this_run;
VGDS_nifti_output.hdr.dime.datatype=16;
VGDS_nifti_output.hdr.dime.bitpix=16;


ACC_nifti_output=mask;
ACC_nifti_output.img=accuracy_this_run;
ACC_nifti_output.hdr.dime.datatype=16;
ACC_nifti_output.hdr.dime.bitpix=16;

save_nii(VGDS_nifti_output,output_filename_VGDS{1})
save_nii(ACC_nifti_output,output_filename_ACC{1})

toc
