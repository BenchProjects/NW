param([Int32]$tag=0, $image="")

Write-Output "Script version: 1"

if ($tag -eq 0)
{
    throw "Parameter exception, tag was not passed"
}

if ($image -eq "")
{
    throw "Parameter exception, container image name was not passed"
}

Write-Output "Image name: $image"
Write-Output "Tag: $tag"

Write-Output "Attempting to log in to AWS"
Invoke-Expression -Command (Get-ECRLoginCommand -Region us-east-1).Command

if (-not $?)
{
    throw "Login failed, please check AWS credentials are set up on this host"
} 


docker tag 825688464055.dkr.ecr.us-east-1.amazonaws.com/benchprojects/nw:$tag 825688464055.dkr.ecr.us-east-1.amazonaws.com/pws/container_repo:latest

docker push 825688464055.dkr.ecr.us-east-1.amazonaws.com/pws/container_repo:latest

if ($?){
    "Script completed successfully"
} else {
    "Script failed"
}