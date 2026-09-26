{getFiles, ...}: {
  imports =
    getFiles ./desktop
    ++ getFiles ./flatpak
    ++ getFiles ./hardware
    ++ getFiles ./leisure
    ++ getFiles ./oci
    ++ getFiles ./personalization
    ++ getFiles ./security
    ++ getFiles ./services
    ++ getFiles ./storage
    ++ getFiles ./system
    ++ getFiles ./virtualization;
}
