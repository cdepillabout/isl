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

let

  myRPackages = with rPackages; [
    base64enc
    bitops
    car
    caTools
    dplyr
    evaluate
    ggplot2
    glmnet
    highr
    htmltools
    jsonlite
    knitr
    leaps
    markdown
    reshape2
    rmarkdown
    rprojroot
    yaml
  ];

  rstudio = rstudioWrapper.override { packages = myRPackages; };

  r = rWrapper.override { packages = myRPackages; };

  wrapped-rstudio =
    runCommand "wrapped-rstudio" { buildInputs = [pandoc makeWrapper]; } ''
      mkdir -p $out/bin
      cp ${rstudio}/bin/rstudio $out/bin
      wrapProgram $out/bin/rstudio \
        --set QT_PLUGIN_PATH "${qt5.qtbase.bin + "/" + qt5.qtbase.qtPluginPrefix}" \
        --prefix PATH : "${pandoc}/bin"
    '';

  r-and-rstudio-buildEnv = buildEnv {
      name = "r-and-rstudio-buildEnv";
      paths = [ wrapped-rstudio r ];
  };

  r-and-rstudio-buildEnv-with-override = r-and-rstudio-buildEnv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ wrapped-rstudio r ];
    passthru = (old.passthru or {}) // {
      rstudio = rstudio;
      r = r;
    };
  });
in

r-and-rstudio-buildEnv-with-override
