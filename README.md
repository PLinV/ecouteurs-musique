# ecouteurs-musique

Garde mes écouteurs Bluetooth en **mode musique** (A2DP : stéréo, bonne qualité) sous Linux,
au lieu du mode appel (HFP : mono, qualité téléphone, boutons qui ne marchent plus).

## Le problème

Parfois la connexion musique échoue (souvent quand les écouteurs sont aussi connectés au téléphone).
Les écouteurs retombent alors en mode appel :

- le son passe en mono, en qualité « téléphone » ;
- les boutons envoient « raccrocher » (`AT+CHUP`) au lieu de lecture / pause.

Dans les journaux, ça ressemble à : `Acquire … returned error: org.bluez.Error.Failed`.

## Ce que ça fait

1. **Config WirePlumber** : à la connexion, seul le profil musique est activé, et le système ne bascule plus
   tout seul en mode appel quand une appli ouvre le micro.
2. **Script de réparation**, lancé toutes les 30 s par un timer systemd : si les écouteurs sont en mode appel
   alors qu'aucune appli n'utilise de micro, il les reconnecte pour retrouver le mode musique
   (coupure du son d'environ 3 s). Pendant une visio ou un appel, il ne touche à rien.

## Prérequis

- Linux avec **PipeWire + WirePlumber 0.5** (Debian 13, Ubuntu 24.04+, Fedora…) : `wireplumber --version`
- `bluetoothctl`, `pw-dump` et `python3` (installés par défaut avec PipeWire et BlueZ)
- Écouteurs déjà appairés au PC

## Installation

```bash
git clone git@github.com:PLinV/ecouteurs-musique.git
cd ecouteurs-musique
./install.sh
```

C'est tout : le timer démarre tout seul à chaque ouverture de session, rien à relancer après un redémarrage.

> Ce sont **mes** écouteurs qui sont configurés. Pour d'autres, voir [Utiliser d'autres écouteurs](#utiliser-dautres-écouteurs).

## Vérifier que ça tourne

```bash
systemctl --user list-timers ecouteurs-musique.timer   # une heure dans NEXT = actif
journalctl --user -u ecouteurs-musique -n 20           # ce que fait le script
DRY_RUN=1 ./ecouteurs-musique                          # diagnostic sans rien changer
```

`profil=a2dp-sink` : mode musique, tout va bien. `profil=headset-head-unit` : mode appel.

## Mettre à jour

Après avoir modifié un fichier du dossier :

```bash
./install.sh
```

## Désinstaller

```bash
./uninstall.sh
```

## Réparer à la main

Si le son redevient mauvais et que tu ne veux pas attendre le timer :

```bash
bluetoothctl disconnect 04:C8:B0:2E:23:A7 && bluetoothctl connect 04:C8:B0:2E:23:A7
```

## Utiliser d'autres écouteurs

1. Trouve leur adresse : `bluetoothctl devices`
2. Remplace `04:C8:B0:2E:23:A7` par cette adresse :
   - dans `ecouteurs-musique` (variable `MAC`) ;
   - dans `wireplumber/51-ecouteurs-musique.conf` (`device.name`, avec des `_` à la place des `:`).
3. Relance `./install.sh`

## Fichiers

| Fichier | Installé dans |
|---|---|
| `ecouteurs-musique` | `~/.local/bin/` |
| `systemd/ecouteurs-musique.service` | `~/.config/systemd/user/` |
| `systemd/ecouteurs-musique.timer` | `~/.config/systemd/user/` |
| `wireplumber/51-ecouteurs-musique.conf` | `~/.config/wireplumber/wireplumber.conf.d/` |

## Limite

Le micro des écouteurs n'est plus activé automatiquement. Pour un appel, choisis le profil
« Headset / Casque » à la main dans **Paramètres → Son**.
