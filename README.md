# eia-backup

Scripts to snapshot EIA data prior to the inaguration of the Trump regime.

## Prerequisites

1. Amazon AWS account
2. An SSH key set up on AWS
3. An AWS access key and secret with permissions to launch instances in
   us-east-1
4. A git repo to store the data
5. [Terraform](http://terraform.io) installed locally

## Running

Export the following environment variables:

```
export TF_VAR_aws_access_key=<AWS user access key id>
export TF_VAR_aws_secret_key=<AWS user secret access key id>
export TF_VAR_aws_ssh_key_name=<name of keypair for ssh access>
export TF_VAR_data_git_url=https://<github_username>:<github_access_token>@github.com/<github_username>/repo
```

Then get the EC2 instance running with:

```
$ terraform apply
```

Once the instance is up and running, you can ssh into it with:

```
$ ssh -i /path/to/aws_ssh_key.pem <ip of instance>
```

In the home directory should sit the scraping script:

```
$ ./scrape.sh
```
