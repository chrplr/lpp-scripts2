Script to analyze fMRI data of the Little Prince project 
--------------------------------------------------------

Christophe@pallier.org


Before anything, set the ROOT_DIR of the project, for example:

    . setroot-garvin

To perform an analysis, select or create a model in `models`, for example:

    . setmodel models/en/chrmodels/en/christophe-bottomup/

Then, you can execute the analysis step by step, following the stages in the Makefile
	
	make hrfs
	make design-matrices
	make first-level
	make second-level
	make roi-analyses


To check the regressors relationships:

	make check-design-matrices

To create a new model:

1. create a sub directory in `models` containing a `setenv` file exporting the environment variables specifing the model name, the list of regressors, etc. (see modesl/en/christophe-bottomup/setenv fro an example)

2. In your model's directory, create `firstlevel.py` and optionnaly, `orthonormalize.py` which will be executed by `make first-level`.
Create also `group.py` for the siecond level.


3. If your model includes variables that have not yet been used in previous models, tyou need to add to the folder ` onsets`  one comma separated (.csv) file per variable and per run --- the filename pattern being `X_VARNAME.csv` where X is the run number [1-9]. Each file must contain two columns named 'onset' and 'amplitude' (onsets is given in seconds). 


Requirements:

- Python: pandas, nistats, nibabel, nilearn
- R: car, rmarkdown (only for make check-design-matrices)
