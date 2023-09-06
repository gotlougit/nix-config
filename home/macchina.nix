{ ... }:

{
  xdg.configFile."macchina/macchina.toml".text = ''
    memory_percentage = true
    disk_space_percentage = true
    show = ["Host", "Machine", "Kernel", "Distribution", "Shell", "Uptime", "Processor", "ProcessorLoad", "Memory", "Battery", "DiskSpace"]
  '';
}
