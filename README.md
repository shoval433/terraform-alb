# terraform-alb


Do it hard
----------
- Manually provision a VPC (do not use the default VPC!) with 2 Subnets and an Internet Gateway with a route configured in the Subnets' Route Tables.
- Manually provision an EC2 instance in each subnet (2 total) and configure the Security Group to allow SSH connection from outside (from your IP).
- Run the hostname-docker image (https://hub.docker.com/r/adongy/hostname-docker) on each instance.
- Manually provision a Load Balancer which will route traffic to both instances' containers.
- Test by accessing the Load Balancer address and refresh the page several times - watch the hostname changing.


Do it easy
----------
- Write Terraform code which provisions the same infrastructure from the "Do it hard" exercise.
- No need to use modules or variables yet.
- No need to run the containers at this step, just provision infrastructure.
