# 변수 설정
variable "ubuntu_ami_id" {
  type    = string
  default = "ami-0d52744d6551d851e" # 사용자가 원하는 AMI ID를 직접 입력
}

# aws_instance 리소스 정의
resource "aws_instance" "web_server" {
  ami           = var.ubuntu_ami_id # 직접 입력한 AMI ID 사용
  instance_type = "t2.micro"
  # 기타 설정
}