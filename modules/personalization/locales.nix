{
  config,
  lib,
  ...
}: let
  lcKeys = [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ];
in {
  options = {
    frost.personalization.locales.locale = lib.mkOption {
      type = lib.types.str;
      default = "en_GB.UTF-8";
      description = "Default system locale.";
    };
  };

  config = {
    i18n = {
      defaultLocale = config.frost.personalization.locales.locale;
      extraLocaleSettings = lib.genAttrs lcKeys (_: config.frost.personalization.locales.locale);
    };
  };
}
