#!/bin/bash

# get hosted zone
echo "Enter hosted zone: "
read hosted_zone

# get record
echo "Enter record: "
read resource_record

# get output
echo "Output: (default: json)"
read output
output="${output:=json}"

# validate hosted zone
if [ "$hosted_zone" != *. ]
then
  hosted_zone="$hosted_zone."
fi

# validate resource record
if [ "$resource_record" != *. ]
then
  resource_record="$resource_record."
fi

# find the zone id
zone_id=$(aws route53 list-hosted-zones --query "HostedZones[?Name == '$hosted_zone']" | jq -c '.[] | .Id | sub("/hostedzone/"; "")' | tr -d '"')

# validate zone id
if [[ -z "$zone_id" ]]
then
  echo "Error: Could not find Zone ID";
  exit;
fi

# find the record
aws route53 list-resource-record-sets --hosted-zone-id $zone_id --query "ResourceRecordSets[?Name == '$resource_record']" --output $output
