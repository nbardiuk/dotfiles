{ ... }:
{
  services.redshift = {
    enable = true;
    tray = true;
    longitude = "-9";
    latitude = "38";
    temperature = {
      day = 5700;
      night = 4500;
    };
  };
}
