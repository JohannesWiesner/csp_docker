from nipype.interfaces import cat12
c = cat12.CAT12SANLMDenoising()
c.inputs.in_files = '/data/anatomical.nii'
c.run()
