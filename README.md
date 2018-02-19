Script to analyze fMRI data from the Little Prince project 
----------------------------------------------------------

Christophe@pallier.org

Everything is the Makefile. READ it! 

For example, to run on garvin

	. setenv-garvin
	
	make hrfs
	make design-matrices
	make first-level
	make second-level
	make roi-analyses


To create a new model:
- create a setenv* file exporting the relevant environement variables, specify the data location, the regressors, ... (see the top of the Makefile for the list of variables; but do not edit the Makefile!)
- if your model is, say, 'mymodel', create mymodel-first-level.py and mymodel-orthonormalize.py




Requirements:

- Python: pandas, nistats, nibabel, nilearn
- R: car, rmarkdown (only for make check-design-matrices)
