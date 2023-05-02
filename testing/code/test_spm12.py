from nipype.interfaces.spm import Smooth
smooth = Smooth()
smooth.inputs.in_files = '/home/csp/data/single_files/functional.nii'
smooth.inputs.fwhm = 6
smooth.run()
