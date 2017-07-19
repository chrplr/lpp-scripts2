# 
# Note: This Makefile is not clever, i.e. it  does not know about dependencies
# Time-stamp: <2017-07-19 22:39:36 cp983411>

export MODEL ?= model01

export ROOT_DIR ?= /volatile/Le_Petit_Prince/

export SUBJECTS_FMRI_DATA ?= $(ROOT_DIR)/lpp-data

export DESIGN_MATRICES_DIR ?= $(ROOT_DIR)/lpp-results/$(MODEL)-design-matrices

export FIRSTLEVEL_RESULTS ?= $(ROOT_DIR)/lpp-results/$(MODEL)-indiv

export GROUP_RESULTS ?= $(ROOT_DIR)/lpp-results/$(MODEL)-group

export ROI_RESULTS=$(ROOT_DIR)/lpp-results/$(MODEL)-roi

hrfs:
	$(MAKE) -C create-hrfs

design-matrices:
	$(MAKE) -C create-design-matrices-$(MODEL)
	mkdir -p $(DESIGN_MATRICES_DIR)
	python $(MODEL)-orthonormalize.py \
		--design_matrices=create-design-matrices-$(MODEL) \
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
