#!/usr/bin/env python3
"""Generate a WezTerm keybindings cheatsheet PDF from `wezterm show-keys`."""

import re
import subprocess
import sys
from fpdf import FPDF

# --- Parse wezterm show-keys output ---

FRIENDLY_ACTIONS = {
    "ActivateCopyMode": "Copy mode",
    "ActivateCommandPalette": "Command palette",
    "ShowLauncher": "Launcher",
    "ToggleFullScreen": "Toggle fullscreen",
    "ShowDebugOverlay": "Debug overlay",
    "TogglePaneZoomState": "Toggle pane zoom",
    "SpawnWindow": "New window",
    "ScrollToBottom": "Scroll to bottom",
    "PopKeyTable": "Exit mode",
    "IncreaseFontSize": "Increase font size",
    "DecreaseFontSize": "Decrease font size",
    "ResetFontSize": "Reset font size",
}

FRIENDLY_MODS = {
    "SUPER": "Cmd",
    "CTRL": "Ctrl",
    "SHIFT": "Shift",
    "ALT": "Alt",
    "LEADER": "Leader",
}

SKIP_ACTIONS = {
    # Internal/noisy actions we don't need on the cheatsheet
    "CompleteSelectionOrOpenLinkAtMouseCursor",
    "CompleteSelection",
    "StartWindowDrag",
    "ScrollByCurrentEventWheelDelta",
    "SelectTextAtMouseCursor",
    "ExtendSelectionToMouseCursor",
}

# Annotations provide extra context shown in italics AFTER the action.
# Only add annotations when they add info beyond the action label itself.
ANNOTATIONS = {
    "ActivateCopyMode": "vim-like selection",
    "ActivateCommandPalette": "search all commands",
    "ShowDebugOverlay": "Lua REPL + logs",
    "TogglePaneZoomState": "maximize/restore",
}

# Friendly names for CopyMode and other complex actions.
# These REPLACE the raw action — they are NOT annotations.
COPY_MODE_NAMES = {
    "CopyMode(CycleMatchType)": "Toggle regex/case mode",
    "CopyMode(ClearPattern)": "Clear search",
    "CopyMode(Close)": "Exit & scroll to bottom",
    "CopyMode(PriorMatch)": "Previous match",
    "CopyMode(NextMatch)": "Next match",
    "CopyMode(PriorMatchPage)": "Previous match (page)",
    "CopyMode(NextMatchPage)": "Next match (page)",
    "CopyMode(MoveByPage(0.5))": "Half page down",
    "CopyMode(MoveByPage(-0.5))": "Half page up",
    "CopyMode(PageUp)": "Page up",
    "CopyMode(PageDown)": "Page down",
    "CopyMode(MoveToScrollbackTop)": "Top of scrollback",
    "CopyMode(MoveToScrollbackBottom)": "Bottom of scrollback",
    "CopyMode(MoveToViewportTop)": "Top of viewport",
    "CopyMode(MoveToViewportMiddle)": "Middle of viewport",
    "CopyMode(MoveToViewportBottom)": "Bottom of viewport",
    "CopyMode(MoveToStartOfLine)": "Start of line",
    "CopyMode(MoveToStartOfLineContent)": "First non-blank",
    "CopyMode(MoveToEndOfLineContent)": "End of line",
    "CopyMode(MoveToStartOfNextLine)": "Start of next line",
    "CopyMode(MoveForwardWord)": "Next word",
    "CopyMode(MoveForwardWordEnd)": "End of word",
    "CopyMode(MoveBackwardWord)": "Previous word",
    "CopyMode(MoveLeft)": "Move left",
    "CopyMode(MoveRight)": "Move right",
    "CopyMode(MoveUp)": "Move up",
    "CopyMode(MoveDown)": "Move down",
    "CopyMode(SetSelectionMode(Some(Cell)))": "Char selection",
    "CopyMode(SetSelectionMode(Some(Line)))": "Line selection",
    "CopyMode(SetSelectionMode(Some(Block)))": "Block selection",
    "CopyMode(MoveToSelectionOtherEnd)": "Jump to other end",
    "CopyMode(MoveToSelectionOtherEndHoriz)": "Jump to other end (horiz)",
    "CopyMode(JumpForward { prev_char: false })": "Jump to char forward",
    "CopyMode(JumpForward { prev_char: true })": "Jump before char forward",
    "CopyMode(JumpBackward { prev_char: false })": "Jump to char backward",
    "CopyMode(JumpBackward { prev_char: true })": "Jump before char backward",
    "CopyMode(JumpAgain)": "Repeat last jump",
    "CopyMode(JumpReverse)": "Repeat last jump (reverse)",
}

