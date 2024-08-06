# ewc-challenge

## Scenario 1 - Development Set-Up for Example Voting App
1. Discuss & Justify Potential Deployment Options in Terms of Infrastructure for Development Environment
Infrastructure Options for Development Environment:

### Local Development with Docker Compose:

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
