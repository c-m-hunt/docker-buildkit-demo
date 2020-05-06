# Docker Build and BuildKit

## Enable BuildKit
For the session:
```
export DOCKER_BUILDKIT=1
```

On the daemon (Mac):
`Docker > Preferences > Docker Engine` - Amend config to:
```
{
  "debug": true,
  "experimental": true,
  "features":{
    "buildkit" : true
  }
}
```

## Features
Features marked with * require the following at the top of the Dockerfile:
```
# syntax=docker/dockerfile:experimental
```
This denotes experimental syntax. Further details on this can be found at https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md

### SSH *
```
docker build \
  --ssh default \
  -f dockerfiles/clone.Dockerfile \
  --no-cache \
  --progress=plain -t test-clone .
```
### Output
Use the `scratch` image to build output and then change the `--output` argument to output files from your `docker build` command rather than an image.
```
docker build \
	--ssh default \
	-f dockerfiles/clone.Dockerfile \
  --no-cache \
  --output test-output -t test-clone .
```

### Secrets *
This example builds on the output example above. It installs AWS CLI and then downloads a private file from S3 and copies it locally. 

To run, change the path to your creds file.
```
docker build -f dockerfiles/secret1.Dockerfile \
  --secret id=creds,src=/Users/chris.hunt/.aws/credentials \
  --output test-secret \
  -t test-secret .
```

The secret is mounted added to the build with an id `creds` and can be referenced in the Dockerfile in this way:
```
RUN --mount=type=secret,id=creds,dst=/root/.aws/credentials aws s3 cp s3://hudlrd-experiments/test .
```
This mounts the secret file to a destination for a single command.

Try removing the `mount` and run build again with `--no-cache`. You'll see that you get Forbidden.

## Tidy up
To tidy up the directory and Docker after running the above, run the following
```
docker rmi test-clone:latest
rm -rf test-output

docker rmi test-secret:latest
rm -rf test-secret
```