EVENT_NAMES = {
    "tabs.manual-update-tab-title": "Rename tab",
    "tabs.reset-tab-title": "Reset tab title",
    "tabs.toggle-tab-bar": "Toggle tab bar",
    "confirm-close.close-pane": "Close pane",
    "confirm-close.close-tab": "Close tab",
    "scrollback.open-in-editor": "Scrollback in editor",
}


def parse_show_keys():
    result = subprocess.run(
        ["wezterm", "show-keys"], capture_output=True, text=True
    )
    output = result.stdout

    sections = {}
    current_section = None
    leader_line = None

    for line in output.splitlines():
        if line.startswith("Leader:"):
            leader_line = line
            continue
        if line.endswith("-" * 5) or line.endswith("-" * 10) or (
            line.strip() and all(c == "-" for c in line.strip())
        ):
            continue
        if line and not line.startswith("\t") and not line.startswith(" "):
            current_section = line.strip()
            if current_section not in sections:
                sections[current_section] = []
            continue
        if not line.strip():
            continue
        if current_section is not None:
            sections[current_section].append(line)

    return leader_line, sections


def format_mods(mods_str):
    mods_str = mods_str.strip()
    if not mods_str:
        return ""
    parts = [m.strip() for m in mods_str.split("|")]
    friendly = [FRIENDLY_MODS.get(p, p) for p in parts]
    return "+".join(friendly)


def format_key(key):
    key = key.strip()
    renames = {
        "LeftArrow": "Left",
        "RightArrow": "Right",
        "UpArrow": "Up",
        "DownArrow": "Down",
    }
    return renames.get(key, key)


