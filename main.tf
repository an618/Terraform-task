#  providing access_key and secret_key in code
provider "aws" {
  region     = "ap-south-1"
  access_key = "access_key"
  secret_key = "secret_key "
}
resource "aws_instance" "myec2" {
  ami           = "ami-05c0f5389589545b7"
  instance_type = "t2.micro"
  vpc_security_group_ids=[aws_security_group.ownsg.id]  # --> this will attach sg to this instance
  key_name="tf-key-pair"  # this will attach key_pair to instance

# giving name to instance

tags={
 Name="terraform-plan"
}
}

# adding inbound rule

resource "aws_security_group" "ownsg" {
 name="ownsg"
ingress {
 from_port=80
 to_port=80
protocol="tcp"
cidr_blocks= ["0.0.0.0/0"]
}
ingress {
 from_port=22
 to_port=22
protocol="tcp"
cidr_blocks= ["0.0.0.0/0"]
}
# Adding outbound rule
egress {
 from_port=0
 to_port=0
protocol="-1"
cidr_blocks= ["0.0.0.0/0"]
}
}

# creating and adding key pair

resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096            #bydefault port
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
