resource "aws_ecr_repository" "employees" {
  name = "employees-repo"
  image_scanning_configuration {
    scan_on_push = true
    }
    tags = {
        Name = "employees-repo"
    } 
}
resource "aws_ecr_repository" "token" {
  name = "token-repo"
  image_scanning_configuration {
    scan_on_push = true
    }
    tags = {
        Name = "token-repo"
    } 
}