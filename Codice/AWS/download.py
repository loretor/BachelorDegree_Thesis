import json
import boto3

def lambda_handler(event, context):
    
    s3 = boto3.client("s3")
    
    try:
        response = s3.get_object(Bucket = "raspberry-dati", Key = "dati.json")
    except:
        return{
            'statusCode':400,
            'body':json.dumps("Non esistono dati salvati sul bucket")
        }
    
    
    # TODO implement
    return {
        'statusCode': 200,
        'body': response['Body'].read()
    }
