Script to analyze fMRI data of the Little Prince project 
--------------------------------------------------------

Christophe@pallier.org

Everything is the Makefile. READ it! 


For example, to run on garvin

	. setenv-garvin
	
	make hrfs
	make design-matrices
	make first-level
	make second-level
	make roi-analyses


To check the regressors relationships:

	make check-design-matrices

To create a new model:


1. add to the folder ` onsets`  one comma separated (.csv) file per variable and per run, containing two columns names 'onset' and 'amplitude'. (onsets is given in seconds). The filename pattern is `X_VARNAME.csv` where X is the run numbner [1-9]

2. create a ` setenv*` file exporting the environment variables specifing the model name, the list of regressors, etc. (check the top of the Makefile for the list of variables; but please do not edit the Makefile itself!).

3. if your model is, say, `mymodel` , create ` mymodel-first-level.py`  and ` mymodel-orthonormalize.py` which will be executed by `make first-level`.


Requirements:

- Python: pandas, nistats, nibabel, nilearn
- R: car, rmarkdown (only for make check-design-matrices)
