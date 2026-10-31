#!/usr/bin/env bash
# fix-end4.sh: run with: bash ~/fix-end4.sh
set -u
KB=~/.config/hypr/hyprland/keybinds.lua
VENV=~/.local/state/quickshell/.venv
QS=~/.config/quickshell/ii

# 1. Keybinds (Lua syntax): Super+Enter and a working lock bind
cp "$KB" "$KB.bak"
grep -q '"SUPER + Return"' "$KB" || cat >> "$KB" <<'EOF'

-- fix: Super+Enter opens terminal instead of the launcher
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Return", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"))
EOF
grep -q 'lock-session' "$KB" || cat >> "$KB" <<'EOF'

-- fix: lock screen
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))
EOF

# 2. Lock button: find what the shell runs when it is clicked
echo "=== Lock code in the shell (paste this if the button still fails) ==="
grep -rn --include='*.qml' -i 'lock-session\|screenLocked\|lockRequested\|function lock\|hyprlock' "$QS" | head -n 30
echo "=== IPC targets ==="
qs -c ii ipc show 2>/dev/null | grep -i -A3 lock

# 3. Make sure the session is lockable and idle daemon is running
command -v hypridle >/dev/null || sudo pacman -S --needed --noconfirm hypridle
pgrep -x hypridle >/dev/null || (hypridle >/dev/null 2>&1 &)

# 4. Kitty theme errors: rebuild venv, regenerate colours
sudo pacman -S --needed --noconfirm python python-pip
[ -x "$VENV/bin/pip" ] || python -m venv "$VENV"
"$VENV/bin/pip" install -q materialyoucolor pillow numpy opencv-python pywayland
WALL=$(find ~/Pictures -type f \( -iname '*.jpg' -o -iname '*.png' \) | head -n1)
if [ -n "$WALL" ]; then
  source "$VENV/bin/activate"
  "$QS/scripts/colors/switchwall.sh" "$WALL"
  deactivate
else
  echo "No wallpaper found in ~/Pictures, set one from the shell's wallpaper picker."
fi

# 5. Reload everything
hyprctl reload
pkill quickshell 2>/dev/null; sleep 1
(qs -c ii >/tmp/qs.log 2>&1 &)
sleep 3
echo "Now press the lock button, then run: tail -n 30 /tmp/qs.log"
