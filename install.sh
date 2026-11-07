#!/usr/bin/env bash
# Installe (ou met à jour) la config des écouteurs pour l'utilisateur courant.
# Relance-le après chaque modification d'un fichier de ce dossier.
set -euo pipefail
cd "$(dirname "$0")"

install -Dm755 ecouteurs-musique ~/.local/bin/ecouteurs-musique
install -Dm644 systemd/ecouteurs-musique.service ~/.config/systemd/user/ecouteurs-musique.service
install -Dm644 systemd/ecouteurs-musique.timer ~/.config/systemd/user/ecouteurs-musique.timer
install -Dm644 wireplumber/51-ecouteurs-musique.conf ~/.config/wireplumber/wireplumber.conf.d/51-ecouteurs-musique.conf

systemctl --user daemon-reload
systemctl --user enable --now ecouteurs-musique.timer
systemctl --user restart wireplumber

echo "✓ Installé. Le son peut se couper une seconde (redémarrage de WirePlumber)."
