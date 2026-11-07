#!/usr/bin/env bash
# Retire tout ce que install.sh a mis en place.
set -euo pipefail

systemctl --user disable --now ecouteurs-musique.timer 2>/dev/null || true
rm -f ~/.local/bin/ecouteurs-musique \
  ~/.config/systemd/user/ecouteurs-musique.service \
  ~/.config/systemd/user/ecouteurs-musique.timer \
  ~/.config/wireplumber/wireplumber.conf.d/51-ecouteurs-musique.conf

systemctl --user daemon-reload
systemctl --user restart wireplumber

echo "✓ Désinstallé."
