function make_visib_degree_voxelwise(func_mask,sub_id,ses_id,denoised_nifti_list)

%filenames_all_sessions_events=importdata('stim_events_filenames_sub-CSI1_ses_all.txt')
mask=load_nii(func_mask);
% If this gives an error, comment the line below and uncomment the line above
% mask=load_untouch_nii(func_mask);
mask_mat=mask.img;

ses = ses_id
nitfti_filenames_all_runs_this_ses=importdata(denoised_nifti_list);
%events_filenames_all_runs_this_ses=importdata([filenames_all_sessions_events(ses) + ".txt"]);
for run = 1 : size(nitfti_filenames_all_runs_this_ses,1)
% !!! here i might need to replace with load_untouch_nii
nifti_img_this_run=load_nii(nitfti_filenames_all_runs_this_ses{run});
nifti_img_this_run_data=nifti_img_this_run.img;
degrees_this_run=zeros(size(nifti_img_this_run_data,1),size(nifti_img_this_run_data,2),size(nifti_img_this_run_data,3),size(nifti_img_this_run_data,4));
la_situazione=["Doing run " + run "of ses " + ses]
tic
for i = 1 : size(nifti_img_this_run_data,1)
for j = 1 : size(nifti_img_this_run_data,2)
for k = 1 : size(nifti_img_this_run_data,3)
if mask_mat(i,j,k)==1
degrees_this_run(i,j,k,:)=visibility2(nifti_img_this_run_data(i,j,k,:));
end % if statement
end; end; end % i j k
newmat=nifti_img_this_run;
newmat.img=degrees_this_run;
newmat.hdr.dime.datatype=16;
newmat.hdr.dime.bitpix=16;

if ses < 10
s="0" + ses;
else s=ses;
end % if statement

if run < 10
r="0" + run;
else r=run;
end % if statement

output_filename=["sub-" + sub_id + "-ses" + s + "_run-" + r + "_visibility_degree.nii.gz"]
save_nii(newmat,output_filename{1})
toc
end %run
