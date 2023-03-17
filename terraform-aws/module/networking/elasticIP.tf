resource "aws_eip" "myApp_eip" {
    count = var.settings.web_app.count
    instance = aws_instance.web_application[count.index].id
  vpc = true

  tags = {
    "Name" = "myApp_eip_${count.index}"
  }
}

