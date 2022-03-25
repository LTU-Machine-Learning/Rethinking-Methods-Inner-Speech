# Rethinking-Methods-Inner-Speech

This repository contains codes for paper titled as 'Rethinking the Methods and Algorithms for Inner Speech
Decoding - and Making them Reproducible'. 

The code is divided into following chunks: Preprocessing, training, and testing. The folder details are as follows

## Preprocessing

This folder contains, files and functions which were used during the preprocessing of both vowel and words. Here, folders 
which having processed data with and without downsanling have also been shared.
Folder; 'picard_master' shared to run ICA.

## Training_and_functions

This folder contains the training scripts for both vowel and words. Dependent functions have also been shared in the same folder.

## Testing_TrainedModels

This folder contains testing script along with trained models.


### Note
The comments are available in the script to follow the process. The script contains; data parameters, CNN parameters, 
CNN architecture, data split, reshape, and CNN training options and training.

Link for raw data: http://fich.unl.edu.ar/sinc/downloads/imagined_speech/

The original dataset used in this work can be found in [1]. 
The proposed architeture used in this study is based on [2].

## Citing this work

Please cite this work.
```bibtex
    @article {Simistira Liwicki2022.03.22.485286,
	author = {Simistira Liwicki, Foteini and Gupta, Vibha and Saini, Rajkumar and De, Kanjar and Liwicki, Marcus},
	title = {Rethinking the Methods and Algorithms for Inner Speech Decoding - and Making them Reproducible},
	elocation-id = {2022.03.22.485286},
	year = {2022},
	doi = {10.1101/2022.03.22.485286},
	publisher = {Cold Spring Harbor Laboratory},
	URL = {https://www.biorxiv.org/content/early/2022/03/23/2022.03.22.485286},
	eprint = {https://www.biorxiv.org/content/early/2022/03/23/2022.03.22.485286.full.pdf},
	journal = {bioRxiv}
    }

```

## References
[1] Coretto, Germán A. Pressel, Iván E. Gareis, and H. Leonardo Rufiner. "Open access database of EEG signals recorded during imagined speech." 12th International Symposium on Medical Information Processing and Analysis. Vol. 10160. International Society for Optics and Photonics, 2017.

[2] Cooney, C., Folli, R. and Coyle, D., 2019, October. Optimizing layers improves CNN generalization and transfer learning for imagined speech decoding from EEG. In 2019 IEEE international conference on systems, man and cybernetics (SMC) (pp. 1311-1316). IEEE. 
