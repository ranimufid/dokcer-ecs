variable "identifier" {
  # default = "mydb-rds"
  description = "Identifier for your DB, example: guestbookrdsinstance"
}

variable "storage" {
  default     = "5"
  description = "Storage size in GB"
}

variable "engine" {
  # default = "mysql"
  description = "Engine type, example: mysql or postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.6.22"
    postgres = "9.4.1"
  }
}

variable "instance_class" {
  # default = "db.t2.micro"
  description = "DB Size. Examples: db.t2.micro (1vCPU 1GiB), db.t2.small (1vCPU 2GiB), db.t2.medium (2vCPU 4GiB), db.t2.large (2vCPU 8GiB)"
}

variable "db_name" {
  description = "DB name, example: guestbookdb"
}

variable "username" {
  description = "DB Username, example: guestbookUser"
}

variable "password" {
  description = "DB Password"
}

variable "port" {
  description = "The port on which your db will receive connections: 3306 for MySQL, 5432 for Postgres"
}
