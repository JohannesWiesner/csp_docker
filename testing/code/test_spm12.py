from nipype.interfaces.spm import Smooth
smooth = Smooth()
smooth.inputs.in_files = '/data/functional.nii'
smooth.inputs.fwhm = 6
smooth.run()
