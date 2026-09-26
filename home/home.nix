{getFiles, ...}: {
  imports =
    getFiles ./applications
    ++ getFiles ./environment
    ++ getFiles ./services
    ++ getFiles ./ui;
}
