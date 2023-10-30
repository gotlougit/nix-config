{ ... }:
{
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{ groups = [ "wheel" ]; persist = true; keepEnv = true; }];
}
