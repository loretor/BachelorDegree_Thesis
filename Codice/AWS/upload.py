import json
import boto3
import uuid

def lambda_handler(event, context):
    
    content = event['body']
    
    s3 = boto3.resource("s3")
    s3.Bucket("raspberry-dati").put_object(Key = "dati.json", Body = content)
    
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Dati salvati correttamente')
    }
