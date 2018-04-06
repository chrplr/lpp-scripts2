# 
# Note: This Makefile is not clever, i.e. it  does not know about dependencies
# Time-stamp: <2018-04-06 13:38:32 cp983411>

SHELL := /bin/bash

export PATH := bin:$(PATH)


# DO NOT EDIT THIS PART (unless you know what you are doing)
# set the environment variables in the shell before calling `make`
export MODEL ?= murielle-topdown-bottom
export LINGUA ?= en
export MODEL_DIR ?= models/$(LINGUA)/$(MODEL)
export REGS ?=  bottomup f0 freq rms mwe wordrate
export ROOT_DIR ?= /volatile/Le_Petit_Prince
export SUBJECTS_FMRI_DATA ?= $(ROOT_DIR)/fmri-data/$(LINGUA)
export ONSETS_DIR ?= onsets/$(LINGUA)
export HRF_DIR ?= $(ROOT_DIR)/scripts-python/hrf-regressors/$(LINGUA)
export DESIGN_MATRICES_DIR = $(ROOT_DIR)/scripts-python/models/$(LINGUA)/$(MODEL)/design-matrices
export FIRSTLEVEL_RESULTS ?= $(ROOT_DIR)/results-indiv/$(LINGUA)/$(MODEL)
export GROUP_RESULTS ?= $(ROOT_DIR)/results-group/$(LINGUA)/$(MODEL)
export ROI_RESULTS=$(ROOT_DIR)/results-group/$(LINGUA)/$(MODEL)-roi

hrfs:
	mkdir -p $(HRF_DIR)
	generate-hrfs $(ONSETS_DIR) $(HRF_DIR)

design-matrices:
	mkdir -p $(DESIGN_MATRICES_DIR)
	python merge-regressors -i $(HRF_DIR) -o $(DESIGN_MATRICES_DIR) $(REGS)
	if [ -f $(MODEL_DIR)/orthonormalize.py ]; then \
		echo 'Orthogonalizing...'; \
		python $(MODEL_DIR)/orthonormalize.py \
			--design_matrices=$(DESIGN_MATRICES_DIR) \
			--output_dir=$(DESIGN_MATRICES_DIR); \
	fi

first-level:
	mkdir -p $(FIRSTLEVEL_RESULTS)
	python $(MODEL_DIR)/firstlevel.py \
		--subject_fmri_data=$(SUBJECTS_FMRI_DATA) \
		--design_matrices=$(DESIGN_MATRICES_DIR) \
		--output_dir=$(FIRSTLEVEL_RESULTS)

second-level:
	mkdir -p $(GROUP_RESULTS)
	python $(MODEL_DIR)/group.py \
		--data_dir=${FIRSTLEVEL_RESULTS} \
		--output_dir=$(GROUP_RESULTS) 

roi-analyses:
	python lpp-rois.py --data_dir=${FIRSTLEVEL_RESULTS} --output=$(MODEL)-rois.csv


check-correlations.html: check-correlations.Rmd 
	#cp -f check-correlations.Rmd $(DESIGN_MATRICES_DIR)
	Rscript -e "setwd('$(DESIGN_MATRICES_DIR)'); rmarkdown::render('check-correlations.Rmd', output_format='html_document')" 

check-correlations.pdf: check-correlations.Rmd
	#cp -f check-correlations.Rmd $(DESIGN_MATRICES_DIR)
	Rscript -e "setwd('$(DESIGN_MATRICES_DIR)'); rmarkdown::render('check-correlations.Rmd', output_format='pdf_document')" 
