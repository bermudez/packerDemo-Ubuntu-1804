# packer-templates-for-cvp-ubuntu
##############
# Github repo:  https://github.com/bermudez/packerDemo-Ubuntu-1804.git
##############
#
#  About this repo:  Uses HashiCorp's Packer tool to create Ubuntu machine image(s).
#      The machine images can be a standard Ubuntu instance (no stack), or
#      with as a LAMP stack, or a LEMP stack.
#
#  This tool will create VM image files (.ovf and .vmdk).
#  This tool will also create a vagrant box file (.box).
#  
#  You can also import the VM image files to AWS and create a custom AMI (Amazon Machine Image).
#    (Note that AWS can import only certain variants of Linux, like Ubuntu 14.04 LTS)
#
#  See .json and script files for details on what is included in each kind of machine image.
#
##############


[Packer](https://www.packer.io/) templates for [Vagrant](https://www.vagrantup.com/) base boxes

## Usage

Clone the repository:

    $ git clone https://github.com/bermudez/packerDemo-Ubuntu-1804.git

Build a machine image from the template in the repository:

    $ packer build --force ubuntu1804.json

Add the built box to Vagrant:

    $ cd output && vagrant box add ubuntu-18.04.2 ubuntu-18.04.2.box

## Configuration

You can configure each template to match your requirements by setting the following [user variables](https://packer.io/docs/templates/user-variables.html).

 User Variable       | Default Value | Description
---------------------|---------------|----------------------------------------------------------------------------------------
 `compression_level` | 6             | [Documentation](https://packer.io/docs/post-processors/vagrant.html#compression_level)
 `cpus`              | 1             | Number of CPUs
 `disk_size`         | 40000         | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#disk_size)
 `headless`          | 0             | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#headless)
 `memory`            | 512           | Memory size in MB
 `mirror`            |               | A URL of the mirror where the ISO image is available

### Example

Build an uncompressed Ubuntu Linux vagrant box with a 4GB hard disk using the VirtualBox provider:

    $ packer build -only=virtualbox-iso -var compression_level=0 -var disk_size=4000 ubuntu-14.04-amd64-LEMP.json

## Pre-built Boxes

You can also use the pre-built boxes hosted on [Atlas](https://atlas.hashicorp.com/kaorimatz).

    $ vagrant box add kaorimatz/archlinux-x86_64

