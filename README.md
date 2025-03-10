# Host a Web App on AWS with ALB and Disaster Recovery Using Terraform

This project demonstrates how to host a web application on AWS using an Application Load Balancer (ALB) and implement disaster recovery across multiple regions using Terraform.



## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS account with appropriate permissions to create resources.
- AWS CLI configured with your credentials.

## Variables

The variables used in this project are defined in [`_variables.tf`](terraform/_variables.tf). You can customize them as needed.



## Files:

Files
- **provider.tf**: Configures the AWS providers for primary and secondary regions.
- **network.tf**: Sets up the VPC, subnets, internet gateway, route tables, and security groups for the primary region.
- **network_secondary.tf**: Sets up the VPC, subnets, internet gateway, route tables, and security groups for the secondary region.
- **alb.tf**: Configures the Application Load Balancer, target groups, and listeners for the primary region.
- **alb_secondary.tf**: Configures the Application Load Balancer, target groups, and listeners for the secondary region.
- **asg.tf**: Sets up the Auto Scaling Group and Launch Template for the primary region.
- **asg_secondary.tf**: Sets up the Auto Scaling Group and Launch Template for the secondary - region.
- **script.sh**: User data script for instances in the primary region.
- **script_secondary.sh**: User data script for instances in the secondary region.
