import boto3

dynamodb = boto3.resource('dynamodb', region_name='eu-north-1') 
table = dynamodb.Table("App_Table")

def get_all_regions():
    ec2 = boto3.client('ec2', region_name='eu-north-1')  
    response = ec2.describe_regions()
    return [region['RegionName'] for region in response['Regions']]


def get_services_from_sdk(region):
    try:
        services = set()  
        resourcegroupstaggingapi = boto3.client('resourcegroupstaggingapi', region_name=region)
        paginator = resourcegroupstaggingapi.get_paginator('get_resources') 
        for page in paginator.paginate():
            for resource in page.get('ResourceTagMappingList', []):
                arn = resource['ResourceARN']
                service_name = arn.split(':')[2] 
                services.add(service_name)
        return list(services)
    except Exception as e:
        print(f"Error fetching services from region {region}: {e}")
        return []



def insert_services_to_dynamodb(services, region):
    for service in services:
        try:
            table.put_item(
                Item={
                    'ServiceName': service,
                    'Region': region  
                }
            )
            print(f"Inserted service {service} from region {region} into DynamoDB.")
        except Exception as e:
            print(f"Error inserting {service} from region {region}: {e}")



def lambda_handler(event, context):
    regions = get_all_regions()  
    print(f"Regions found: {regions}")

    for region in regions:
        print(f"Fetching services from region: {region}")
        services = get_services_from_sdk(region)  
        print(f"Services found in {region}: {services}")

        if services:
            insert_services_to_dynamodb(services, region) 
             print(f"Inserted services for region: {region}")
        else:
            print(f"No services {region}.")


