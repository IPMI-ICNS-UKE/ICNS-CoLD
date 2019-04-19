# ICNS-CoLD
**CoLD: Cortical Layer Discrimination**

This repository contains the Matlab code associated to our manuscript *Discrimination of the hierarchical structure of cortical layers in 2-photon microscopy data by combined unsupervised and supervised machine learning*, which has been accepted for publication in *Scientific Reports*. Until final publication, please find the manuscript via bioRxiv and cite the respective document:

```
@article {Li427955,
	author = "Li, Dong and Zavaglia, Melissa and Wang, Guangyu and Hu, Yi and Xie, Hong and Werner, Rene and Guan, Ji-Song and Hilgetag, Claus C.",
	title = "Discrimination of the hierarchical structure of cortical layers in 2-photon microscopy data by combined unsupervised and supervised machine learning",
	elocation-id = "427955",
	year = "2018",
	doi = "10.1101/427955",
	publisher = "Cold Spring Harbor Laboratory",
  	URL = "https://www.biorxiv.org/content/early/2018/09/26/427955",
	eprint = "https://www.biorxiv.org/content/early/2018/09/26/427955.full.pdf",
	journal = "bioRxiv"
}
```

Example data can be downloaded here: 

[Download link for CoLD example data](https://icns-nas1.uke.uni-hamburg.de/owncloud/index.php/s/VPHhQk6WSmgoe2b)

In case of usage of our code or data, we expect the above publication to be cited.

## Requirements
The code has been tested with Matlab R2017a on Windows 10. 
<!---  XXX on Ubuntu 16.04 LTS The following Matlab XXX packages are required (lower versions may also be sufficient):
- numpy>=1.14.5
- keras>=2.2.0
- tensorflow-gpu>=1.9.0
- SimpleITK>=1.1.0
- h5py>=2.8.0 --->

## Basic Usage

- Download the example data (see above link). 
- Add subroutine folders (see below) to your Matlab environment.
- Run respective scripts.
- Send us a message in case of problems.

The folder **./discrimination** contains the scripts to reproduce cortical layer. The main is script is the **Discrimination_Main_Code.m** file. The subfolder **./discrimination/subroutine_discrimination** has to be integrated into the Matlab environment. 

The folders **./evaluationclustering** and **./evaluationsupervisedlearning** contain the scripts to evaluate the unsupervised clustering and supervised learning results, respectively.

