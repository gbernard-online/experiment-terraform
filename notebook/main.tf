variable "color" {
  default = "green"
  type = string
}

resource "null_resource" "node" {
  provisioner "local-exec" {
    command = "echo '${var.color}' | tee --append colors.txt"
  }
}

output "color" {
  value = "var.color"
}
