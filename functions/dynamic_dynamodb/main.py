import os
import json
import boto3
import pprint
pp = pprint.PrettyPrinter()


class DynamoDB(object):

    def __init__(self, table_name):
        self.client = boto3.client("dynamodb")
        self.table_name = table_name

    def update_provisioned_throughput(self, metric_name, provisioned_throughputs):
        rcu = provisioned_throughputs["ReadCapacityUnits"]
        wcu = provisioned_throughputs["WriteCapacityUnits"]

        if metric_name == "ConsumedReadCapacityUnits":
            rcu += 20
        elif metric_name == "ConsumedWriteCapacityUnits":
            wcu += 20
        else:
            raise "Unknown metric_name: {}".format(metric_name)

        return self.client.update_table(
                TableName=self.table_name,
                ProvisionedThroughput={
                    "ReadCapacityUnits": rcu,
                    "WriteCapacityUnits": wcu
                    }
                )

    def get_current_provisioned_throughput(self):
        return self.client.describe_table(
                TableName=self.table_name
                )["Table"]["ProvisionedThroughput"]


def publish2topic(msg, subj_suffix):
    client = boto3.client("sns")
    req = {}
    topic_arn = os.environ["TopicArn"]

    req.update({
        'TopicArn': topic_arn,
        'Message': msg,
        'Subject': '{} Update ProvisionedThroughput'.format(subj_suffix)
        })
    return client.publish(**req)


def handle(event, context):
    dynamodb = DynamoDB(os.environ["TableName"])
    message = json.loads(event["Records"][0]["Sns"]["Message"])
    #message = event["Records"][0]["Sns"]["Message"]

    try:
        resp = dynamodb.update_provisioned_throughput(
                message["Trigger"]["MetricName"],
                dynamodb.get_current_provisioned_throughput())
    except Exception as e:
        pp.pprint(e)
        subj_suffix = "[ERROR]"
        msg = e
    else:
        pp.pprint(resp)
        msg = resp
        subj_suffix = "[INFO]"
    pp.pprint(publish2topic(msg, subj_suffix))
