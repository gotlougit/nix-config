{ lib, ... }:
{
  users.groups.snowflake = { };
  users.users.snowflake = {
    isSystemUser = true;
    createHome = false;
    group = "snowflake";
  };

  services.snowflake-proxy = {
    enable = true;
    capacity = 5;
  };

  systemd.services.snowflake-proxy.serviceConfig = {
    DynamicUser = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
    User = "snowflake";
    Group = "snowflake";
  };
}
