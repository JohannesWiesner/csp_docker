import nipype.interfaces.spm as spm
from nipype.interfaces.cat12 import CAT12SANLMDenoising
from nipype import Node

matlab_cmd = '/opt/CAT12-r1933_R2017b/run_spm12.sh /opt/MCR-2017b/v93/ script'
spm.SPMCommand.set_mlab_paths(matlab_cmd=matlab_cmd, use_mcr=True)

# create node and run
cat12_denoiser = Node(CAT12SANLMDenoising(),name='cat12_denoising')
cat12_denoiser.inputs.in_files = '/home/csp/data/anatomical.nii'
cat12_denoiser.outputs.out_file = '/home/csp/output/anatomical_cat12_denoised.nii'
cat12_denoiser.run()
