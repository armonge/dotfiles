return {
  -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
  ssh_domains = {},

  -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
  -- Start the mux server: wezterm-mux-server --daemonize
  -- Connect to it:        wezterm connect unix
  unix_domains = {
    { name = "unix" },
  },
}