def friendly_action(raw):
    raw = raw.strip()

    if raw in FRIENDLY_ACTIONS:
        return FRIENDLY_ACTIONS[raw]

    # Check COPY_MODE_NAMES for complex action mappings
    if raw in COPY_MODE_NAMES:
        return COPY_MODE_NAMES[raw]

    # EmitEvent
    m = re.match(r'EmitEvent\("(.+?)"\)', raw)
    if m:
        event = m.group(1)
        if event in EVENT_NAMES:
            return EVENT_NAMES[event]
        return "Custom action"

    # ActivateTab
    m = re.match(r"ActivateTab\((\d+)\)", raw)
    if m:
        return f"Go to tab {int(m.group(1)) + 1}"

    # ActivateTabRelative
    m = re.match(r"ActivateTabRelative\((-?\d+)\)", raw)
    if m:
        return "Previous tab" if int(m.group(1)) < 0 else "Next tab"

    # MoveTabRelative
    m = re.match(r"MoveTabRelative\((-?\d+)\)", raw)
    if m:
        return "Move tab left" if int(m.group(1)) < 0 else "Move tab right"

    # SpawnTab
    if "SpawnTab" in raw:
        return "New tab"

    # ScrollByLine
    m = re.match(r"ScrollByLine\((-?\d+)\)", raw)
    if m:
        n = int(m.group(1))
        return f"Scroll {'up' if n < 0 else 'down'} {abs(n)} lines"

    # ScrollByPage
    m = re.match(r"ScrollByPage\((-?[\d.]+)\)", raw)
    if m:
        v = float(m.group(1))
        pct = int(abs(v) * 100)
        return f"Scroll {'up' if v < 0 else 'down'} {pct}%"

    # SplitVertical / SplitHorizontal
    if "SplitVertical" in raw:
        return "Split vertical"
    if "SplitHorizontal" in raw:
        return "Split horizontal"

    # ActivatePaneDirection
    m = re.match(r"ActivatePaneDirection\((\w+)\)", raw)
    if m:
        return f"Focus pane {m.group(1).lower()}"

    # AdjustPaneSize
    m = re.match(r"AdjustPaneSize\((\w+), (\d+)\)", raw)
    if m:
        return f"Resize pane {m.group(1).lower()}"

    # PaneSelect
    if "PaneSelect" in raw:
        return "Swap pane (picker)"

    # CopyTo / PasteFrom
    if "CopyTo" in raw:
        return "Copy"
    if "PasteFrom" in raw:
        return "Paste"

    # SendString
    m = re.match(r'SendString\("(.+?)"\)', raw)
    if m:
        val = m.group(1)
        if val == "\\u{15}":
            return "Delete to line start"
        if val == "\\u{1b}\\r":
            return "Send Alt+Enter"
        if val == "\\u{1b}OH":
            return "Home"
        if val == "\\u{1b}OF":
            return "End"
        return f"Send: {val}"

    # Search
    if "Search(" in raw:
        return "Search"

    # QuickSelect
    m = re.search(r'label: "(.+?)"', raw)
    if m:
        label = m.group(1)
        return label.capitalize()

    # ShowLauncherArgs
    if "ShowLauncherArgs" in raw:
        if "TABS" in raw:
            return "Fuzzy tab switcher"
        if "WORKSPACES" in raw:
            return "Fuzzy workspace switcher"
        if "KEY_ASSIGNMENTS" in raw:
            return "Show all keybindings"
        return "Launcher"

    # ActivateKeyTable
    m = re.search(r'name: "(.+?)"', raw)
    if m:
        name = m.group(1)
        labels = {
            "resize_font": "Resize font mode",
            "resize_pane": "Resize pane mode",
        }
        return labels.get(name, f"Mode: {name}")

    # SwitchWorkspaceRelative
    m = re.match(r"SwitchWorkspaceRelative\((-?\d+)\)", raw)
    if m:
        return "Previous workspace" if int(m.group(1)) < 0 else "Next workspace"

    # PromptInputLine
    if "PromptInputLine" in raw:
        return "New workspace (prompt)"

    # Multiple
    if "Multiple(" in raw:
        # For copy mode: Multiple with CopyTo + Close
        if "CopyTo" in raw and "Close" in raw:
            return "Yank selection & exit"
        if "ScrollToBottom" in raw and "Close" in raw:
            return "Exit & scroll to bottom"
        return raw[:50]

    # CopyMode actions (fallback for any not in COPY_MODE_NAMES)
    m = re.match(r"CopyMode\((.+)\)", raw)
    if m:
        inner = m.group(1)
        return COPY_MODE_NAMES.get(raw, inner)

    # OpenLinkAtMouseCursor
    if "OpenLinkAtMouseCursor" in raw:
        return "Open link"

    return raw[:50]


def parse_key_line(line):
    # Format: \tMODS   Key   ->   Action
    m = re.match(r"\t(.+?)\s{2,}(\S+)\s+->   (.+)", line)
    if not m:
        return None

    mods_raw, key_raw, action_raw = m.group(1).strip(), m.group(2), m.group(3)
    action_raw = action_raw.strip()

    # Skip noisy actions
    for skip in SKIP_ACTIONS:
        if skip in action_raw:
            return None

    mods = format_mods(mods_raw)
    key = format_key(key_raw)

    if mods:
        key_combo = f"{mods}+{key}"
    else:
        key_combo = key

    action_friendly = friendly_action(action_raw)
    annotation = ANNOTATIONS.get(action_raw, "")

    return key_combo, action_friendly, annotation


