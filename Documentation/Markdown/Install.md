## Installation

### See also

[Overview](LoopScalla.md).


### Downloading the code

To set up LoopScalla you first need to obtain the latest snapshot from the official git repository

```
git clone https://github.com/FeynCalc/LoopScalla.git LoopScalla
```

You will also need FeynCalc and FeynHelpers

```
cd LoopScalla/External
git clone https://github.com/FeynCalc/feyncalc.git
git clone https://github.com/FeynCalc/feynhelpers.git
cd ..
ln -s External/feyncalc/FeynCalc FeynCalc
ln -s External/feynhelpers FeynCalc/AddOns/FeynHelpers
```

### Compiling the binaries

To run LoopScalla you need at least [FORM](https://github.com/form-dev/form) and [QGRAF](http://cefema-gt.tecnico.ulisboa.pt/~paulo/qgraf.html). Please follow the instructions for compiling those tools from source provided by their developers.

Once you are done with compiling, put `qgraf` and `tform` binaries to `LoopScalla/Binaries`

### Installing packages

LoopScalla also uses several open source tool. These are

 - [Graphviz](https://graphviz.org)
 - [GNU parallel](https://www.gnu.org/software/parallel/)
 - [pdfunite](https://github.com/mtgrosser/pdfunite)
 - [rsync](https://rsync.samba.org/)
 - [psrecord](https://github.com/astrofrog/psrecord)

On Ubuntu Linux you can install those via

```
sudo apt-get install parallel graphviz  poppler-utils rsync
pip install psrecord
```

### Configuring the environment

LoopScalla code calls various external tools such FORM, QGRAF, FIRE etc. Since every system is different, the framework uses one central file (`environment.sh`) to specify locations of those programs.

In addition to that, it also contains some hardware dependent parameters such as number of cores or threads to be used when running a particular
software.

The values from `environment.sh` are used by almost every LoopScalla script, so it is very important that the file is properly configured.

To that aim we provide a template `env-sample.sh` that contains detailed explanations of each variable. We recommend to create you environment.sh by starting with

```
cp env-sample.sh environment.sh
```

and then adjusting all variables in `environment.sh` accordingly.

If you plan to run LoopScalla on a cluster, you can also create a separate environment file for that and call it `env-cluster.sh`. You can then symlink `env-cluster.sh` to `environment.sh` on the cluster, while symlinking `env-local.sh` to `environment.sh` on your local machine. The synchronization script `lsclSync.sh` is designed to ignore `environment.sh` so that your configurations on different machines will not be overwritten.

