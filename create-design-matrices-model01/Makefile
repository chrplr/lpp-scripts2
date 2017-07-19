# Time-stamp: <2017-07-19 22:25:59 cp983411>

all: dmtx check-correlations.html check-correlations.pdf

HRF=../create-hrf/outputs/

dmtx: # paste the regressors to generate the design matrices
	for s in 1 2 3 4 5 6 7 8 9; do \
	echo '"bottomup","f0","freq","rms","mwe","wordrate"' > dmtx_$${s}.csv; \
	paste -d, $(HRF)$${s}_bottomup_reg.csv  \
                  $(HRF)$${s}_f0_reg.csv  \
                  $(HRF)$${s}_freq_reg.csv \
                  $(HRF)$${s}_rms_reg.csv \
                  $(HRF)$${s}_mwe_reg.csv \
                  $(HRF)$${s}_wordrate_reg.csv >> dmtx_$${s}.csv; \
	done


check-correlations.html: check-correlations.Rmd dmtx_1.csv 
	Rscript -e "rmarkdown::render('check-correlations.Rmd', output_format='html_document')" 

check-correlations.pdf: check-correlations.Rmd dmtx_1.csv 
	Rscript -e "rmarkdown::render('check-correlations.Rmd', output_format='pdf_document')" 


clean:
	rm *csv *png