def parse_mouse_line(line):
    m = re.match(
        r"\t(.*?)\s{2,}(Down|Up|Drag)\s+\{\s*streak:\s*(\d+),\s*button:\s*(\w+).*?\}\s+->   (.+)",
        line,
    )
    if not m:
        return None

    mods_raw = m.group(1).strip()
    event_type = m.group(2)
    streak = int(m.group(3))
    button = m.group(4)
    action_raw = m.group(5).strip()

    for skip in SKIP_ACTIONS:
        if skip in action_raw:
            return None

    mods = format_mods(mods_raw) if mods_raw else ""

    click_label = {1: "Click", 2: "Double-click", 3: "Triple-click"}.get(streak, f"{streak}x click")

    if event_type == "Drag":
        click_label = "Drag"
    elif event_type == "Up" and "OpenLink" in action_raw:
        click_label = "Click"
    else:
        return None  # Only show interesting mouse bindings

    btn = button if button != "Left" else ""
    parts = [p for p in [mods, btn, click_label] if p]
    key_combo = "+".join(parts) if len(parts) > 1 else parts[0]

    return key_combo, friendly_action(action_raw), ""


# --- Categorize default key table ---

# Pattern-based categorization on the raw action string
ACTION_CATEGORIES = {
    "General": [
        "ActivateCopyMode", "ActivateCommandPalette", "ShowLauncher",
        "ToggleFullScreen", "ShowDebugOverlay", "Search(",
        "scrollback.open-in-editor",
    ],
    "Tabs": [
        "SpawnTab", "ActivateTab(", "ActivateTabRelative",
        "MoveTabRelative", "tabs.", "confirm-close.close-tab",
    ],
    "Panes": [
        "Split", "ActivatePaneDirection", "PaneSelect",
        "TogglePaneZoomState", "confirm-close.close-pane",
        "AdjustPaneSize",
    ],
    "Scrolling": ["ScrollByLine", "ScrollByPage"],
    "Window": ["SpawnWindow"],
    "Clipboard & Cursor": ["CopyTo", "PasteFrom", "SendString"],
    "Quick Select": ["QuickSelect"],
    "Workspaces": ["SwitchWorkspaceRelative", "PromptInputLine"],
    "Leader Modes": ["ActivateKeyTable"],
}

# For ShowLauncherArgs, categorize by flags
LAUNCHER_CATEGORIES = {
    "TABS": "General",
    "WORKSPACES": "General",
    "KEY_ASSIGNMENTS": "Leader Modes",
}

# Key-combo overrides for categorization (for opaque user-defined callbacks)
KEY_COMBO_CATEGORIES = {
    "Cmd+-": "Window",
    "Cmd+=": "Window",
}


def categorize(action_raw, key_combo=""):
    # Key-combo override takes precedence
    if key_combo in KEY_COMBO_CATEGORIES:
        return KEY_COMBO_CATEGORIES[key_combo]

    # ShowLauncherArgs: categorize by flags
    if "ShowLauncherArgs" in action_raw:
        for flag, cat in LAUNCHER_CATEGORIES.items():
            if flag in action_raw:
                return cat
        return "General"

    # Pattern matching on action string
    for cat, patterns in ACTION_CATEGORIES.items():
        for p in patterns:
            if p in action_raw:
                return cat

    return "Other"


# --- PDF generation ---

