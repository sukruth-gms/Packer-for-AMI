# packer puglin for AWS 
# https://www.packer.io/plugins/builders/amazon 
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

# which ami to use as the base and where to save it
source "amazon-ebs" "amazon-linux" {
  region          = "us-east-1"
  ami_name        = "ami-version-1.0.1-{{timestamp}}"
  instance_type   = "t2.micro"
  source_ami      = "ami-0c101f26f147fa7fd"
  ssh_username    = "ec2-user"
  #ami_users       = ["AWS Account ID"]
  ami_regions     = [
                      "us-east-1"
                    ]
}
# what to install, configure and file to copy/execute

build {
  name = "hq-packer"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]
  
  provisioner "ansible" {
  playbook_file = "provisioner-ansible.yaml"
  }

  provisioner "shell" {
    inline = [ "ls -la /tmp"]
  }
  
  provisioner "shell" {
    inline = [ "pwd"]
  }
  
  provisioner "shell" {
    inline = [ "cat /tmp/provisioner-ansible.yaml"]
  }
}
