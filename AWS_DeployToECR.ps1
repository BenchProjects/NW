param([Int32]$tag=0, $image="", $awsRepositoryName = "")

#Example call
# AWS_DeployToECR.ps1 38 myLocalContainerImage myRemoteAWSContainerImage
# assumes myLocalContainerImage is provided without container registry prefix

#Prerequisites:
# Machine must have Docker and AWS tools installed.
# Your container image is already built on your machine.
# Your AWS credentials have already been set on this machine.
# You have an AWS ECR repository.

function login-To-ecr(){
    $loginStatement = aws ecr get-login --no-include-email --region us-east-1 
    $loginStatementArray = $loginStatement -split ' '
    $username = $loginStatementArray[3]
    $password = $loginStatementArray[5]
    $ecr_endpoint = $loginStatementArray[6]

    $imagePrefix = $ecr_endpoint -replace "https://", ""
    $tempRepositoryImageName = $imagePrefix + "/" + $awsRepositoryName + ":latest"

    echo "$password" | docker login -u $username --password-stdin $ecr_endpoint

    if (-not $?)
    {
        throw "Login failed, please check AWS credentials are set up on this host"
    } 
    
    return $tempRepositoryImageName, $imagePrefix + "/" + $image
}

function verify-parameters(){
    if ($tag -eq 0)
    {
        throw "Parameter exception, tag was not passed"
    }

    if ($image -eq "")
    {
        throw "Parameter exception, container image name was not passed"
    }

    if ($awsRepositoryName -eq "")
    {
        throw "Parameter exception, repository name was not passed"
    }

    Write-Output "Repository name: $awsRepositoryName"
    Write-Output "Image name: $image"
    Write-Output "Tag: $tag"
}

function push-to-ecr([string]$finalRepositoryImageName = "", $repositoryPrefix = ""){

    if ($finalRepositoryImageName -eq "")
    {
        throw "Unable to determine aws repository to push to"
    }

    $taggedImageReference = $repositoryPrefix + "/" + $image + ":" + $tag

    docker tag $taggedImageReference $finalRepositoryImageName

    Write-Output "Source image successfully tagged"

    docker push $finalRepositoryImageName
}

Write-Output "Script version: 1"

#1 Verify script parameters
Write-Output "Attempting to verify script parameters"
verify-parameters

#2 login in to AWS
Write-Output "Attempting to log in to AWS"
$loginOutput = login-To-ecr
$finalRepositoryImageName =$loginOutput[1]
$registryContainerPrefix = $loginOutput[2]

#3 push container image to AWS
Write-Output "Attempting to push to AWS"
push-to-ecr $finalRepositoryImageName $registryContainerPrefix


if ($?){
    "Script completed successfully"
} else {
    "Script failed"
}