class CheatsheetPDF(FPDF):
    BG = (26, 27, 38)
    SURFACE = (36, 40, 59)
    OVERLAY = (55, 59, 81)
    TEXT = (192, 202, 245)
    SUBTEXT = (134, 150, 187)
    DIM = (100, 110, 140)
    BLUE = (125, 174, 255)
    CYAN = (125, 207, 255)
    MAGENTA = (187, 154, 247)
    GREEN = (158, 206, 106)
    ORANGE = (255, 158, 100)
    YELLOW = (224, 175, 104)
    TEAL = (115, 218, 202)
    RED = (247, 118, 142)

    COL_W = 125
    ROW_H = 5.0
    KEY_W = 38
    GAP = 8

    SECTION_COLORS = {
        "General": BLUE,
        "Quick Select": ORANGE,
        "Scrolling": TEAL,
        "Tabs": CYAN,
        "Panes": GREEN,
        "Window": YELLOW,
        "Clipboard & Cursor": RED,
        "Leader Modes": MAGENTA,
        "Workspaces": MAGENTA,
        "Copy Mode": BLUE,
        "Search Mode": ORANGE,
        "Resize Font": TEAL,
        "Resize Pane": GREEN,
        "Mouse": YELLOW,
        "Other": SUBTEXT,
    }

    def draw_bg(self):
        self.set_fill_color(*self.BG)
        self.rect(0, 0, self.w, self.h, "F")

    def title_block(self, subtitle):
        self.set_y(6)
        self.set_font("Helvetica", "B", 20)
        self.set_text_color(*self.TEXT)
        self.cell(0, 10, "WezTerm Cheatsheet", align="C", new_x="LMARGIN", new_y="NEXT")
        self.set_font("Helvetica", "", 7.5)
        self.set_text_color(*self.SUBTEXT)
        self.cell(0, 4, subtitle, align="C", new_x="LMARGIN", new_y="NEXT")
        self.ln(3)

    def section_title(self, title, x):
        color = self.SECTION_COLORS.get(title, self.BLUE)
        self.set_x(x)
        self.set_font("Helvetica", "B", 7.5)
        self.set_text_color(*color)
        self.cell(self.COL_W, 5, title.upper(), new_x="LMARGIN", new_y="NEXT")
        y = self.get_y()
        self.set_draw_color(*self.OVERLAY)
        self.set_line_width(0.3)
        self.line(x, y, x + self.COL_W, y)
        self.ln(0.8)

    def table_row(self, key, action, x, alt=False, annotation=""):
        if alt:
            self.set_fill_color(*self.SURFACE)
            self.rect(x, self.get_y(), self.COL_W, self.ROW_H, "F")

        self.set_x(x)
        self.set_font("Courier", "B", 6.5)
        self.set_text_color(*self.MAGENTA)
        self.cell(self.KEY_W, self.ROW_H, f" {key}")

        self.set_font("Helvetica", "", 7)
        self.set_text_color(*self.TEXT)
        if annotation:
            action_w = self.get_string_width(action + "  ")
            self.cell(action_w, self.ROW_H, action)
            self.set_font("Helvetica", "I", 6)
            self.set_text_color(*self.DIM)
            self.cell(self.COL_W - self.KEY_W - action_w, self.ROW_H, annotation, new_x="LMARGIN", new_y="NEXT")
        else:
            self.cell(self.COL_W - self.KEY_W, self.ROW_H, action, new_x="LMARGIN", new_y="NEXT")

    def add_section(self, title, rows, x):
        if not rows:
            return
        self.section_title(title, x)
        for i, (k, v, ann) in enumerate(rows):
            self.table_row(k, v, x, alt=i % 2 == 0, annotation=ann)
        self.ln(2)


# Key-combo overrides for opaque action_callback entries (user-defined-N).
# WezTerm can't dump the Lua closure, so we label them by their key combo.
KEY_COMBO_OVERRIDES = {
    "Cmd+-": "Shrink window",
    "Cmd+=": "Grow window",
}


def dedup_copy_mode(rows):
    """Remove duplicate Shift+X rows that do the same as the bare key (e.g. Shift+G = G)."""
    seen = {}
    for key, action, ann in rows:
        seen.setdefault(action, []).append((key, action, ann))

    deduped = []
    used_actions = set()
    for key, action, ann in rows:
        if action in used_actions:
            continue
        entries = seen[action]
        if len(entries) > 1:
            # Keep the shortest key combo (bare key over Shift+key)
            shortest = min(entries, key=lambda e: len(e[0]))
            deduped.append(shortest)
        else:
            deduped.append((key, action, ann))
        used_actions.add(action)
    return deduped


