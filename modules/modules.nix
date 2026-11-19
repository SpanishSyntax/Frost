{getFiles, ...}: {
  imports =
    getFiles ./system
    ++ getFiles ./hardware
    ++ getFiles ./network
    ++ getFiles ./security
    ++ getFiles ./desktop
    ++ getFiles ./virtualization
    ++ getFiles ./programs;
}
