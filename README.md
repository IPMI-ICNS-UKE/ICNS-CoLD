# ICNS-CoLD
**CoLD: Cortical Layer Discrimination**

This repository contains the Matlab code and example data associated to our manuscript *Discrimination of the hierarchical structure of cortical layers in 2-photon microscopy data by combined unsupervised and supervised machine learning*, published in *Scientific Reports*:

```
@article{Li2019,
	author = {Li, Dong and Zavaglia, Melissa and Wang, Guangyu and Hu, Yi and Xie, Hong and Werner, Rene and Guan, Ji-Song and Hilgetag, Claus C.},
	title = {Discrimination of the hierarchical structure of cortical layers in 2-photon microscopy data by combined unsupervised and supervised machine learning},
	journal = {{S}cientific {R}eports},
	year = {2018},
	volume = {9},
	number = {1},
	pages = {7424},
	doi = {10.1038/s41598-019-43432-y},
  	URL = {https://doi.org/10.1038/s41598-019-43432-y}
}
```

In case of usage of our code or data, we expect the above publication to be cited.

## Requirements
The code has been tested with Matlab R2017a on Windows 10. 
<!---  XXX on Ubuntu 16.04 LTS The following Matlab XXX packages are required (lower versions may also be sufficient):
- numpy>=1.14.5
- keras>=2.2.0
- tensorflow-gpu>=1.9.0
- SimpleITK>=1.1.0
- h5py>=2.8.0 --->

The image data are further made available using [git-lfs](https://git-lfs.github.com/).  
Before cloning the repository, please ensure that you installed git-lfs.

## Basic Usage

- Download the example data (see above link). 
- Add subroutine folders (see below) to your Matlab environment.
- Run respective scripts.
- Send us a message in case of problems.

The folder **./discrimination** contains the scripts to reproduce cortical layer. The main is script is the **Discrimination_Main_Code.m** file. The subfolder **./discrimination/subroutine_discrimination** has to be integrated into the Matlab environment. 

The folders **./evaluationclustering** and **./evaluationsupervisedlearning** contain the scripts to evaluate the unsupervised clustering and supervised learning results, respectively.

The folder **./exampledata** contains example image data: the raw data and preprocessed data using the vignetting correction approach described [here](https://www.frontiersin.org/articles/10.3389/fninf.2021.674439/full); cf. the corresponding [github repository](https://github.com/IPMI-ICNS-UKE/VignettingCorrection). 
