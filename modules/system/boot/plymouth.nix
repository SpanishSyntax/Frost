{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.system.boot.plymouth;

  defaultThemeBySource = {
    adi1090x = "rings";
    bgrt = "nixos-bgrt";
    catppuccin = "catppuccin-mocha";
    builtin = "bgrt";
    custom = "frost-custom";
  };

  bgR = toString (builtins.elemAt cfg.custom.backgroundColor 0);
  bgG = toString (builtins.elemAt cfg.custom.backgroundColor 1);
  bgB = toString (builtins.elemAt cfg.custom.backgroundColor 2);

  scaleFilter =
    if cfg.custom.maxHeight != null
    then ",scale=-2:${toString cfg.custom.maxHeight}:flags=lanczos"
    else "";

  customThemePkg = pkgs.runCommand "plymouth-theme-${cfg.theme}" {
    nativeBuildInputs = [pkgs.ffmpeg];
  } ''
    themeDir="$out/share/plymouth/themes/${cfg.theme}"
    mkdir -p "$themeDir"

    if [ -d "${cfg.custom.media}" ]; then
      idx=1
      for f in $(find "${cfg.custom.media}" -maxdepth 1 -type f -iname '*.png' | sort); do
        printf -v frameName "frame-%04d.png" "$idx"
        cp "$f" "$themeDir/$frameName"
        idx=$((idx + 1))
      done
    else
      ffmpeg -v error -i "${cfg.custom.media}" \
        -vf "fps=${toString cfg.custom.fps}${scaleFilter}" \
        "$themeDir/frame-%04d.png"
    fi

    frameCount=$(find "$themeDir" -maxdepth 1 -type f -name 'frame-*.png' | wc -l)
    if [ "$frameCount" -eq 0 ]; then
      echo "frost.system.boot.plymouth.custom.media produced 0 PNG frames" >&2
      exit 1
    fi

    cat > "$themeDir/${cfg.theme}.plymouth" <<EOF
    [Plymouth Theme]
    Name=${cfg.theme}
    Description=Custom animated Plymouth theme built by Frost
    ModuleName=script

    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/${cfg.theme}.script
    EOF

    cat > "$themeDir/${cfg.theme}.script" <<EOF
    Window.SetBackgroundTopColor(${bgR}, ${bgG}, ${bgB});
    Window.SetBackgroundBottomColor(${bgR}, ${bgG}, ${bgB});

    frame_count = $frameCount;
    fps = ${toString cfg.custom.fps};
    loop = ${if cfg.custom.loop then "1" else "0"};

    for (i = 0; i < frame_count; i++) {
      n = i + 1;
      if (n < 10)        pad = "000" + n;
      else if (n < 100)  pad = "00" + n;
      else if (n < 1000) pad = "0" + n;
      else               pad = "" + n;
      frames[i] = Image("frame-" + pad + ".png");
    }

    sprite = Sprite();
    tick = 0;
    step = 50.0 / fps;

    fun refresh_callback() {
      idx = Math.Int(tick / step);
      if (loop == 1) {
        idx = idx % frame_count;
      } else if (idx >= frame_count) {
        idx = frame_count - 1;
      }
      img = frames[idx];
      sprite.SetImage(img);
      sprite.SetX(Window.GetWidth() / 2 - img.GetWidth() / 2);
      sprite.SetY(Window.GetHeight() / 2 - img.GetHeight() / 2);
      tick++;
    }
    Plymouth.SetRefreshFunction(refresh_callback);

    # Password prompt support (e.g. LUKS unlock)
    prompt_sprite = Sprite();
    bullets_sprite = Sprite();
    status_sprite = Sprite();

    fun display_normal_callback() {
      prompt_sprite.SetOpacity(0);
      bullets_sprite.SetOpacity(0);
    }
    Plymouth.SetDisplayNormalFunction(display_normal_callback);

    fun display_password_callback(prompt, bullets) {
      prompt_img = Image.Text(prompt, 0.9, 0.9, 0.95);
      prompt_sprite.SetImage(prompt_img);
      prompt_sprite.SetX(Window.GetWidth() / 2 - prompt_img.GetWidth() / 2);
      prompt_sprite.SetY(Window.GetHeight() * 0.78);
      prompt_sprite.SetOpacity(1);

      bullet_str = "";
      for (i = 0; i < bullets; i++) {
        bullet_str += "*";
      }
      bullets_img = Image.Text(bullet_str, 0.85, 0.9, 1.0);
      bullets_sprite.SetImage(bullets_img);
      bullets_sprite.SetX(Window.GetWidth() / 2 - bullets_img.GetWidth() / 2);
      bullets_sprite.SetY(Window.GetHeight() * 0.83);
      bullets_sprite.SetOpacity(1);
    }
    Plymouth.SetDisplayPasswordFunction(display_password_callback);

    fun message_callback(text) {
      msg_img = Image.Text(text, 0.75, 0.78, 0.85);
      status_sprite.SetImage(msg_img);
      status_sprite.SetX(Window.GetWidth() / 2 - msg_img.GetWidth() / 2);
      status_sprite.SetY(Window.GetHeight() * 0.90);
    }
    Plymouth.SetMessageFunction(message_callback);
    EOF
  '';

  defaultThemePackages =
    if cfg.source == "adi1090x"
    then [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [cfg.theme];
      })
    ]
    else if cfg.source == "bgrt"
    then [pkgs.nixos-bgrt-plymouth]
    else if cfg.source == "catppuccin"
    then [pkgs.catppuccin-plymouth]
    else if cfg.source == "custom"
    then lib.optional (cfg.custom.media != null) customThemePkg
    else [];
