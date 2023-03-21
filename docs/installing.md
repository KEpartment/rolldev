# Installing RollDev
======

## Prerequisites

* [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac) 2.2.0.0 or later or [Docker for Linux](https://docs.docker.com/install/) or [Docker for Windows](https://docs.docker.com/desktop/windows/install/)
* `docker-compose` version 2.0 or later is required (this can be installed via `brew`, `apt`, `dnf`, or `pip3` as needed)
* [Mutagen](https://mutagen.io/) 0.11.4 or later is required for environments leveraging sync sessions on Mac OS. RollDev will attempt to install this via `brew` if not present.

:::{warning}
**By default Docker Desktop for Mac allocates 2GB memory.**

This leads to extensive swapping, killed processed and extremely high CPU usage during some Magento actions, like for example running sampledata:deploy and/or installing the application. It is recommended to assign at least 6GB RAM to Docker Desktop prior to deploying any Magento environments on Docker Desktop.

This can be corrected via Preferences -> Resources -> Advanced -> Memory. While you are there, it wouldn't hurt to let Docker have the use of a few more vCPUs (keep it at least 4 less than the maximum CPU allocation however to avoid having macOS contend with Docker for use of cores)
:::

## Installing via Homebrew

RollDev may be installed via [Homebrew](https://brew.sh/) on both macOS and Linux hosts:

    brew install dockergiant/roll/roll
    roll svc up

### Updating via Homebrew

RollDev is updated like other [Homebrew](https://brew.sh/) software by running brew upgrade:

    brew upgrade dockergiant/roll/roll
    roll svc restart

## Alternative (Manual) Installation

RollDev may be installed by cloning the repository to the directory of your choice and adding it to your `$PATH`. This method of installation may be when Homebrew does not already exist on your system or when preparing contributions to the RollDev project.

    sudo mkdir /opt/den
    sudo chown $(whoami) /opt/den
    git clone -b main https://github.com/dockergiant/rolldev.git /opt/den
    echo 'export PATH="/opt/den/bin:$PATH"' >> ~/.bashrc
    PATH="/opt/den/bin:$PATH"
    roll svc up

### Updating Alternative (Manual) Installations

To update RollDev just pull the latest changes from git, or check out a specific release tag. You'll also want to rebuild your dashboard image to reflect the latest changes (if any).

    cd /opt/den
    git fetch --tags
    git pull
    # git switch <tag>
    roll svc build --no-cache --build-arg ROLL_VERSION=$(cat version | tr -d '\n' | sed -e 's/^[[:space:]]*//g; s/[[:space:]]*$//g') dashboard
    roll svc ps --status=running -q dashboard >/dev/null 2>&1 && roll svc restart dashboard
    roll svc up

## Windows Installation (via WSL2)

Install and enable [WSL2 in Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10).  
Install Ubuntu 20.04 or other compatible Linux version from the Windows store or [manually download distibutions](https://docs.microsoft.com/en-us/windows/wsl/install-manual).   
Launch Docker for Windows, make sure that the option for WSL2 integration is set.  
Launch wsl from your terminal of choice.  

    wsl
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install dockergiant/roll/roll
    roll svc up

In order for DNS entries to be resolved either add them to your Windows hosts file or add 127.0.0.1 as the first DNS server in your current network adapter in Windows.

:::{warning}
**For performance reasons code should be located in the WSL Linux home path or other WSL local path ~/code/projectname NOT the default /mnt/c path mapping.**
:::

GUI tools for Windows should use the network paths provided by WSL2: `\\wsl$\Ubuntu-20.04\home\<USER>\<PROJECTPATH>`.

## Next Steps

### Automatic DNS Resolution

On Linux environments, you will need to configure your DNS to resolve `*.test` to `127.0.0.1` or use `/etc/hosts` entries. On Mac OS this configuration is automatic via the BSD per-TLD resolver configuration found at `/etc/resolver/test`. On Windows manual configuration of the network adapter DNS server is required.


For more information see the configuration page for [Automatic DNS Resolution](configuration/dns-resolver.md)

### Trusted CA Root Certificate

In order to sign SSL certificates that may be trusted by a developer workstation, RollDev uses a CA root certificate with CN equal to `RollDev Proxy Local CA (<hostname>)` where `<hostname>` is the hostname of the machine the certificate was generated on at the time RollDev was first installed. The CA root can be found at `~/.roll/ssl/rootca/certs/ca.cert.pem`.

On MacOS this root CA certificate is automatically added to a users trust settings as can be seen by searching for 'RollDev Proxy Local CA' in the Keychain application. This should result in the certificates signed by RollDev being trusted by Safari and Chrome automatically. If you use Firefox, you will need to add this CA root to trust settings specific to the Firefox browser per the below.

On Ubuntu/Debian this CA root is copied into `/usr/local/share/ca-certificates` and on Fedora/CentOS (Enterprise Linux) it is copied into `/etc/pki/ca-trust/source/anchors` and then the trust bundle is updated appropriately. For new systems, this typically is all that is needed for the CA root to be trusted on the default Firefox browser, but it may not be trusted by Chrome or Firefox automatically should the browsers have already been launched prior to the installation of RollDev (browsers on Linux may and do cache CA bundles)

:::{note}
If you are using **Firefox** and it warns you the SSL certificate is invalid/untrusted, go to Preferences -> Privacy & Security -> View Certificates (bottom of page) -> Authorities -> Import and select ``~/.roll/ssl/rootca/certs/ca.cert.pem`` for import, then reload the page.

If you are using **Chrome** on **Linux** and it warns you the SSL certificate is invalid/untrusted, go to Chrome Settings -> Privacy And Security -> Manage Certificates (see more) -> Authorities -> Import and select ``~/.roll/ssl/rootca/certs/ca.cert.pem`` for import, then reload the page.
:::
