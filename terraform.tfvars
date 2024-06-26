vpc_pool = [
  { cidr_block = "10.0.0.0/16", tags = { Name = "EKSCluster", Env = "EvangelionTeam" } }
]

default_gateway_ip = "0.0.0.0/0"

public_subnet_cidr_blocks = {
  "public_subnet-1a" : {
    "ip_range" : "10.0.0.0/24",
    "tags" : {
      "Name" : "public-subnet-1a"
    },
    availability_zone = "us-east-1a"
  },
  "public_subnet-1b" : {
    "ip_range" : "10.0.1.0/24",
    "tags" : {
      "Name" : "public-subnet-1b"
    },
    availability_zone = "us-east-1b"
  }
}

private_subnet_cidr_blocks = {
  "private_subnet-1a" : {
    "ip_range" : "10.0.3.0/24",
    "tags" : {
      "Name" : "private-subnet-1a"
    },
    availability_zone = "us-east-1a"
  },
  "private_subnet-1b" : {
    "ip_range" : "10.0.4.0/24",
    "tags" : {
      "Name" : "private-subnet-1b"
    },
    availability_zone = "us-east-1b"
  }
}

custom_ports = {
  80   = ["0.0.0.0/0"]
  8080 = ["10.0.0.0/16"]
}

