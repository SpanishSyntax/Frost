{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.cryo;
  system = pkgs.stdenv.hostPlatform.system;
  defaultPackage = inputs.cryo.packages.${system}.default;

  mcpHubSpec = {
    command = "${defaultPackage}/bin/cryo";
    args = ["serve"];
  };
in {
  imports = [inputs.cryo.homeManagerModules.default];

  options.frost.home.apps.icebergs.cryo = {
    enable = lib.mkEnableOption "Cryo central MCP server bridge";

    exportToMcpHub = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = builtins.toJSON mcpHubSpec;
      description = ''
        JSON snippet for registering Cryo with Antigravity, OpenCode, and Claude Desktop:
        {
          "command": "''${inputs.cryo.packages.''${pkgs.stdenv.hostPlatform.system}.default}/bin/cryo",
          "args": ["serve"]
        }
      '';
    };

    mcpServerAttr = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      default = mcpHubSpec;
      description = "Nix attribute set representation of `exportToMcpHub` for direct Nix composition.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.cryo.enable = true;
  };
}
