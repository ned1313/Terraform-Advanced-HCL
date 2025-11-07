locals {
  environments = ["Dev","Stage","Prod"]

  subnets = [
    {
        name = "subnet-1"
        cidr_block = "10.0.0.0/24"
        type = "public"
    },
    {
        name = "subnet-2"
        cidr_block = "10.0.1.0/24"
        type = "public"
    },
    {
        name = "subnet-3"
        cidr_block = "10.0.2.0/24"
        type = "private"
    },
  ]

  users = {
    alice = {
        role = "admin"
        email = "alice@globomatics.com"
    }
    barb = {
        role = "admin"
        email = "barb@globomatics.com"
    }
    chris = {
        role = "contributor"
        email = "chris@globomatics.com"
    }
    dinesh = {
        role = "contributor"
        email = "dinesh@globomatics.com"
    }
  }
}