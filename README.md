Script to analyze fMRI data from the Little Prince project 
----------------------------------------------------------

Christophe@pallier.org

Everything is the Makefile. 

For example, to run on garvin

	. setenv-garvin
	
	make hrfs
	make design-matrices
	make first-level
	make second-level
	make roi-analyses

Note: you can change the environments variables to control to location of files (check the Makefile)


Requirements:

- Python: pandas, nistats, nibabel, nilearn
- R: car, rmarkdown (only for make check-design-matrices)