def main():
    leader_line, sections = parse_show_keys()

    # Parse default key table into categories
    categorized = {}
    for line in sections.get("Default key table", []):
        parsed = parse_key_line(line)
        if parsed:
            key, action, ann = parsed
            # Apply key-combo overrides for opaque callbacks
            if key in KEY_COMBO_OVERRIDES:
                action = KEY_COMBO_OVERRIDES[key]
            action_raw = line.split("->")[-1].strip() if "->" in line else ""
            cat = categorize(action_raw, key)
            categorized.setdefault(cat, []).append((key, action, ann))

    # Collapse "Go to tab N" rows into a single "Cmd+1..8" row
    if "Tabs" in categorized:
        tab_rows = categorized["Tabs"]
        go_to_tab = [r for r in tab_rows if r[1].startswith("Go to tab")]
        if len(go_to_tab) > 1:
            other_rows = [r for r in tab_rows if not r[1].startswith("Go to tab")]
            other_rows.append(("Cmd+1..8", "Go to tab N", ""))
            categorized["Tabs"] = other_rows

    # Merge "Leader Modes" keybindings that are actually in KEY_ASSIGNMENTS
    if "Other" in categorized:
        remaining = []
        for key, action, ann in categorized["Other"]:
            if "keybindings" in action.lower():
                categorized.setdefault("Leader Modes", []).append((key, action, ann))
            else:
                remaining.append((key, action, ann))
        if remaining:
            categorized["Other"] = remaining
        else:
            del categorized["Other"]

    # Parse key tables
    copy_mode_rows = dedup_copy_mode([
        parsed for line in sections.get("Key Table: copy_mode", [])
        if (parsed := parse_key_line(line)) is not None
    ])

    search_mode_rows = [
        parsed for line in sections.get("Key Table: search_mode", [])
        if (parsed := parse_key_line(line)) is not None
    ]

    resize_font_rows = [
        parsed for line in sections.get("Key Table: resize_font", [])
        if (parsed := parse_key_line(line)) is not None
    ]

    resize_pane_rows = [
        parsed for line in sections.get("Key Table: resize_pane", [])
        if (parsed := parse_key_line(line)) is not None
    ]

    # Parse mouse
    mouse_rows = [
        parsed for line in sections.get("Mouse", [])
        if (parsed := parse_mouse_line(line)) is not None
    ]

    # --- Build PDF ---
    pdf = CheatsheetPDF(orientation="L", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=False)

    # Page 1: Main keybindings
    pdf.add_page()
    pdf.draw_bg()
    # Parse leader key from "Leader: Physical(Space) CTRL | SUPER 1s" format
    leader_desc = "Unknown"
    if leader_line:
        m = re.match(r"Leader:\s+Physical\((\w+)\)\s+(.*?)\s+\d+", leader_line)
        if m:
            key = m.group(1)
            mods = format_mods(m.group(2))
            leader_desc = f"{mods}+{key}" if mods else key

    # Derive SUPER/SUPER_REV mappings from actual keybindings
    # Look at what modifiers appear in the resolved keys
    all_lines = sections.get("Default key table", [])
    mod_sets = set()
    for line in all_lines:
        km = re.match(r"\t(.+?)\s{2,}(\S+)\s+->", line)
        if km:
            mod_sets.add(km.group(1).strip())
    # Detect: if SUPER appears alone, that's the "SUPER" alias; if CTRL | SUPER appears, that's "SUPER_REV"
    super_label = None
    super_rev_label = None
    for ms in mod_sets:
        parts = [p.strip() for p in ms.split("|")]
        if parts == ["SUPER"]:
            super_label = "Cmd"
        elif parts == ["ALT"]:
            super_label = super_label or "Alt"
        if set(parts) == {"CTRL", "SUPER"}:
            super_rev_label = "Ctrl+Cmd"
        elif set(parts) == {"ALT", "CTRL"}:
            super_rev_label = super_rev_label or "Ctrl+Alt"

    subtitle_parts = [f"Leader: {leader_desc}"]
    if super_label:
        subtitle_parts.append(f"{super_label} = SUPER")
    if super_rev_label:
        subtitle_parts.append(f"{super_rev_label} = SUPER_REV")

    pdf.title_block("          ".join(subtitle_parts))

    left = 10
    right = left + pdf.COL_W + pdf.GAP
    save_y = pdf.get_y()

    left_order = ["General", "Tabs", "Panes"]
    right_order = ["Quick Select", "Scrolling", "Window", "Clipboard & Cursor", "Workspaces", "Leader Modes"]

    for cat in left_order:
        if cat in categorized:
            pdf.add_section(cat, categorized[cat], left)

    pdf.set_y(save_y)

    for cat in right_order:
        if cat in categorized:
            pdf.add_section(cat, categorized[cat], right)

    # Mouse at the end of right column
    if mouse_rows:
        pdf.add_section("Mouse", mouse_rows, right)

    # Other (if any)
    if "Other" in categorized:
        pdf.add_section("Other", categorized["Other"], right)

    # Page 2: Copy mode, search mode, key tables
    if copy_mode_rows or search_mode_rows:
        pdf.add_page()
        pdf.draw_bg()
        pdf.set_y(8)
        pdf.set_font("Helvetica", "B", 16)
        pdf.set_text_color(*pdf.TEXT)
        pdf.cell(0, 8, "Modal Key Tables", align="C", new_x="LMARGIN", new_y="NEXT")
        pdf.ln(3)

        # Find activation keys for each mode from the default key table
        mode_activators = {}
        all_default = categorized.get("General", []) + categorized.get("Leader Modes", [])
        for cat_rows in categorized.values():
            for key, action, _ in cat_rows:
                if "Copy mode" in action:
                    mode_activators["copy_mode"] = key
                elif action == "Search":
                    mode_activators["search"] = key
                elif "Resize font" in action:
                    mode_activators["resize_font"] = key
                elif "Resize pane" in action:
                    mode_activators["resize_pane"] = key

        save_y = pdf.get_y()

        copy_label = "Copy Mode"
        if "copy_mode" in mode_activators:
            copy_label += f"  ({mode_activators['copy_mode']})"
        pdf.add_section(copy_label, copy_mode_rows, left)

        pdf.set_y(save_y)
        search_label = "Search Mode"
        if "search" in mode_activators:
            search_label += f"  ({mode_activators['search']})"
        pdf.add_section(search_label, search_mode_rows, right)

        if resize_font_rows:
            font_label = "Resize Font"
            if "resize_font" in mode_activators:
                font_label += f"  ({mode_activators['resize_font']})"
            pdf.add_section(font_label, resize_font_rows, right)
        if resize_pane_rows:
            pane_label = "Resize Pane"
            if "resize_pane" in mode_activators:
                pane_label += f"  ({mode_activators['resize_pane']})"
            pdf.add_section(pane_label, resize_pane_rows, right)

    # Footer on each page
    for page in range(1, pdf.pages.__len__() + 1):
        pdf.page = page
        pdf.set_y(pdf.h - 8)
        pdf.set_font("Helvetica", "I", 6)
        pdf.set_text_color(*pdf.SUBTEXT)
        pdf.cell(
            0, 4,
            f"Generated from wezterm show-keys   |   Page {page}/{pdf.pages.__len__()}",
            align="C",
        )

    output = sys.argv[1] if len(sys.argv) > 1 else "wezterm-cheatsheet.pdf"
    pdf.output(output)
    print(f"PDF saved to: {output}")


if __name__ == "__main__":
    main()
