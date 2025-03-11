import boto3
import os

def lambda_handler(event, context):
    asg_name = os.environ['ASG_NAME']
    desired_capacity = 1

    client = boto3.client('autoscaling')

    try:
        response = client.set_desired_capacity(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=desired_capacity,
            HonorCooldown=True
        )
        print(f'Successfully updated ASG desired capacity: {response}')
    except Exception as e:
        print(f'Error updating ASG desired capacity: {e}')