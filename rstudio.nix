{ nixpkgs ? null }:

let
  nixpkgsSrc =
    if isNull nixpkgs
      then
        builtins.fetchTarball {
          # nixpkgs-18.09 as of 2018-12-08
          url = "https://github.com/NixOS/nixpkgs/archive/135a7f9604c482a27caa2a6fff32c6a11a4d9035.tar.gz";
          sha256 = "0x5w33rv8y1zsmhxnac8d2jjp58w00zjhhg7m5pnswghcwgg6aqj";
        }
      else
        nixpkgs;

  myOverlay = self: super: { };
in

with import nixpkgsSrc { overlays = [ myOverlay ]; };

rstudioWrapper.override {
  packages = with rPackages; [
    car
    dplyr
    ggplot2
    glmnet
    reshape2
  ];
}
