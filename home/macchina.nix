{ ... }:

{
  xdg.configFile."macchina/macchina.toml".text = ''
    show = ["Host", "Machine", "Kernel", "Distribution", "Shell", "Uptime", "Processor", "ProcessorLoad", "Memory", "Battery"]
  '';
}
