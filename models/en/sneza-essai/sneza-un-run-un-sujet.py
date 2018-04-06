# EXamples of single-subject/single run fMRI data analyses

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import nistats
from nistats.first_level_model import FirstLevelModel
from nistats.reporting import plot_design_matrix
from nilearn.plotting import plot_stat_map
from nilearn.plotting import plot_glass_brain

# First example: analysis of continuous speech processing, with precomputed design matrix

# specify data
#imgs = '../english-fmri-data/all.nii.gz'
imgs = '../english-fmri-data/57/analysis/all.nii.gz/all.nii' 

# load precomputed design matrix
dtx_mat = pd.read_csv('../lpp-results/model-sneza-design-matrices/dmtx_all.csv', delimiter=',')

# create the linear model and estimate it

fmri_glm = FirstLevelModel(
            t_r = 2.0,
            hrf_model = 'spm',
            # mask='mask_ICV.nii',
            noise_model = 'ar1',
            period_cut = 128.0,
            smoothing_fwhm = 0,
            minimize_memory = True,
            # memory='/mnt/ephemeral/cache',
            memory = None,
            verbose = 2,
            n_jobs = 1)

fmri_glm = fmri_glm.fit(imgs, design_matrices=dtx_mat)

#display the design matrix
from nistats.reporting import plot_design_matrix
plot_design_matrix(fmri_glm.design_matrices_[0])
plt.show()

# display the zmap for each regressor 

nreg = dtx_mat.shape[1]  # number of regressors
for i, name in enumerate(dtx_mat.columns):
        con = np.zeros(nreg)  # zeros everywhere
        con[i] = 1  # except in the relevant column

        z_map = fmri_glm.compute_contrast(con, output_type='z_score')
        eff_map = fmri_glm.compute_contrast(con, output_type='effect_size')
        #nib.save(z_map, op.join(outputpath, '%s_%s_zmap.nii.gz' % (name, subjid)))
        #nib.save(eff_map, op.join(outputpath, '%s_%s_effsize.nii.gz'% (name, subjid)))
        #display = None
        display = plot_glass_brain(z_map, 
                                   display_mode = 'lzry', 
                                   threshold = 3.1, 
                                   colorbar = True, 
                                   title = name)
        plt.show()
        #display.savefig(op.join(outputpath, '%s_%s_glassbrain.png' % (name, subjid)))
        #display.close()




