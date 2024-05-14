# calibre-web

## Build

```bash
$ export CALIBRE_VERSION=0.6.21
$ docker buildx build --build-arg CALIBRE_VERSION=$CALIBRE_VERSION -t registry.fmena.be/library/calibre-web:$CALIBRE_VERSION .
```
