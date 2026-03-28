{pkgs , ...}:

{
  services.greetd = {
   enable = true;
   settings = {
    default_session = {
      command = ''
       tuigreet \
        --remember \
        --remember-session \
        --greeting "Welcome to Denkplatte" \
      '';
      user = "greeter";
    };
  };
 };
}
