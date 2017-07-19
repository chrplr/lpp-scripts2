Script to analyze fMRI data from the Little Prince project 
----------------------------------------------------------

Christophe@pallier.org

Everything is the Makefile. 

Use shell environment variables to control it.
For example, to run on garvin

	export MODEL=model01
	export ROOT_DIR=/home/jth99/lpp
	export SUBJECTS_FMRI_DATA=/home/jth99/lpp
	
	make hrf
	make design-matrices
	make first-level
	make second-level
	make roi-analyses



