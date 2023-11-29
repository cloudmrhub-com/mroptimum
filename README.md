# MR Optimum



# Cite Us

Montin E, Lattanzi R. Seeking a Widely Adoptable Practical Standard to Estimate Signal-to-Noise Ratio in Magnetic Resonance Imaging for Multiple-Coil Reconstructions. J Magn Reson Imaging. 2021 Dec;54(6):1952-1964. doi: 10.1002/jmri.27816. Epub 2021 Jul 4. PMID: 34219312; PMCID: PMC8633048.

# Installation
```
pip install git+https://github.com/cloudmrhub-com/mroptimum.git

```

# Suggestions
```
#create an environment 
python3 -m venv MRO
source MRO/bin/activate
pip install git+https://github.com/cloudmrhub-com/mroptimum.git
```
# Example


## Run an snr calculation
```
python -m mroptimum.snr -j /g/as.json -o /g/_MR/ -c True -g True -v True -m True
```

# Json configuraiton file
```json
{
    {
    "version": "v0",
    "acquisition": 2,
    "type": "SNR",
    "id": 2,
    "name": "PMR",
    "options": {
        "NR":20,
        "reconstructor": {
            "type": "recon",
            "name": "GRAPPA",
            "id": 4,
            "options": {
                "noise": {
                    "type": "file",
                    "options": {
                        "type": "local",
                        "filename": "/data/PROJECTS/mroptimum/_data/noise.dat",
                        "options": {},
                        "multiraid": false,
                        "vendor": "Siemens"
                    }
                },
                "signal": {
                    "type": "file",
                    "options": {
                        "type": "local",
                        "filename": "/data/PROJECTS/mroptimum/_data/signal.dat",
                        "options": {},
                        "multiraid": false,
                        "vendor": "Siemens"
                    }
                },
                "sensitivityMap": {
                    
                    }
                },
                "decimate": true,
                "accelerations": [
                    1,
                    2
                ],
                "acl": [
                    20,
                    20
                ],
                
                "kernelSize" : [4,4]
            }
        }
    }
}

}
```


## Create a Json Options file

```
python -m mroptimum.generate -d 2 -s pmr -r sense -o /g/as.json
```
a collection of json customization file can be found [here](https://github.com/cloudmrhub-com/mroptimum/tree/main/mroptimum/collections)


## IDS

### Image Reconstructions
| ID | Reconstruction Name |
|---|---|
| 0 | RSS|
|1 | B1|
|2| SENSE|
| 3 | GRAPPA |


### SNR Reconstructions
| ID | SNR Methods |
|---|---|
| 0 | Analytical (AC)|
|1 | Multiple Replicas (MR)|
|2| Pseudo Multiple Replicas (PMR)|
| 3 | Pseudo Multiple Replicas Wien (CR) |


### Output
| ID | Name |
|---|---|
|0 | SNR|
| 1 | Noise Covariance Matrix|
| 2 | Noise Coefficient Matrix|
| 3 | Inverse G Factor|
| 4 | G Factor|
| >=10 |Coil Sensitivities Maps |



# Roadmap
- v1.2:
    - ismrmrd
- [] v1:
    - [x] matlab save
    - [x] coilsens out
    - [x] generate-gui
    - [x] multislice
    - [x] single slice evaluation




[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**
