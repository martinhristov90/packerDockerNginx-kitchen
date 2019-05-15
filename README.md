# How to create a Docker image which provides Nginx server by using Packer and test it with KitchenCI.

# Purpose:

This repository's sole purpose is to demonstrate how to built a Docker image using Packer which provides Nginx webserver and test it with KitchenCI afterwards.

# Technologies in use :

- Packer
- Vagrant
- VirtualBox
- Nginx
- Docker
- KitchenCI
- Inspec

# How to install the pre-requisites:

- [How to install Vagrant](https://www.vagrantup.com/docs/installation/)
- [How to install VirtualBox](https://www.virtualbox.org/manual/ch02.html)

# How to use:

- Clone this git repository using `git clone https://github.com/martinhristov90/packerDockerNginx `
- Switch into the directory of the project using : `cd packerDockerNginx`
- Now you should have a copy of the project, run `vagrant up` to build the VM in which Packer and Docker are going to run.
- When the VM is running, ssh to it with `vagrant ssh`
- Change into the building directory with `cd ~/buildDir`
- Run `packer build template.json`, which is going to output Docker image with Nginx installed, also it is going to be imported to Docker automatically. To verify that the image is imported run `docker images`, the output should look like this : 

```

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
martin              0.1                 b87d812ae4d5        14 hours ago        200MB
ubuntu              xenial              a3551444fc85        2 weeks ago         119MB

```

# How to test that Nginx is installed with KitchenCI:

- Kitchen should be installed automatically by the script `kitchenSetup.sh` during the execution of `vagrant up` command.
- Verify that Docker image that it is going to be tested is available with `docker images`.
- KitchenCI is going to executed the tests by the instructions provided in `kitchen.yml` file.
- Run `bundle exec kitchen list`, to verify that kitchen recognizes the `kitchen.yml` file and that the testing envirenoment is not setup yet. The output should looks like this :

```

Instance        Driver  Provisioner  Verifier  Transport  Last Action    
default-ubuntu  Docker  Shell        Inspec    Ssh        <Not Created>  

```

- Now, the Packer image that was produced can be tested, if it has `Nginx` installed, run: `sudo bundler exec kitchen coverge` to create the testing environment for KitchenCI and then `sudo bundler exec kitchen test` for the actual testing, the output should look like this : 
```

Profile: tests from {:path=>"/home/vagrant/buildDir/test/integration/default"} (tests from {:path=>".home.vagrant.buildDir.test.integration.default"})
Version: (not specified)
Target:  ssh://kitchen@localhost:32769

  System Package nginx
     ✔  should be installed

Test Summary: 1 successful, 0 failures, 0 skipped

```

## NB : The section 
```
        "changes": [
          "ENTRYPOINT [\"\"]"
        ]
```
## Needs to be added because Packer overrides the default entrypoint of the ubuntu image with empty one.
