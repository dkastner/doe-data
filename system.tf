# These get set via environment variables, e.g.:
# export TF_VAR_aws_access_key=foo
variable "aws_access_key" { }
variable "aws_secret_key" { }
variable "aws_ssh_key_name" { }
variable "data_git_url" { }

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

# Network access rules for our new instance
resource "aws_vpc" "eia" {
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "eia" {
  vpc_id = "${aws_vpc.eia.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "eia" {
  vpc_id = "${aws_vpc.eia.id}"
}
resource "aws_route_table" "eia" {
  vpc_id = "${aws_vpc.eia.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eia.id}"
  }
}
resource "aws_route_table_association" "eia" {
  subnet_id = "${aws_subnet.eia.id}"
  route_table_id = "${aws_route_table.eia.id}"
}
resource "aws_security_group" "eia" {
  name = "eia-sg"
  vpc_id = "${aws_vpc.eia.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AMI def
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

# The instance itself
resource "aws_instance" "web" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "m3.medium"
  tags {
      Name = "EIAScrape"
  }

  key_name = "${var.aws_ssh_key_name}"

  vpc_security_group_ids = ["${aws_security_group.eia.id}"]
  subnet_id = "${aws_subnet.eia.id}"

  provisioner "file" {
    source = "scrape.sh"
    destination = "$HOME/scrape.sh"
  }

  provisioner "remote-exec" {
    script = "setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone ${data_git_url} $HOME/data",
    ]
  }
}
