# Provider configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# Create a new EC2 instance
resource "aws_instance" "wordpress" {
  ami           = "ami-0889a44b331db0194"  
  instance_type = "t2.micro"  

  tags = {
    Name = "wordpress-instance"
  }
}

# Create an RDS database for WordPress
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20  
  engine               = "mysql"
  engine_version       = "5.7"

  instance_class       = "db.t2.micro"  
  db_name                 = "wordpressdb"  
  username             = "admin"  
  password             = "password"  

  tags = {
    Name = "wordpress-db"
  }
}

# Create a security group for the EC2 instance
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Security group for WordPress"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow inbound traffic from all IP addresses
  }
}

# Create an elastic IP for the EC2 instance
resource "aws_eip" "wordpress_eip" {
  vpc = true
}

# Associate the elastic IP with the EC2 instance
resource "aws_eip_association" "wordpress_eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.wordpress_eip.id
}

# Output the public IP of the EC2 instance
output "wordpress_public_ip" {
  value = aws_eip.wordpress_eip.public_ip
}
