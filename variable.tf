variable "awsprops" {
  type = map(string)
  default = {
    region       = "us-east-1"
    vpc          = "vpc-b33d9ace"
    itype        = "t2.micro"
    subnet       = "subnet-7e7c3070"
    publicip     = true
    keyname      = "20211"
    secgroupname = "IAC-Sec-Group"
  }
}
