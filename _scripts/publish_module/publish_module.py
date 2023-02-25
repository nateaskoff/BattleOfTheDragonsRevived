import os
import subprocess
import json
import hashlib
import gitlab
import semver
import boto3
import botocore

print("This version of publish_module.py is deprecated and only kept for reference. Use publish_module_v2.py")
quit()

awsSession = boto3.Session()
awsS3Client = boto3.client('s3')
awsS3resource = boto3.resource('s3')
awsCredentials = awsSession.get_credentials()
awsCredentials = awsCredentials.get_frozen_credentials()
aws_access_key_id = awsCredentials.access_key
aws_secret_access_key = awsCredentials.secret_key

# global string vars
moduleName = "Battle Of The Dragons Revived"

# local string vars
localModuleFileName = f"{moduleName}.mod"
localModuleJsonFileName = f"{moduleName}.meta.json"

# remote aws string vars
remoteAwsModuleBucketName = 'shared-s3-mod-bucket'
remoteAwsModuleFile = {
    'bucket_name':remoteAwsModuleBucketName,
    'key':f"current/{localModuleFileName}"
}
remoteAwsModuleJsonFile = {
    'bucket_name':remoteAwsModuleBucketName,
    'key':f"current/{localModuleJsonFileName}"
}

# validate local files exist
localModuleFileExists = os.path.exists(localModuleFileName)
localModuleJsonFileExists = os.path.exists(localModuleJsonFileName)

try:
    remoteAwsModuleFileS3Object = awsS3resource.Object(
        remoteAwsModuleFile['bucket_name'], remoteAwsModuleFile['key']
    )
    remoteAwsModuleFileS3Object.load()
except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == "404":
        remoteAwsModuleFileS3ObjectExists = False
    else:
        raise
else:
    remoteAwsModuleFileS3ObjectExists = True

# Get checksum of local module file from json metadata file
sha256_hash = hashlib.sha256()
with open(localModuleFileName, "rb") as lmf:
    for byte_block in iter(lambda: lmf.read(4096), b""):
        sha256_hash.update(byte_block)
    localModuleFileNameChecksum256 = sha256_hash.hexdigest()

with open(localModuleJsonFileName) as lvf:
    localModuleJsonFileData = json.load(lvf)

localModuleJsonPackageVersion = localModuleJsonFileData['package_version']
localModuleJsonPackageChecksum256 = localModuleJsonFileData['sha256_checksum']

# validate remote module metadata file exists
try:
    remoteAwsModuleFileJsonS3Object = awsS3resource.Object(
        remoteAwsModuleJsonFile['bucket_name'], remoteAwsModuleJsonFile['key']
    )
    remoteAwsModuleFileJsonS3Object.load()
except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == "404":
        remoteAwsModuleFileJsonS3ObjectExists = False
    else:
        raise
else:
    remoteAwsModuleFileJsonS3ObjectExists = True

try:
    remoteAwsModuleFileJsonS3ObjectStr = remoteAwsModuleFileJsonS3Object.get()['Body'].read().decode('utf-8')
    remoteAwsModuleFileJsonS3256Checksum = json.loads(remoteAwsModuleFileJsonS3ObjectStr)['sha256_checksum']
except:
    raise
if localModuleFileNameChecksum256 != localModuleJsonPackageChecksum256:
    # if checksums are different, increment version and update checksum in JSON
    chosenVersTag = input("Enter the version tag for this module release using semantic version (1.0.0):")
    try:
        semver.parse(chosenVersTag)
    except Exception:
        raise
    if semver.compare(localModuleJsonPackageVersion, chosenVersTag) != -1:
        print(f"The version tag you chose is not greater than the current version: {localModuleJsonPackageVersion}")
        exit(1)
    else:
        # update JSON checksum and version
        localModuleJsonFileData['package_version'] = chosenVersTag
        localModuleJsonFileData['sha256_checksum'] = localModuleFileNameChecksum256
    jsonFile = open(localModuleJsonFileName, "w+")
    jsonFile.write(json.dumps(localModuleJsonFileData))
    jsonFile.close()
    # move current module and module metadata S3 objects to archive folder
    awsS3Client.copy_object(
        Bucket = remoteAwsModuleFile['bucket_name'],
        CopySource = {
            'Bucket': remoteAwsModuleBucketName,
            'Key': remoteAwsModuleFile['key']
        },
        Key = f"archive/{localModuleJsonPackageVersion}/{str(remoteAwsModuleFile['key']).replace('current/','')}"
    )
    awsS3Client.copy_object(
        Bucket = remoteAwsModuleJsonFile['bucket_name'],
        CopySource = {
            'Bucket': remoteAwsModuleBucketName,
            'Key': remoteAwsModuleJsonFile['key']
        },
        Key = f"archive/{localModuleJsonPackageVersion}/{str(remoteAwsModuleJsonFile['key']).replace('current/','')}"
    )
    # replace latest module and module json
    awsS3Client.upload_file(
        localModuleFileName,
        remoteAwsModuleBucketName,
        f"current/{localModuleFileName}"
    )
    awsS3Client.upload_file(
        localModuleJsonFileName,
        remoteAwsModuleBucketName,
        f"current/{localModuleJsonFileName}"
    )
    # push latest version tag
    try:
        str(subprocess.check_output(
            ['git','tag',chosenVersTag], stderr=subprocess.STDOUT
        ))
    except subprocess.CalledProcessError as exec_info:
        raise Exception(str(exec_info.output))
    else:
        print(f"Created tag: {chosenVersTag}")
    try:
        str(subprocess.check_output(
            ['git','push','--tags'], stderr=subprocess.STDOUT
        ))
    except subprocess.CalledProcessError as exec_info:
        raise Exception(str(exec_info.output))
    else:
        print(f"Pushed module release tag: {chosenVersTag} to remote.")
