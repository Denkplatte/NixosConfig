{ username, ... }:

{
  # Set a password after first install with: passwd
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" "video" "render" ];
  };
}
