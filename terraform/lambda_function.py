import json
import boto3

def lambda_handler(event, context):
    client = boto3.client('autoscaling')

    response = client.set_desired_capacity (
        AutoScalingGroupName='my-asg_secondary',
        DesiredCapacity=1,
        HonorCooldown=False
    )

    print(response)