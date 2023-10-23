## 1. Create IAM user
- Made user `erika` and put into `devops` group
- Added `EC2FullAccess` and `VPCFullAccess` policies to `devops` group via UI.
Note: I have multiple AWS profiles configured so I will be using profile `lab`.

## 2. Configure AWS CLI
- Set credentials for `erika` for AWS CLI
  - `aws iam --profile lab create-access-key --user-name erika > erika_aws_key.json`
- Configure correct region for your AWS CLI. In this step, I am creating a profile called `erika-lab` so that I can switch between accounts
  - `aws configure --profile erika-lab`
  - Output:
    ```
    AWS Access Key ID [****************7UWS]: 
    AWS Secret Access Key [****************ReYs]: 
    Default region name [us-east-1]: us-east-1
    Default output format [None]: 
    ```

## 3. Create VPC
1. Create VPC
    - `aws ec2 --profile erika-lab create-vpc --cidr-block 16.0.0.0/24 --query Vpc.VpcId --output text`
    - Output: `vpc-0df9578ca897e4051`
2. Create subnet
    - `aws --profile erika-lab ec2 create-subnet --vpc-id vpc-0df9578ca897e4051 --cidr-block 16.0.0.0/25 --availability-zone us-east-1a --query Subnet.SubnetId --output text`
    - Output: `subnet-0a68b6a5268b82678`
3. Create internet gateway
    - `aws --profile erika-lab ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text`
    - Output: `igw-04ae7c2263c677542`
4. Attach internet gateway
    - `aws --profile erika-lab ec2 attach-internet-gateway --vpc-id vpc-0df9578ca897e4051 --internet-gateway-id igw-04ae7c2263c677542`
5. Create route table
    - `aws --profile erika-lab ec2 create-route-table --vpc-id vpc-0df9578ca897e4051 --query RouteTable.RouteTableId --output text`
    - Output: `rtb-0e106318bb86dc661`
6. Create route to send IPv4 traffic to the internet gateway
    - `aws --profile erika-lab ec2 create-route --route-table-id rtb-0e106318bb86dc661 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-04ae7c2263c677542`
    - Output:
    ```
    {
        "Return": true
    }
    ```
7. Associate route table with public subnet
    - `aws --profile erika-lab ec2 associate-route-table --route-table-id rtb-0e106318bb86dc661 --subnet-id subnet-0a68b6a5268b82678`
    - Output:
    ```
    {
        "AssociationId": "rtbassoc-01561cdeac29c3bcc",
        "AssociationState": {
            "State": "associated"
        }
    }
    ```
8. Create security group for SSH access
    - `aws --profile erika-lab ec2 create-security-group --group-name SSH --description "SSH access" --vpc-id vpc-0df9578ca897e4051`
    - Output:
    ```
    {
        "GroupId": "sg-042ca712e98152e03"
    }
    ```
9. Set the ingress for the security group
    - `aws ec2 --profile erika-lab authorize-security-group-ingress --group-id sg-042ca712e98152e03 --protocol tcp --port 22 --cidr 0.0.0.0/0`
    - Output:
    ```
    {
        "Return": true,
        "SecurityGroupRules": [
            {
                "SecurityGroupRuleId": "sgr-0f7fcbec06c6835c2",
                "GroupId": "sg-042ca712e98152e03",
                "GroupOwnerId": "658646432934",
                "IsEgress": false,
                "IpProtocol": "tcp",
                "FromPort": 22,
                "ToPort": 22,
                "CidrIpv4": "0.0.0.0/0"
            }
        ]
    }
    ```

## Create EC2 Instance
- `aws --profile erika-lab ec2 create-key-pair --key-name bootcamp --query "KeyMaterial" --output text > ~/.ssh/bootcamp.pem`
- `aws --profile erika-lab ec2 run-instances --image-id ami-0df435f331839b2d6 --count 1 --instance-type t2.micro --key-name bootcamp --security-group-ids sg-042ca712e98152e03 --subnet-id subnet-0a68b6a5268b82678 --associate-public-ip-address`
- From UI, confirmed that instance was running at `44.193.11.238`

## SSH and Install Docker and Docker Compose
```
ssh-add ~/.ssh/bootcamp.pem 
ssh ec2-user@44.193.11.238
sudo yum update
sudo systemctl start docker 
sudo usermod -aG docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Add Docker compose file
See file in repository: https://gitlab.com/evmiguel/aws-exercises/-/blob/main/docker-compose.yaml?ref_type=heads

## Add "deploy to EC2" step to your existing pipeline
- `aws ec2 --profile erika-lab authorize-security-group-ingress --group-id sg-042ca712e98152e03 --protocol tcp --port 3000 --cidr 0.0.0.0/0`
- Output:
```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-076d636f47f7458c4",
            "GroupId": "sg-042ca712e98152e03",
            "GroupOwnerId": "658646432934",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3000,
            "ToPort": 3000,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
```

## Configure automatic triggering of multi-branch pipeline

### Add branch based logic to Jenkinsfile
To build and deploy for main, see completed Jenkinsfile: https://gitlab.com/evmiguel/aws-exercises/-/blob/main/Jenkinsfile?ref_type=heads

### Add webhook to trigger pipeline automatically
- Webhook created by
  - Adding Ignore Committer Strategy for jenkins@example.com
  - Scan Multibranch Pipeline Triggers > checked Scan by Webhook > added trigger token
  - On GitLab > Webhooks > Added webhook for push events for http://134.209.64.193:8080/multibranch-webhook-trigger/invoke?token=ec2-exercises



