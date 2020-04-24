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

### SSH
```
docker build \
	--ssh default \
	-f dockerfiles/clone.Dockerfile \
  --no-cache \
  --progress=plain -t test-clone .
```
### Secrets

### Output
Use the `scratch` image to build output and then change the `--output` argument to output files from your `docker build` command rather than an image.
```
docker build \
	--ssh default \
	-f dockerfiles/clone.Dockerfile \
  --no-cache \
  --output test-output -t test-clone .
```

## Tidy up
To tidy up the directory and Docker after running the above, run the following
```
docker rmi test-clone:latest
rm -rf test-output
```