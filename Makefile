# 
# Note: This Makefile is not clever, i.e. it  does not know about dependencies
# Time-stamp: <2017-07-20 16:23:14 cp983411>

SHELL := /bin/bash

export PATH := bin:$(PATH)

export MODEL ?= model01
export REGS ?=  bottomup f0 freq rms mwe wordrate
export ROOT_DIR ?= /volatile/Le_Petit_Prince
export SUBJECTS_FMRI_DATA ?= $(ROOT_DIR)/lpp-data
export ONSETS_DIR ?= onsets
export HRF_DIR ?= $(ROOT_DIR)/lpp-results/hrfs
export DESIGN_MATRICES_DIR ?= $(ROOT_DIR)/lpp-results/$(MODEL)-design-matrices
export FIRSTLEVEL_RESULTS ?= $(ROOT_DIR)/lpp-results/$(MODEL)-indiv
export GROUP_RESULTS ?= $(ROOT_DIR)/lpp-results/$(MODEL)-group
export ROI_RESULTS=$(ROOT_DIR)/lpp-results/$(MODEL)-roi

hrfs:
	mkdir -p $(HRF_DIR)
	generate-hrfs $(ONSETS_DIR) $(HRF_DIR)

design-matrices:
	mkdir -p $(DESIGN_MATRICES_DIR)
	python merge-regressors -i $(HRF_DIR) -o $(DESIGN_MATRICES_DIR) $(REGS)
	python $(MODEL)-orthonormalize.py \
		--design_matrices=$(DESIGN_MATRICES_DIR) \
		--output_dir=$(DESIGN_MATRICES_DIR)

first-level:
	mkdir -p $(FIRSTLEVEL_RESULTS)
	python $(MODEL)-firstlevel.py \
		--subject_fmri_data=$(SUBJECTS_FMRI_DATA) \
		--design_matrices=$(DESIGN_MATRICES_DIR) \
		--output_dir=$(FIRSTLEVEL_RESULTS)

second-level:
	mkdir -p $(GROUP_RESULTS)
	python $(MODEL)-group.py \
		--data_dir=${FIRSTLEVEL_RESULTS} \
		--output_dir=$(GROUP_RESULTS) 

roi-analyses:
	python lpp-rois.py --data_dir=${FIRSTLEVEL_RESULTS} --output=$(MODEL)-rois.csv


check-correlations.html: check-correlations.Rmd 
	cp -f check-correlations.Rmd $(DESIGN_MATRICES_DIR)
	Rscript -e "setwd('$(DESIGN_MATRICES_DIR)'); rmarkdown::render('check-correlations.Rmd', output_format='html_document')" 

check-correlations.pdf: check-correlations.Rmd
	cp -f check-correlations.Rmd $(DESIGN_MATRICES_DIR)
	Rscript -e "setwd('$(DESIGN_MATRICES_DIR)'); rmarkdown::render('check-correlations.Rmd', output_format='pdf_document')" 
