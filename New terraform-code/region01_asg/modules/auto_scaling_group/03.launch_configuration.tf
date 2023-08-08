data "template_file" "init" {

  template = "${file("${path.module}/templates/userdata.sh")}"
  vars = {
    image_object_uri = "${var.image_object_uri}"
  }
}
resource "aws_launch_configuration" "web" {
    name_prefix = "${var.prefix}-web-config"
    image_id = var.image_id #ap-northeast-2 / ubuntu 20.4 ami-0c6e5afdd23291f73
    instance_type = var.instance_type
    key_name = var.keypair_name # var에서 keyName에 AWS에 등록될 키페어 명칭 수정

    security_groups = var.security_group_ids

    iam_instance_profile = "${aws_iam_instance_profile.ssm_instance_profile.id}"
    
    #user_data = filebase64("${path.module}/templates/userdata.sh")
    user_data = "${data.template_file.init.rendered}"
    
    lifecycle {
        create_before_destroy = true
    }
}

