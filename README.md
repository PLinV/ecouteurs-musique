# ecouteurs-musique

Garde mes écouteurs Bluetooth en **mode musique** (A2DP, stéréo, bonne qualité) sous Linux
(PipeWire + WirePlumber 0.5), au lieu du mode appel (HFP, mono, qualité téléphone).

## Le problème

Parfois la connexion musique échoue (`Acquire … returned error: org.bluez.Error.Failed` dans les
journaux, souvent quand les écouteurs sont aussi connectés au téléphone). Les écouteurs retombent alors
en mode appel :

- le son passe en mono, en qualité « téléphone » ;
- les boutons envoient « raccrocher » (`AT+CHUP`) au lieu de lecture / pause.

## Ce que ça installe

| Fichier | Rôle |
|---|---|
| `wireplumber/51-ecouteurs-musique.conf` | Ne bascule plus en mode appel quand une appli ouvre le micro, et n'active que le profil musique à la connexion |
| `ecouteurs-musique` | Si les écouteurs sont en mode appel sans qu'aucune appli n'utilise de micro, les reconnecte pour retrouver le mode musique |
| `systemd/ecouteurs-musique.timer` | Lance le script toutes les 30 s |

## Installer / mettre à jour

```bash
./install.sh
```

## Désinstaller

```bash
./uninstall.sh
```

## Vérifier

```bash
journalctl --user -u ecouteurs-musique -n 20   # ce que fait le script
DRY_RUN=1 ./ecouteurs-musique                  # diagnostic sans rien changer
```

## Autres écouteurs

L'adresse Bluetooth est en dur : change `MAC` dans `ecouteurs-musique` et `device.name` dans
`wireplumber/51-ecouteurs-musique.conf` (les `:` deviennent des `_`), puis relance `./install.sh`.
L'adresse s'obtient avec `bluetoothctl devices`.
