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
python -m mroptimum.generateJson.py -d 2 -s pmr -r sense -o /g/as.json
```
## Run an snr calculation
```
python -m mroptimum.parsnrv1 -j /g/as.json -o /g/_MR/ -c True -g True -v True -m rue
```
# Roadmap
- v1.2:
    - ismrmrd
- v1:
    - multislice
    - single slice evaluation

# Cite Us

- Montin E, Lattanzi R. Seeking a Widely Adoptable Practical Standard to Estimate Signal-to-Noise Ratio in Magnetic Resonance Imaging for Multiple-Coil Reconstructions. J Magn Reson Imaging. 2021 Dec;54(6):1952-1964. doi: 10.1002/jmri.27816. Epub 2021 Jul 4. PMID: 34219312; PMCID: PMC8633048.


[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**
