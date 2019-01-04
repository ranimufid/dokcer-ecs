variable "identifier" {
  description = "Identifier for your DB, example: guestbookrdsinstance"
  default     = "guestbookrdsinstance-new"
}

variable "storage" {
  description = "Storage size in GB"
  default     = "10"
}

variable "engine" {
  description = "Engine type, example: mysql or postgres"
  default     = "mysql"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.23"
    postgres = "9.4.1"
  }
}

variable "instance_class" {
  description = "DB Size. Examples: db.t2.micro (1vCPU 1GiB), db.t2.small (1vCPU 2GiB), db.t2.medium (2vCPU 4GiB), db.t2.large (2vCPU 8GiB)"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "DB name, example: guestbookdb"
  default     = "guestbookdb"
}

variable "username" {
  description = "DB Username, example: guestbookUser"
  default     = "guestbookUser"
}

variable "password" {
  description = "DB Password"
  default     = "supersecretpassword"
}

variable "port" {
  description = "The port on which your db will receive connections: 3306 for MySQL, 5432 for Postgres"
  default     = 3306
}
