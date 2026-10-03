{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.bento_pdf;

  bentoLauncher = pkgs.writeShellScriptBin "bentopdf" ''
    PORT="37281"

    # Start caddy file server if not already running on this port
    if ! ${pkgs.iproute2}/bin/ss -tuln | grep -q ":$PORT "; then
      ${pkgs.caddy}/bin/caddy file-server --root "${pkgs.bentopdf}" --listen "127.0.0.1:$PORT" > /dev/null 2>&1 &
      sleep 0.3
    fi

    # Open default browser
    ${pkgs.xdg-utils}/bin/xdg-open "http://127.0.0.1:$PORT"
  '';
in {
  options.frost.home.apps.office.bento_pdf.enable = lib.mkEnableOption "Bentopdf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      bentoLauncher
    ];

    xdg.desktopEntries.bentopdf = {
      name = "BentoPDF";
      genericName = "PDF Toolkit";
      comment = "Privacy-first PDF toolkit";
      icon = "${pkgs.bentopdf}/favicon.ico";
      exec = "${bentoLauncher}/bin/bentopdf";
      terminal = false;
      categories = ["Office" "Utility"];
    };
  };
}
