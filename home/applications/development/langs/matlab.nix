{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.matlab;

  miss_hit_core = pkgs.python3Packages.buildPythonPackage rec {
    pname = "miss_hit_core";
    version = "0.9.44";
    pyproject = true;
    build-system = [pkgs.python3Packages.setuptools];
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-HJFgH/Hb9+8hfEYCj+27lAsVUB1eUvo5PpHoH8fxsrk=";
    };
    doCheck = false;
  };

  miss_hit = pkgs.python3Packages.buildPythonApplication rec {
    pname = "miss_hit";
    version = "0.9.44";
    pyproject = true;
    build-system = [pkgs.python3Packages.setuptools];
    propagatedBuildInputs = [miss_hit_core];
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-wHBbB7xL21T4A4icchBYhxyt/iDH3GUIZ4GLLUXnpK4=";
    };
    doCheck = false;
  };
in {
  options.frost.home.apps.development.langs.matlab.enable =
    lib.mkEnableOption "MATLAB language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.matlab-language-server # Brain (LSP)
      miss_hit_core # Janitor (mh_style formatter + mh_metric)
      miss_hit # Diagnostics (mh_lint)
    ];
  };
}
