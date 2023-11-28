# MR Optimum


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
## Create a Json Options file

```
python -m mroptimum.generate -d 2 -s pmr -r sense -o /g/as.json
```
## Run an snr calculation
```
python -m mroptimum.snr -j /g/as.json -o /g/_MR/ -c True -g True -v True -m True
```

## Generate and, if you want run
```
python -m mroptimum.generate-ui -j /g/mytest/ -r True
```

## IDS

### Image Reconstructions
- 0 RSS
- 1 B1
- 2 SENSE
- 3 GRAPPA

### SNR Reconstructions
- 0 Analytical
- 1 Multiple Replicas
- 2 Pseudo Multiple Replicas
- 3 Pseudo Multiple Replicas Wien


### Output
- 0 SNR
- 1 Noise Covariance Matrix
- 2 Noise Coefficient Matrix
- 4 G Factor
- >=10 Coil Sensitivities Maps 


# Roadmap
- v1.2:
    - ismrmrd
- [] v1:
    - [x] matlab save
    - [x] coilsens out
    - [x] generate-gui
    - [x] multislice
    - [x] single slice evaluation

# Cite Us

- Montin E, Lattanzi R. Seeking a Widely Adoptable Practical Standard to Estimate Signal-to-Noise Ratio in Magnetic Resonance Imaging for Multiple-Coil Reconstructions. J Magn Reson Imaging. 2021 Dec;54(6):1952-1964. doi: 10.1002/jmri.27816. Epub 2021 Jul 4. PMID: 34219312; PMCID: PMC8633048.


[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**
