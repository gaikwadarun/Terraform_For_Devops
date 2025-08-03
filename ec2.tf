resource "aws_key_pair" "mynewkey" {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
  
  }

  resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_tls" {
 
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port = 80
    to_port = 90
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
}
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "myinstance" {
 count = 2
  for_each = [ "Terra1", "Terra 2" ]
    key_name = aws_key_pair.mynewkey.key_name
    security_groups = [aws_security_group.allow_tls.name]
    instance_type = "t2.micro"
    ami = "ami-020cba7c55df1f615"

    root_block_device {
      volume_size = 15
      volume_type = "gp3"
    }
    tags = {
        name ="junooon"
    }
  
}

