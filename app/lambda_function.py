import boto3
import datetime

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    cloudwatch = boto3.client('cloudwatch')
    
    filters = [
        {
            'Name': 'tag:ec2',
            'Values': ['count'] #App EC2 Instance Name
        },
        # 실행 중인 ec2 instance만 가져오기
        {
            'Name': 'instance-state-name',
            'Values': ['running']
        }
    ]
    
    response = ec2.describe_instances(Filters=filters)

    instance_count = 0
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_count += 1
    
    # # CloudWatch에 지표 전송
    cloudwatch.put_metric_data(
        Namespace='EC2 Instance Count',
        MetricData=[
            {
                'MetricName': 'AppInstanceCount',
                'Timestamp': datetime.datetime.utcnow(),
                'Value': instance_count,
                'Unit': 'Count'
            },
        ]
    )

    return {
        'statusCode': 200,
        'body': f"App instance count: {instance_count}"
    }