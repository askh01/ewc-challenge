# ewc-challenge

## Scenario 1 - Development Set-Up for Example Voting App

### Discuss & Justify Potential Deployment Options in Terms of Infrastructure for Development Environment:

Deployment Options in terms if infrastructure for Development Environment:

I think we have multiple options for deployment of our DEV environment (consider AWS as our preferred cloud): 

### (Option 1) Deploy the containerized voting application on DEV VMs (EC2 instances):

Using this approach we can leverage a cloud ( AWS ) in the most simplest way to spin up a DEV environment. This approach ensures a scalable and consistent development environment using AWS EC2 instances and Docker containers. It mirrors the production environment closely, facilitating smooth transitions from development to production:

> **Note**: It is best that the following resources are provisioned in AWS using **Infrastructure-as-code** where we can leverage **Terraform or AWS cloudformation** , making it reproducable and manageable.
It involves:
1. **Creating a VPC**
    + Setting up public subnet ((for frontend apps (voting and result) that needs to be exposed to the public internet) and private subnet (for backend services (worker and redis) and DB))
    + Setting up internet gateway and attaching it to the VPC
    + Creating routing tables and configuring them to route traffic through the internet gateway
2.  **Launching Ec2 instances**
    + Choosing appropriate OS and its distribution (Linux / Ubuntu for example)
    + Choosing appropriate ec2 instance type (depending on the hardware requirements)
    + Choosing OS disk size and provision data disks (in order to persist the DB data)
    + Assigning VPC and the subnet to the ec2 instance
    + Configure security groups 
        + In order to allow SSH and HTTP access to the ec2 instances and open all necessary ports.
        + To make the ec2 instances accessible via public internet or only by certain instances within the VPC only
3. **Configuring EC2 instance**
    + Check access to ec2 instances by SSH into each instance
    + Creating disk partitions and mounting to Filesystems
    +  Install docker and docker compose (This can be also done by leveraging AWS User Data in terraform or AWS Cloudformation)

4. **Deploy the Application**
    The repo mentioned in this assignment already have a docker-compose.yaml script prepared to deploy all application. However we would need to adapt the script to match our desired setup, if needed. The default configuration should work, but ensure that the port are correctly mapped, volumes are mounted correctly (specially DB data volumes) and services are defined properly.


Pros:
+ Simplifies setup with predefined Docker Compose files.
+ No need for cloud resources, reducing costs.
+ Fast iterations and testing on local machines.

Cons:
+ Limited to local machine resources.
+ Does not replicate production environment accurately, especially for cloud-native features.
### AWS Elastic Beanstalk:

Pros:
+ Manages the infrastructure, freeing developers to focus on application code.
+ Provides easy scaling and management of environments.
+ Supports multiple languages and frameworks.

Cons:

+ Abstracts away some control over infrastructure.
+ Might be overkill for simple applications.
+ AWS ECS (Elastic Container Service) with Fargate:

Pros:

+ No need to manage EC2 instances; Fargate handles the compute.
+ Integrates well with other AWS services (RDS, S3, etc.).
+ Scalable and flexible container orchestration.

Cons:

+ Can be more complex to set up compared to Elastic Beanstalk.
+ Requires understanding of ECS and Fargate pricing.

### AWS EKS (Elastic Kubernetes Service):

Pros:

+ Provides maximum flexibility and control.
+ Ideal for complex, microservices-based applications.
+ Kubernetes expertise is transferable across clouds and on-premises.

Cons:
+ High complexity and operational overhead.
+ Steeper learning curve for teams not familiar with Kubernetes.

#### Recommended Approach:
For a development environment, using AWS ECS with Fargate is recommended due to its balance between control, ease of use, and scalability. It simplifies the deployment process by abstracting away the underlying infrastructure management while providing sufficient flexibility and integration with other AWS services.
