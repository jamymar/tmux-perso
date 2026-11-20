# tmux-perso

Configuration portable pour tmux (>= 3.2) avec **Catppuccin Macchiato**, TPM,
CPU/RAM/GPU (GPU NVIDIA si disponible), nom du dossier courant, heure française (Europe/Paris) et souris.
Les raccourcis par défaut de tmux sont conservés (préfixe `Ctrl+B`).

## Installation sur un nouvel appareil

Pré-requis : `git`, `tmux` (version >= 3.2), Bash. Sous macOS, installe-les
par exemple avec Homebrew. Sous Linux, utilise ton gestionnaire de paquets.

```bash
git clone https://github.com/TON-UTILISATEUR/tmux-perso.git
cd tmux-perso
./setup.sh
```

Remplace `TON-UTILISATEUR` par ton identifiant GitHub après avoir publié le dépôt.
Le script sauvegarde une éventuelle configuration différente dans
`~/.tmux.conf.backup.DATE`, installe `~/.tmux.conf`, le script GPU, TPM et ses deux plugins,
puis recharge tmux si un serveur existe. Il peut être relancé.

## Plugins

- `Ctrl+B` puis `I` (majuscule) : installation TPM
- `Ctrl+B` puis `U` (majuscule) : mise à jour TPM

Catppuccin est épinglé sur `v2.3.2` pour une installation reproductible.

## À savoir

- `#{b:pane_current_path}` affiche le **dernier dossier** du chemin courant,
  pas son parent : `/home/lea/dev/projet` devient `projet`.
- La souris permet le défilement et la sélection. La copie dans le presse-papiers
  système via OSC 52 dépend du terminal utilisé. `Ctrl+B` puis `]` colle depuis
  le buffer de tmux.
- L'affichage GPU dépend de `nvidia-smi` (GPU NVIDIA) ; il est automatiquement masqué sur les machines non prises en charge.
- Pour les icônes, utilise de préférence une Nerd Font.

## Publier le repo

Crée un dépôt GitHub **vide** nommé `tmux-perso`, puis depuis ce dossier :

```bash
git init
git add .
git commit -m "Initial tmux setup"
git branch -M main
git remote add origin https://github.com/TON-UTILISATEUR/tmux-perso.git
git push -u origin main
```
