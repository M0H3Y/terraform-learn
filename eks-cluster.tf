provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}


module "eks" {
    source = "terraform-aws-modules/eks/aws"    
    cluster_name = local.cluster_name
    cluster_version = "1.20"

    subnets = module.myapp-vpc.private_subnets
    vpc_id = module.myapp-vpc.vpc_id

    tags = {
        environment = "development"
        application = "myapp"
    }
    
    worker_groups = [
        {
            instance_type = "t2.small"
            name = "worker-group-1"
            asg_desired_capacity = 2
        },
        {
            instance_type = "t2.medium"
            name = "worker-group-2"
            asg_desired_capacity = 1
        }
    ]
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id

}

