# Run `packer build packer.pkr.hcl` to bake ami ->
# inject ami into main.tf

# TODO: move the packer build command into terraform, then pass variables in on the CLI
# https://stackoverflow.com/a/58066912

source "amazon-ebs" "ami" {
  #ami_name = "${var.prefix}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  ami_name = "brendanbeckcom-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  instance_type = "t2.micro"
  profile       = "default"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ami"]

  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }

  provisioner "shell" {
    inline = ["mkdir /tmp/src"]
  }

  provisioner "file" {
    destination = "/tmp"
    source      = "../src"
  }

  # TODO: change this to script, and use same sh as in packer-test directory
  provisioner "shell" {
    inline = ["mv /tmp/src ~"]
  }

  #post-processor "manifest" {
  #  output = "output.json"
  #}
}
