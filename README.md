# stelligent_interview_presentation
Resources for building Chef cookbooks, Test Kitchen verification, and CloudFormation template to launch an AMI

Jenkins Job:

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

