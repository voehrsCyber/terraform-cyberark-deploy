variable "WIN_AMIS" {
  type = map(map(string))
  default = {
    12.0 = {
      us-east-1 = "ami-03f0247c921dfbd80"
      us-west-2 = "ami-0e219dce6006c1f03"
      eu-central-1 = "ami-04ac45703e289ef12"
    },
    11.7 = {
      us-east-1 = "ami-0857d4653bc70ed8a"
      us-west-2 = "ami-0b9a1112a689a957f"
      eu-central-1 = "ami-0cfbecbcf14098f23"
    },
    11.6 = {
      eu-central-1 = "ami-0be1b12c31b86f3d7"
    },
    11.5 = {
      eu-central-1 = "ami-0e347ea01ed304fb4"
    }
  }
}
