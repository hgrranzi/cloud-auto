output "server_public_ip" {
  value = module.app-server.instances[*].public_ip
}