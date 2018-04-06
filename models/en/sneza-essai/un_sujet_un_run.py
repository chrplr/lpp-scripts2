import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import nistats
from nistats.first_level_model import FirstLevelModel
from nistats.reporting import plot_design_matrix
from nilearn.plotting import plot_stat_map
from nilearn.plotting import plot_glass_brain

imgs = '/neurospin/unicog/protocols/IRMf/LePetitPrince_Pallier_2018/MRI/english-fmri-data/all.nii.gz'
dtx_mat = pd.read_csv('/neurospin/unicog/protocols/IRMf/LePetitPrince_Pallier_2018/MRI//lpp-results/model-sneza-design-matrices/dmtx_all.csv', delimiter=',')
dtx_mat.shape

fmri_glm = FirstLevelModel(
            t_r = 2.0,
            hrf_model = 'spm',
            # mask='mask_ICV.nii',
            noise_model = 'ols', # ar1
            period_cut = 128.0,
            smoothing_fwhm = 0,
            minimize_memory = True,
            memory='/volatile/nistats-cache',
            #memory = None,
            verbose = 2,
            n_jobs = -1)

fmri_glm = fmri_glm.fit(imgs, design_matrices=dtx_mat)

from nistats.reporting import plot_design_matrix
plot_design_matrix(fmri_glm.design_matrices_[0])
plt.show()

nreg = dtx_mat.shape[1]  # number of regressors
nn=np.eye(nreg)[0:300, :]  # F test on  the first 300 regressors
z_map=fmri_glm.compute_contrast(nn, stat_type='F', output_type='z_score')

