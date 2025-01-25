import boto3
from flask import Flask, render_template, request , Response
import logging
import os

app = Flask(__name__)

aws_region  =   os.getenv("AWS_REGION")
dynamodb_table=os.getenv("DYNAMODB_TABLE")

dynamodb = boto3.resource('dynamodb', region_name=aws_region)
table = dynamodb.Table(dynamodb_table)


@app.route("/health")
def health():
    try:
        return Response(status=200)
    except Exception as e:
        app.logger.error(f"Health check failed: {e}")
        return Response(status=503)



@app.route('/')
def index():
    service_name = request.args.get('service_name')
    region = request.args.get('region')
    
    if not service_name and not region:
        response = table.scan()
    else:
        filter_expression = None
        expression_attribute_values = {}
        
        if service_name:
            filter_expression = boto3.dynamodb.conditions.Attr('ServiceName').eq(service_name)
            expression_attribute_values[':service_name'] = service_name
        
        if region:
            region_condition = boto3.dynamodb.conditions.Attr('Region').eq(region)
            expression_attribute_values[':region'] = region
            
            if filter_expression:
                filter_expression &= region_condition
            else:
                filter_expression = region_condition
        
        response = table.scan(
            FilterExpression=filter_expression,
            ExpressionAttributeValues=expression_attribute_values
        )
    
    return render_template('index.html', services=response['Items'])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)  
