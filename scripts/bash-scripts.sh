# Check cluster egress ip

# Run a temporary debian pod in kubernetes cluster

kubectl run -it --rm test-ip --image=debian --generator=run-pod/v1

# install curl
apt-get update && apt-get install curl -y

# check egress ip
curl -s checkip.dyndns.org
