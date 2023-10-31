# Getting started

This repository is a sample application for users following the getting started guide at https://docs.docker.com/get-started/.

The application is based on the application from the getting started tutorial at https://github.com/docker/getting-started

## Building the docker image with Nix

1. `nix-build docker.nix -o result`

2. `docker load -i result`

3. `docker run -dp 127.0.0.1:3000:3000 getting-started-with-docker`

## Notes to self:

Visit [this site](https://ryantm.github.io/nixpkgs/builders/images/dockertools/),
it has some decent information.

---

nix-prefetch-docker command can be used to get required image parameters:

```nix
nix-shell -p nix-prefetch-docker --run 'nix-prefetch-docker --image-name node --image-tag 18-alpine'
```

---

No clue how to copy something NOT to the root. I guess if it is already
structured into directories then it could be copied somewhat easily?

---

What is up with `runAsRoot`? It does not seem to have access to binaries that
are available inside the container. For example, it would complain that `yarn`
is not found, even though it is clearly part of the container...

Maybe it is running before the container has been finalized?

---

What would really interest me is why the using my own `node` docker worked. In
that case I was running `yarn install --production` inside of the node
container as `runAsRoot`, however, in that container the local files, such as
package.json should not have existed yet... The only explanation for it I can
imagine is that the containers are layered on top of each other in a reverse
order. Upon looking inside the container with `dive`, I could confirm that it
had two layers, which seemed to have corresponded to the two containers, each
forming its own layer. However, I do not understand the UI of `dive` well
enough to be able to determine the order, nor did I spend enough time
investigating it.

Either way, it *could* be possible that the `node` container is layered on
**TOP** of the getting started with docker one. In which case, the `yarn
install` command would also only run once the whole filesystem of the
underlying container has been finalized. In which case it is perfectly
possible to run `yarn install` there.

## Other resources that got me through this

["Generating a Docker image with Nix" by FasterThanLime](https://fasterthanli.me/series/building-a-rust-service-with-nix/part-11)

[This rather free-form documentation from the Nixpkgs Manual](https://ryantm.github.io/nixpkgs/builders/images/dockertools/)

["Containerize an Application" from the Docker Docs](https://docs.docker.com/get-started/02_our_app/)

["Docker Getting Started App"](https://github.com/docker/getting-started-app/tree/main)

["Building container images with Nix" by The Wagner](https://thewagner.net/blog/2021/02/25/building-container-images-with-nix/)

["Exploring Nix" by The Wagner](https://thewagner.net/blog/2020/04/30/exploring-nix/)

[This code snippet from The Wagner](https://github.com/wagdav/thewagner.net/blob/fcda05cf33ca24ed97a0a71a9139de72ecdc90c9/flake.nix#L52-L75)

## And some less strictly related resources

These resources are not strictly related to Docker, however they are the
reason I set out on this journey and actually got a docker container to build
correctly. I am referring to this as "journey", because it took way longer
than it should have.

["Trivial Builders" from the Nixpkgs Manual](https://ryantm.github.io/nixpkgs/builders/trivial-builders/)

["Nix Pills up to pill 9, which is the reason I have done this"](https://nixos.org/guides/nix-pills/automatic-runtime-dependencies)
