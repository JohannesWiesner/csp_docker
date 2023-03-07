from nipype.interfaces.cat12 import CAT12SANLMDenoising
c = CAT12SANLMDenoising()
c.inputs.in_files = '/home/csp/data/anatomical.nii'
c.run()
