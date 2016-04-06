## Getting started

### Pre-requirements

1. Virtualbox, Vagrant, ansible

    If you are on a mac, you can install virtualbox and vagrant using homebrew
    Also, install ansible using pip on a mac

    ```shell
    brew cask install virtualbox vagrant
    pip install ansible
    ```

2. Setup the VMs

    Make sure you have deleted an existing ./.vagrant directory in the project's directory

    ```shell
    vagrant up
    ```

3. Build the VM's one by one or all at a time

    The password for connecting to Vagrant VM's is vagrant by default.
    The VM's need your github credentials to be able to pull certain repos.
    The scripts require your ssh keys for github to be present in a certain directory.

    Available VM's are
    - dnsmasq1.dev
    - consulserver1.dev
    - consulserver2.dev
    - consulserver3.dev
    - mysqldb1.dev
    - postgresdb1.dev
    - nginx1.dev
    - rails1.dev

    Setup the paths for the required ssh keys like so
    ```shell
    [ -d ~/.ssh/github ] || mkdir ~/.ssh/github/
    [ -f ~/.ssh/github/id_rsa ] || cp ~/.ssh/id_rsa ~/.ssh/github/id_rsa
    [ -f ~/.ssh/github/id_rsa.pub ] || cp ~/.ssh/id_rsa ~/.ssh/github/id_rsa.pub
    ```

    Run the bootstrap script to setup the VM's like so.
    The botstrap sets up the user and ssh credentials for the VM too.
    ```shell
    ./bin/provision-hosts.sh -b -l <VM hostname or hostnames separated by spaces>
    ```

    For subsequent updates of the VM avoid bootstrapping it.
    ```shell
    ./bin/provision-hosts.sh -l <VM hostname or hostnames separated by spaces>
    ```
