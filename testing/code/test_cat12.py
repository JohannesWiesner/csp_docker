import nipype.interfaces.spm as spm
from nipype.interfaces.cat12 import CAT12SANLMDenoising
from nipype.interfaces.cat12 import CAT12Segment
from nipype import Node

# would be nice if we wouldn't have to do this. See:
# https://github.com/ReproNim/neurodocker/issues/518
matlab_cmd = '/opt/CAT12-r1933_R2017b/run_spm12.sh /opt/MCR-2017b/v93/ script'
spm.SPMCommand.set_mlab_paths(matlab_cmd=matlab_cmd, use_mcr=True)

# test CAT12 denoising
cat12_denoising = Node(CAT12SANLMDenoising(),name='cat12_denoising')
cat12_denoising.base_dir = '/home/csp/cache'
cat12_denoising.inputs.in_files = '/home/csp/data/anatomical.nii'
cat12_denoising.outputs.out_file = '/home/csp/output/anatomical_cat12_denoised.nii'
cat12_denoising.run()

# FIXME: This still takes too long, we just want to test if everything works,
# so configure this to a MRE
# test CAT12 segmentation (don't run surface workflow, as this takes too long)
# cat12_segmentation = Node(CAT12Segment(),name='cat12_segmentation')
# cat12_segmentation.inputs.surface_and_thickness_estimation = 0
# cat12_segmentation.inputs.in_files = '/home/csp/data/anatomical.nii'
# cat12_segmentation.run()
