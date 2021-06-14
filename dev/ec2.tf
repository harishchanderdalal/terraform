##################################################################################
# RESOURCES Network
##################################################################################

#-------------------------------------------------------------------------- // App Ec2
resource "aws_security_group" "devAppSg" {
  name   = "devApp"
  description = "Allow ports for aap"
  vpc_id      = data.aws_vpc.vpc.id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

/* Sample
  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space]
  }
*/

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.environment_tag}-AppSg" })
}


resource "aws_instance" "devAppEc2" {
  count                  = var.instance_count  
  ami                    = data.aws_ami.app-ami.id
  instance_type          = var.instance_size
  subnet_id              = aws_subnet.devApp[count.index % var.subnet_count].id
  vpc_security_group_ids = [aws_security_group.devAppSg.id]  
  tags = merge(local.common_tags, { Name = "${var.environment_tag}App0${count.index + 1}" })

  root_block_device {
    volume_size = var.volume_size  
    volume_type = var.volume_type  
    encrypted             = false
    delete_on_termination = true
    tags = merge(local.common_tags, { Name = "${var.environment_tag}App0${count.index + 1}" })
  }  
}