
output "instance_public_ip" {
   value = module.myapp-server.ec2-instance.public_ip

}