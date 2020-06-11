# CSFA_wrapper
wrapper for a [CSFA fork](https://github.com/yuichi-takeuchi/CSFA)

!this repository is not stable yet

## steps
1. lfppreps_Takeuchi3_dual_Template.m: extract LFP and down to 200 Hz
2. electomes_extractLFP1.m: extract LFP mat files
3. electomes_cutData1: choose channels, cut data to small windows
4. electomes_xFft1.m: change to xFft format
5. electomes_initCvFiles1.m: to get K-fold test sets
6. electomes_conncatenateData1.m
7. electomes_trainCSFA_supervised1.m : train to get a trained model and electome factor;
8. electomes_projectCSFA1.m: prepare CSF scores from xFft
9. electomes_plotCSFA1: plot trigle matrix;
10. Thresholding of auto-correlogram and closs-correlogram
11. Circular drawing
