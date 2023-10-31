{ pkgs ? import <nixpkgs> {
    system = "x86_64-linux";
  }
}:

let
  # Because I have no clue how to pull a container...
  node = pkgs.dockerTools.buildImage {
    name = "node";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = with pkgs; [
        coreutils
        bash
        nodejs_18
        yarn
      ];
    };

    runAsRoot = ''
      yarn install --production
    '';
  };

  alpine-node = pkgs.dockerTools.pullImage {
    imageName = "node";
    imageDigest = "sha256:435dcad253bb5b7f347ebc69c8cc52de7c912eb7241098b920f2fc2d7843183d";
    sha256 = "0c7gdg3mr0wkh3xg6ziq23d4bl9yrqxqvgvnydjvbd4qqyj7f39s";
    finalImageName = "node";
    finalImageTag = "18-alpine";
  };

in
pkgs.dockerTools.buildImage {
  name = "getting-started-with-docker";
  tag = "latest";

  # fromImage = node;
  # copyToRoot = pkgs.buildEnv {
  #   name = "image-root";
  #   pathsToLink = [ "/" ];
  #   paths = with pkgs; [ coreutils bash nodejs_18 yarn ./. ];
  # };
  # copyToRoot = with pkgs; [ coreutils bash nodejs_18 yarn ./. ];
  fromImage = alpine-node;
  copyToRoot = with pkgs; [ bash ./. ];

  # runAsRoot = ''
  #   yarn install --production
  # '';

  config = {
    Cmd = [ "bash" "-c" "yarn install --production && node src/index.js" ];
    WorkingDir = "/";
    ExposedPorts = {
      "3000/tcp" = { };
    };
  };
}
