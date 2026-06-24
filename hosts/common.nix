{...}: {
  imports = [
    ../services/ssh.nix
  ];

  # Allow SysRq to be used for process signaling (term, kill, and oom-kill)
  # https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html
  boot.kernel.sysctl."kernel.sysrq" = 64;
}
