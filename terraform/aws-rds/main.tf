resource "aws_db_instance" "default" {
  # depends_on = ["aws_security_group.default"]
  identifier = "${var.identifier}"
  allocated_storage = "${var.storage}"
  storage_type = "gp2"
  engine = "${var.engine}"
  engine_version = "${lookup(var.engine_version, var.engine)}"
  instance_class = "${var.instance_class}"
  name = "${var.db_name}"
  username = "${var.username}"
  password = "${var.password}"
  port = "${var.port}"
  publicly_accessible = true
  multi_az = true
}