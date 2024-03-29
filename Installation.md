Instruction for installing & running ns2 in WSL2 (Windows Subsystem for Linux) on Windows 10 or (Windows 11)

## Update WSL2
we need to update WSL2 to the latest version. To do this, open PowerShell as Administrator and run the following command:
```powershell
wsl --set-default-version 2
```
Now update wsl
```powershell
wsl --update
```

## Install Ubuntu on WSL2
Open Microsoft Store and search for Ubuntu 20.4 (later releases don't work). Install it.


## Install ns2 in Ubuntu
Open Ubuntu and run the following commands:

Update package list
```bash
sudo apt-get update
```

Install ns2 and its dependencies
```bash
sudo apt-get install ns2 nam tcl -y
```

### Install xgraph 
Open Ubuntu Terminal,
Download xgraph package,
```
wget https://xgraph.org/linux/xgraph_4.38_linux64.tar.gz 
```
(if this doesn't work try manually downloading from [link](https://xgraph.org/linux/xgraph_4.38_linux64.tar.gz))

Extract it
```
tar xvfz xgraph_4.38.tar.gz
```
Make alias for easy access
```
alias xgraph=/home/bart/XGraph/bin/xgraph
```
(or put it in bin/ directory)

Done!



Verify installation of each component
### Run ns2
To run ns2, open Ubuntu and run the following command:
```bash
ns
```

### Run nam
To run nam, open Ubuntu and run the following command:
```bash
nam
```

### Run tcl
To run tcl, open Ubuntu and run the following command:
```bash
tclsh
```

### Run xgraph
To run xgraph, open Ubuntu and run the following command:
```bash
xgraph
```

## VSCode integration
To integrate ns2 with VSCode, install the following extensions:
- WSL (ms-vscode-remote.remote-wsl)
- TCL (mads-hartmann.tcl)

Now open VSCode and  open (or create) the folder containing ns2 files. 
Then open the command palette (Ctrl+Shift+P) and run the command 

> "WSL: Reopen Folder in WSL". 

This will open the project with WSL Ubuntu. 

## Run ns2 in VSCode
To run tcl file say `ex.tcl` , open Ubuntu and run the following command:
```bash
ns ex.tcl
```

If everything is installed correctly, you should see the expected output.

## Troubleshooting
## Xgraph not found
### Error: `libgtk2.0-0` not found

`apt-get install libgtk2.0-0`

## Nam
Make sure you are using right version of ubuntu
verify by following cmd in terminal
```
lsb_release -a
```
Output should be
```
Description:    Ubuntu 20.04 LTS
Release:        20.04
Codename:       focal
```

### General
Make sure wsl is upto-date 