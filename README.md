# stelligent_interview_presentation
Resources for building Chef cookbooks, Test Kitchen verification, and CloudFormation template to launch an AMI

This project contains the pieces necessary to use Chef cookbooks to build up an AWS EC2 AMI, verify the cookbooks with Serverspec testing executed with Test Kitchen against base OS images, have Packer bake the AMI and finally update a Cloud Formation template stack with the new AMI.

PREREQUISITES:
- AWS IAM user with full permissions to CloudFormation and EC2, whose credentials are configured for the AWS CLI
- AWS KeyPair, to be adjusted if desired in the .kitchen.yml file, if desired for use for Test Kitchen
- AWS VPC with a default security group allowing ports 80 and 22 open to the world, for Test Kitchen
- AWS CLI local install
- Serverspec local install
- Chef local install
- Berkshelf local install
- Jenkins server with installs of Packer and AWS CLI

To execute Test Kitchen runs for all OS, execute this from the cookbooks/[role] folder (where role can be webserver, git, etc.):
```
kitchen test
```

This is also designed to be run against a specific OS, and in particular for Amazon Linux, against a particular AMI to allow the kitchen-ec2 driver to work for Amazon Linux.  So please note, that this is defaulted to us-east-1 AMI and should be adjusted accordingly as needed.

You can append the above command with either ubuntu, centos, or amazon-linux, for example, to run just those base OS tests.

Committing code to this Github repository will trigger the Jenkins build for Packer and AWS Cloud Formation.

Below is the Jenkins job that executes the Packer and Cloud Formation steps.

Jenkins Job:
```
#!/bin/bash
set -e
export AWS_ACCESS_KEY_ID=${aws_access_key}
export AWS_SECRET_ACCESS_KEY=${aws_secret_key}
export timestamp=$(date +%s)
export LD_LIBRARY_PATH="" # Fix an inherent issue with aws cli and this build of Jenkins

/usr/local/bin/packer build -machine-readable \
-var "aws_access_key=${aws_access_key}" \
-var "aws_secret_key=${aws_secret_key}" \
-var "run_list=recipe[webserver::httpd]" \
-var "region=${aws_region}" \
-var "ssh-user=${ssh_username}" \
-var "ami-base=${aws_base_ami}" \
-var "instance-size=${aws_instance_size}" \
packer.json | tee build-$timestamp.log

export ami_id=$(grep 'artifact,0,id' build-$timestamp.log | cut -d, -f6 | cut -d: -f2)

aws cloudformation update-stack --stack-name ${aws_stack} --use-previous-template --parameters ParameterKey=ImageId,ParameterValue=${ami_id} --region ${aws_region} --capabilities CAPABILITY_IAM

rm build-$timestamp.log
```

