#!/usr/bin/env -S\_/bin/sh\_-c\_"source\_\$(eval\_echo\_\$ILLOGICAL_IMPULSE_VIRTUAL_ENV)/bin/activate&&exec\_python\_-E\_"\$0"\_"\$@""
import argparse
import re
import os
from os.path import expandvars as os_expandvars
from typing import Dict, List

VAR_ASSIGN_REGEX = re.compile(r"^\s*\$([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$")
SOURCE_REGEX = re.compile(r"^\s*source\s*=\s*(.*?)\s*$")
VAR_REF_REGEX = re.compile(r"\$([A-Za-z_][A-Za-z0-9_]*)")

HIDDEN_DISPATCHERS = {
    "workspace",
    "movetoworkspace",
    "movetoworkspacesilent",
    "togglespecialworkspace",
    "movecurrentworkspacetomonitor",
    "focusworkspaceoncurrentmonitor",
}

TITLE_REGEX = "#+!"
HIDE_COMMENT = "[hidden]"
MOD_SEPARATORS = ['+', ' ']
COMMENT_BIND_PATTERN = "#/#"

parser = argparse.ArgumentParser(description='Hyprland keybind reader')
parser.add_argument('--path', type=str, default="$HOME/.config/hypr/hyprland.conf", help='path to keybind file (sourcing isn\'t supported)')
args = parser.parse_args()
content_lines = []
reading_line = 0

# Little Parser made for hyprland keybindings conf file
Variables: Dict[str, str] = {}


class KeyBinding(dict):
    def __init__(self, mods, key, dispatcher, params, comment) -> None:
        self["mods"] = mods
        self["key"] = key
        self["dispatcher"] = dispatcher
        self["params"] = params
        self["comment"] = comment

class Section(dict):
    def __init__(self, children, keybinds, name) -> None:
        self["children"] = children
        self["keybinds"] = keybinds
        self["name"] = name


def read_content(path: str) -> str:
    if (not os.access(os.path.expanduser(os.path.expandvars(path)), os.R_OK)):
        return ("error")
    with open(os.path.expanduser(os.path.expandvars(path)), "r") as file:
        return file.read()


def _strip_comment_for_assignments(line: str) -> str:
    # Hyprland uses # for comments. For variable/source parsing, trim inline comments.
    return line.split("#", 1)[0].rstrip()


def _expand_text(text: str) -> str:
    expanded = os_expandvars(text)

    def repl(match: re.Match) -> str:
        var_name = match.group(1)
        return Variables.get(var_name, match.group(0))

    # Resolve nested references with a small cap.
    for _ in range(6):
        next_expanded = VAR_REF_REGEX.sub(repl, expanded)
        if next_expanded == expanded:
            break
        expanded = next_expanded
    return expanded


def _resolve_source_path(base_file: str, source_path: str) -> str:
    source_path = _expand_text(source_path).strip().strip('"').strip("'")
    source_path = os.path.expanduser(source_path)
    source_path = os.path.expandvars(source_path)
    if os.path.isabs(source_path):
        return source_path
    return os.path.normpath(os.path.join(os.path.dirname(base_file), source_path))


def collect_variables(path: str, visited: set[str] | None = None) -> None:
    if visited is None:
        visited = set()

    path = os.path.expanduser(os.path.expandvars(path))
    path = os.path.abspath(path)
    if path in visited:
        return
    visited.add(path)

    content = read_content(path)
    if content == "error":
        return

    for raw_line in content.splitlines():
        line = _strip_comment_for_assignments(raw_line)
        if not line:
            continue

        var_match = VAR_ASSIGN_REGEX.match(line)
        if var_match:
            key = var_match.group(1)
            value = _expand_text(var_match.group(2).strip())
            Variables[key] = value
            continue

        source_match = SOURCE_REGEX.match(line)
        if source_match:
            source_path = _resolve_source_path(path, source_match.group(1))
            collect_variables(source_path, visited)


def autogenerate_comment(dispatcher: str, params: str = "") -> str:
    match dispatcher:

        case "resizewindow":
            return "Resize window"

        case "movewindow":
            if(params == ""):
                return "Move window"
            else:
                return "Window: move in {} direction".format({
                    "l": "left",
                    "r": "right",
                    "u": "up",
                    "d": "down",
                }.get(params, "null"))

        case "pin":
            return "Window: pin (show on all workspaces)"

        case "splitratio":
            return "Window split ratio {}".format(params)

        case "togglefloating":
            return "Float/unfloat window"

        case "resizeactive":
            return "Resize window by {}".format(params)

        case "killactive":
            return "Close window"

        case "fullscreen":
            return "Toggle {}".format(
                {
                    "0": "fullscreen",
                    "1": "maximization",
                    "2": "fullscreen on Hyprland's side",
                }.get(params, "null")
            )

        case "fakefullscreen":
            return "Toggle fake fullscreen"

        case "workspace":
            if params == "+1":
                return "Workspace: focus right"
            elif params == "-1":
                return "Workspace: focus left"
            return "Focus workspace {}".format(params)

        case "movefocus":
            return "Window: move focus {}".format(
                {
                    "l": "left",
                    "r": "right",
                    "u": "up",
                    "d": "down",
                }.get(params, "null")
            )

        case "swapwindow":
            return "Window: swap in {} direction".format(
                {
                    "l": "left",
                    "r": "right",
                    "u": "up",
                    "d": "down",
                }.get(params, "null")
            )

        case "movetoworkspace":
            if params == "+1":
                return "Window: move to right workspace (non-silent)"
            elif params == "-1":
                return "Window: move to left workspace (non-silent)"
            return "Window: move to workspace {} (non-silent)".format(params)

        case "movetoworkspacesilent":
            if params == "+1":
                return "Window: move to right workspace"
            elif params == "-1":
                return "Window: move to right workspace"
            return "Window: move to workspace {}".format(params)

        case "togglespecialworkspace":
            return "Workspace: toggle special"

        case "exec":
            return "Execute: {}".format(params)

        case _:
            return ""