in {
  options.frost.system.boot.plymouth = {
    enable = lib.mkEnableOption "Plymouth boot splash animation";

    source = lib.mkOption {
      type = lib.types.enum ["adi1090x" "bgrt" "catppuccin" "builtin" "custom"];
      default = "adi1090x";
      description = ''
        Theme provider for Plymouth:
        - `adi1090x`: prebuilt animated pack (`adi1090x-plymouth-themes`, default theme `"rings"`).
        - `bgrt`: seamless UEFI OEM logo + NixOS spinner (`nixos-bgrt-plymouth`).
        - `catppuccin`: Catppuccin Plymouth pack (`catppuccin-plymouth`).
        - `builtin`: stock Plymouth themes (`bgrt`, `spinner`, `fade-in`, `details`).
        - `custom`: compile a video (`.mp4`/`.webm`), `.gif`, or directory of `.png` frames into an animated Plymouth script theme.
      '';
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = defaultThemeBySource.${cfg.source};
      description = "Selected Plymouth theme name.";
    };

    logo = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional custom PNG logo for `boot.plymouth.logo` (used by `bgrt`/`spinner`).";
    };

    custom = {
      media = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a video (`.mp4`/`.webm`), `.gif`, or directory of `.png` frames when `source = \"custom\"`.";
      };

      fps = lib.mkOption {
        type = lib.types.ints.positive;
        default = 30;
        description = "Frame extraction and playback rate (frames per second) for custom animations.";
      };

      maxHeight = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        example = 480;
        description = "Optional vertical resolution cap (in px, preserves aspect ratio) when extracting video/GIF frames to keep initrd size small.";
      };

      loop = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the custom animation loops continuously or holds on the last frame.";
      };

      backgroundColor = lib.mkOption {
        type = lib.types.listOf lib.types.float;
        default = [0.0 0.0 0.0];
        description = "RGB background color as three floats in `[0.0, 1.0]`.";
      };
    };

    themePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = defaultThemePackages;
      description = "Theme packages to install for Plymouth (auto-populated from `source`).";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.source != "custom" || cfg.custom.media != null;
          message = "frost.system.boot.plymouth.custom.media must be set when source = \"custom\".";
        }
      ];

      boot.plymouth =
        {
          enable = true;
          inherit (cfg) theme themePackages;
        }
        // lib.optionalAttrs (cfg.logo != null) {
          inherit (cfg) logo;
        };
    })

    (lib.mkIf (cfg.enable || (config.boot.plymouth.enable or false)) {
      frost.system.storage.impermanence.directories = [
        "/var/lib/plymouth"
      ];
    })
  ];
}
