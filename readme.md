All voxelwise functions depend on Tools for NIfTI and ANALYZE image: 
https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

Some functions also depend on Brain Connectivity Toolbox: https://sites.google.com/site/bctnet/

make_accuracy_voxelwise.m generates an accuracy map based on input event files (3d nifti image), plus the degree sequence (another 4d nifti image).

make_visib_degree_voxelwise.m generates only the degree sequence (does not require an events file)

get_VG_density_voxelwise.m calculates the VG density in each voxel (3d nifti output)

func_V1_BOLD5000.m takes as input .txt time-series form a region (e.g., V1) and corresponding event files, and calculates peristimulus map of the original signal and VG and accuracy.
