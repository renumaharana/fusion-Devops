terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.0"
    }

    /*github = {
      source  = "integrations/github"
      version = "6.3.1"
    }*/
    
  }
}

provider "aws" {
  # Configuration options
  region = "us-west-2"
}

/*provider "github" {
  # Configuration options
}

resource "github_repository" "fusion-devops" {
  name        = "fusion-devops"
  description = "My awesome web page"

  private = false

  pages {
    source {
      branch = "master"
      path   = "/docs"
    }
  }
}
*/


resource "aws_vpc" "myvpc" {
  cidr_block       = "20.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myVpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "20.20.1.0/24"
 

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}
resource "aws_route_table" "mrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "mrt"
  }
}
resource "aws_route_table_association" "MRTAssociation" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.mrt.id
}