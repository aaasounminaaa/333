import json
import boto3
import base64
from datetime import datetime
def lambda_handler(event, context):
    output=[]
    client = boto3.client('logs')
    for record in event['records']:
        data = record['data']
        decoded = base64.b64decode(data)
        decode_data = decoded.decode('UTF-8')
        ori_msg = decode_data.split('\t')
        path = ori_msg[4].split('\n')
        output_body = {
            "ip": ori_msg[0],
            "status_code": ori_msg[1],
            "url": ori_msg[2]+path[0],
            "delay_time": ori_msg[3]
        }
        json_output_body=json.dumps(output_body)
        response = client.put_log_events(
            logGroupName='cloudfront_log',
            logStreamName='cf_stream',
            logEvents=[
                {
                    'timestamp': int(datetime.now().timestamp() * 1000),
                    'message': json_output_body
                }
            ]
        )
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': record['data']
        }
        output.append(output_record)
    return {'records': output}