def get_keybind_at_line(line_number, line_start = 0):
    global content_lines
    line = content_lines[line_number]
    _, keys = line.split("=", 1)
    keys, *comment = keys.split("#", 1)

    mods, key, dispatcher, *params = list(map(str.strip, keys.split(",", 4)))
    params = "".join(map(str.strip, params))

    mods = _expand_text(mods)
    key = _expand_text(key)
    dispatcher = _expand_text(dispatcher)
    params = _expand_text(params)

    # Remove empty spaces
    comment = list(map(str.strip, comment))
    # Add comment if it exists, else generate it
    if comment:
        comment = _expand_text(comment[0])
        if comment.startswith("[hidden]"):
            return None
    else:
        comment = autogenerate_comment(dispatcher, params)

    if dispatcher in HIDDEN_DISPATCHERS:
        return None

    if mods:
        modstring = mods + MOD_SEPARATORS[0] # Add separator at end to ensure last mod is read
        mods = []
        p = 0
        for index, char in enumerate(modstring):
            if(char in MOD_SEPARATORS):
                if(index - p > 1):
                    mods.append(modstring[p:index])
                p = index+1
    else:
        mods = []

    return KeyBinding(mods, key, dispatcher, params, comment)

def get_binds_recursive(current_content, scope):
    global content_lines
    global reading_line
    # print("get_binds_recursive({0}, {1}) [@L{2}]".format(current_content, scope, reading_line + 1))
    while reading_line < len(content_lines): # TODO: Adjust condition
        line = content_lines[reading_line]
        heading_search_result = re.search(TITLE_REGEX, line)
        # print("Read line {0}: {1}\tisHeading: {2}".format(reading_line + 1, content_lines[reading_line], "[{0}, {1}, {2}]".format(heading_search_result.start(), heading_search_result.start() == 0, ((heading_search_result != None) and (heading_search_result.start() == 0))) if heading_search_result != None else "No"))
        if ((heading_search_result != None) and (heading_search_result.start() == 0)): # Found title
            # Determine scope
            heading_scope = line.find('!')
            # Lower? Return
            if(heading_scope <= scope):
                reading_line -= 1
                return current_content

            section_name = line[(heading_scope+1):].strip()
            # print("[[ Found h{0} at line {1} ]] {2}".format(heading_scope, reading_line+1, content_lines[reading_line]))
            reading_line += 1
            current_content["children"].append(get_binds_recursive(Section([], [], section_name), heading_scope))

        elif line.startswith(COMMENT_BIND_PATTERN):
            keybind = get_keybind_at_line(reading_line, line_start=len(COMMENT_BIND_PATTERN))
            if(keybind != None):
                current_content["keybinds"].append(keybind)

        elif line == "" or not line.lstrip().startswith("bind"): # Comment, ignore
            pass

        else: # Normal keybind
            keybind = get_keybind_at_line(reading_line)
            if(keybind != None):
                current_content["keybinds"].append(keybind)

        reading_line += 1

    return current_content;

def parse_keys(path: str) -> Dict[str, List[KeyBinding]]:
    global content_lines
    global Variables

    Variables = {}

    # Best effort: parse sibling hyprland.conf first so keybinds.conf can use shared vars.
    abs_path = os.path.abspath(os.path.expanduser(os.path.expandvars(path)))
    base_name = os.path.basename(abs_path)
    parent_dir = os.path.dirname(abs_path)
    if base_name == "keybinds.conf" and os.path.basename(parent_dir) == "hyprland":
        sibling_root = os.path.normpath(os.path.join(parent_dir, "..", "hyprland.conf"))
        collect_variables(sibling_root)

    collect_variables(abs_path)

    content_lines = read_content(path).splitlines()
    if content_lines[0] == "error":
        return "error"
    return get_binds_recursive(Section([], [], ""), 0)


if __name__ == "__main__":
    import json

    ParsedKeys = parse_keys(args.path)
    print(json.dumps(ParsedKeys))
