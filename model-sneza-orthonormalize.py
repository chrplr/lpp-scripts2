#! /usr//bin/env python
# Time-stamp: <2018-03-07 11:08:39 cp983411>


""" read the design matrices dmt_*.csv and perform a sequential orthogonalization of the variables """

import sys
import getopt
import os
import glob
import os.path as op
import numpy as np
import numpy.linalg as npl
from numpy import (corrcoef, around, array, dot, identity, mean)
from numpy import column_stack as cbind
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


def ortho_proj(Y, M):
    """ returns the orthogonal component of Y to the space spanned by M and the constant vector 1 """
    if M.ndim == 1:   # M is a vector but needs to be a 2-D matrix
        M = M[:, np.newaxis]
    I = np.ones(len(M))
    I = I[:, np.newaxis]
    M2 = np.hstack((I, M))  # adding the constant 
    betas,_,_,_ = npl.lstsq(M2, Y)
    Xc = np.dot(M2, betas)  # colinear component "residuals"
    Xo = Y - Xc
    return Xo


def main():
    data_dir = '.'
    output_dir = '.'
    
    # parse command line to change default
    try:
        opts, args = getopt.getopt(sys.argv[1:],
                                   "d:o:",
                                   ["design_matrices=", "output_dir="])
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)
    for o, a in opts:
        if o in ('-d', '--design_matrices'):
            data_dir = a
        elif o in ('-o', '--output_dir'):
            output_dir = a

    filter = op.join(data_dir, 'dmtx_?.csv')
    dfiles = glob.glob(filter)
    if len(dfiles) == 0:
        print("Cannot find files "+ filter)
        sys.exit(2)
        
    if not op.isdir(output_dir):
        os.mkdir(output_dir)
        
    for r, f in enumerate(dfiles):
        print("Run #%d:" % r)
        df = pd.read_csv(f)
        M1 = df.as_matrix().T
        print(around(corrcoef(M1), 2))

        display = sns.pairplot(df)
        fn, ext = op.splitext(op.basename(f))
        display.savefig(op.join(output_dir, fn + '_nonortho.png'))
    
        X1 = df.d001 - mean(df.d001)
        X2 = ortho_proj(df.d002, df.d001)
        X3 = ortho_proj(df.d003, cbind((df.d001, df.d002)))
        X4 = ortho_proj(df.d004, cbind((df.d001, df.d002, df.d003)))
        X5 = ortho_proj(df.d005, cbind((df.d001, df.d002, df.d003)))

        M2 = cbind((X1, X2, X3, X4, X5))
        newdf = pd.DataFrame(data=M2,
                             columns=['d001', 'd002', 'd003', 'd004', 'd005'])
        fname, ext  = op.splitext(op.basename(f))
        newfname = op.join(output_dir, fname + '_ortho' + ext)
        newdf.to_csv(newfname, index=False)
        display = sns.pairplot(newdf)
        display.savefig(op.join(output_dir, fn + '_ortho.png'))

        print(around(corrcoef(M2.T), 2))
        plt.close('all')
    

if __name__ == '__main__':
    None
