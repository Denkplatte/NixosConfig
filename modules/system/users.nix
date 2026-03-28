{...}:

{
 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.las = {
    isNormalUser = true;
    description = "las";
    extraGroups = [ "video render networkmanager" "wheel" "seat" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.users.greeter = {
    isSystemUser = true;
    description = "Greetd greeter user";
    extraGroups = [ "video" "input" "seat" ];
  };

}
