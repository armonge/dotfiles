return {
  -- behaviours
  automatically_reload_config = true,
  -- exit_behavior = "CloseOnCleanExit", -- if the shell program exited with a successful status
  exit_behavior_messaging = "Verbose",
  status_update_interval = 1000,

  scrollback_lines = 20000,

  -- Treat ':' as a word boundary so double-clicking on
  -- "tests/foo.py::test_name" selects each side of "::" separately.
  selection_word_boundary = " \t\n{}[]()\"'`:",


  term = "wezterm",
  -- Disabled: NFC-normalizing the output stream rewrites bytes that Claude
  -- Code (and other TUIs) already laid out, desyncing their cursor/width
  -- math and causing garbled, overlapping redraws.
  -- normalize_output_to_unicode_nfc = true,

  -- Enhanced keyboard protocol — lets Neovim distinguish Ctrl+i from Tab, etc.
  enable_kitty_keyboard = true,
  enable_csi_u_key_encoding = false, -- kitty protocol supersedes this

  hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
      format = "$0",
    },
    -- implicit mailto link
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
  },
}
