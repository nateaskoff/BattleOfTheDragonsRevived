import os
import subprocess
import json
import re
import hashlib
import gitlab
import semver
import boto3
import botocore

print("This pre-commit hook is no longer in use. Use publish_module_v2.py to push module updates.")
quit()

# get credentials for various APIs and set up session vars for API calls
gitlabApiToken = os.getenv('GITLAB_API_TOKEN')
awsSession = boto3.Session()
awsS3Client = boto3.client('s3')
awsS3resource = boto3.resource('s3')
awsCredentials = awsSession.get_credentials()
awsCredentials = awsCredentials.get_frozen_credentials()
aws_access_key_id = awsCredentials.access_key
aws_secret_access_key = awsCredentials.secret_key
if gitlabApiToken is None:
    print("Did not find Gitlab API Token. Run: export GITLAB_API_TOKEN=< your token here >")
    exit(1)
else:
    gl = gitlab.Gitlab(private_token=gitlabApiToken)

# global string vars
moduleName = "Battle Of The Dragons Revived"

# local string vars
localModuleFileName = f"{moduleName}.mod"
localModuleJsonFileName = f"{moduleName}.meta.json"

def getMostRecentGitTag():
    try:
        gitTag = str(
                subprocess.check_output(
                    ['git', 'tag'], stderr=subprocess.STDOUT)
            ).strip('\'b\\n')
        gitTagList = gitTag.split('\\n')
        latestGitTag = gitTagList[len(gitTagList)-1]
    except subprocess.CalledProcessError as exec_info:
        raise Exception(str(exec_info.output))
    return latestGitTag

latestLocalGitTag = getMostRecentGitTag()

# remote gitlab repo string vars
try:
    projectList = gl.projects.list(owned=True)
except Exception:
    exit(1)

for p in projectList:
    if p.name == moduleName.replace(' ', ''):
        projectId = p.id

try:
    projectTags = gl.projects.get(projectId).tags.list()
except Exception:
    pass

# get latest remote tag
if projectTags is not None:
    latestRemoteTag = projectTags[len(projectTags)-1].name

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

# validate remote module file exists
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

# download latest module file from current S3
if localModuleFileExists == False:
    if remoteAwsModuleFileS3ObjectExists == True:
        try:
            print("Module file missing from local repo. Downloading the module now.")
            remoteAwsModuleFileS3Object.download_file(localModuleFileName)
            exit(1)
        except botocore.exceptions.ClientError as e:
            raise

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

# download latest module file from current S3
if localModuleFileExists == False:
    if remoteAwsModuleFileS3ObjectExists == True:
        try:
            print("Module file missing from local repo. Downloading the module now.")
            remoteAwsModuleFileS3Object.download_file(localModuleFileName)
            exit(1)
        except botocore.exceptions.ClientError as e:
            raise

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

# Get all s3 objects from remote module bucket archive and compare against local checksum
try:
    paginator = awsS3Client.get_paginator('list_objects')
    page_iterator = paginator.paginate(
        Bucket=remoteAwsModuleFile['bucket_name'])
    for page in page_iterator:
        for obj in page['Contents']:
            objKey = obj['Key']
            if (re.search('archive/[0-9]*\.[0-9]*', objKey) is not None) and (re.search('.json', objKey)):
                s3ArchiveVersionObj = awsS3resource.Object(remoteAwsModuleJsonFile['bucket_name'],objKey)
                s3ArchiveVersionObjStr = s3ArchiveVersionObj.get()['Body'].read().decode('utf-8')
                s3ArchiveVersionObjJsonData = json.loads(s3ArchiveVersionObjStr)
                s3ArchiveVersionObjChecksum = s3ArchiveVersionObjJsonData['sha256_checksum']
                if localModuleFileNameChecksum256 == s3ArchiveVersionObjChecksum:
                    print("Your local module checksum matches an archived checksum. Ensure you pull down the latest module before making changes.")
                    exit(1)
except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == "404":
        pass
    else:
        raise

# local is older than remote - check if module has been pushed. if not, throw error
if (semver.compare(latestLocalGitTag, latestRemoteTag) == -1) and (remoteAwsModuleFileJsonS3ObjectExists == True):
    try:
        remoteAwsModuleFileJsonS3ObjectStr = remoteAwsModuleFileJsonS3Object.get()['Body'].read().decode('utf-8')
        remoteAwsModuleFileJsonS3256Checksum = json.loads(remoteAwsModuleFileJsonS3ObjectStr)['sha256_checksum']
    except:
        raise
    if localModuleJsonPackageChecksum256 == remoteAwsModuleFileJsonS3256Checksum:
        print(f"The local version tag {latestLocalGitTag} is older than the remote tag {latestRemoteTag}. Has the latest module been published? Run _scripts/publish_module/publish_module.py")
        exit(1)
# local is same as remote - check module file checksum vs local metadata checksum and version. throw error to run publish_module
elif semver.compare(latestLocalGitTag, latestRemoteTag) == 0:
# Get s3 current metadata object from remote module bucket against local checksum
    try:
        paginator = awsS3Client.get_paginator('list_objects')
        page_iterator = paginator.paginate(
            Bucket=remoteAwsModuleFile['bucket_name'])
        for page in page_iterator:
            for obj in page['Contents']:
                objKey = obj['Key']
                if (re.search(f"current/{moduleName}\.meta\.json", objKey) is not None):
                    s3CurrentVersionObj = awsS3resource.Object(remoteAwsModuleFile['bucket_name'],objKey)
                    s3CurrentVersionObjStr = s3CurrentVersionObj.get()['Body'].read().decode('utf-8')
                    s3CurrentVersionObjJsonData = json.loads(s3CurrentVersionObjStr)
                    s3CurrentVersionObjChecksum = s3CurrentVersionObjJsonData['sha256_checksum']
                    if localModuleFileNameChecksum256 != s3CurrentVersionObjChecksum:
                        print("Your local module checksum does not match the current module checksum. Run _scripts/publish_module/publish_modul.py and push your latest tag.")
                        exit(1)
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            pass
        else:
            raise
# local is newer than remote - this is ok - maybe tag hasn't been pushed yet
elif semver.compare(latestLocalGitTag, latestRemoteTag) == -1:
    exit(0)
else:
    exit(0)
