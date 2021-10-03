provider "aws" {
    region = "eu-west-3"
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id 
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
}


resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags =  {
        Name: "${var.env_prefix}-vpc"
    }
}


module "myapp-server" {
    source = "./modules/webserver"
    my_ip = var.my_ip
    vpc_id = aws_vpc.myapp-vpc.id
    instance_type = var.instance_type
    public_key_location = var.public_key_location
    env_prefix = var.env_prefix
    avail_zone = var.avail_zone
    subnet_id = module.myapp-subnet.subnet.id
}