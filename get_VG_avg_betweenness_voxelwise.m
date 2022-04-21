function [] = get_VG_avg_betweenness_voxelwise(input, mask, output)

% function [] = get_VG_density_voxelwise('input.nii.gz', '')
mask=load_nii(mask);
mask_mat=mask.img;

nifti_img_this_run = load_nii(input)
nifti_img_this_run_data=nifti_img_this_run.img;
% degrees_this_run=zeros(size(nifti_img_this_run_data,1),size(nifti_img_this_run_data,2),size(nifti_img_this_run_data,3),size(nifti_img_this_run_data,4));
tic
for i = 1 : size(nifti_img_this_run_data,1)
for j = 1 : size(nifti_img_this_run_data,2)
for k = 1 : size(nifti_img_this_run_data,3)
if mask_mat(i,j,k)==1
ADJ_fMRI = Visibility(double(squeeze(nifti_img_this_run_data(i,j,k,:))),2);
density_this_run(i,j,k)= median(betweenness_bin(ADJ_fMRI));
else density_this_run(i,j,k,1)=0;
end % if statement
end; end; end % i j k
newmat=mask;
newmat.img=density_this_run;
%newmat.hdr.dime.dim(1)=4;
%newmat.hdr.dime.dim(5)=size(density_this_run,4);
newmat.hdr.dime.datatype=16;
newmat.hdr.dime.bitpix=16;
toc

save_nii(newmat,output{1})
