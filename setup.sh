#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$HOME/.tmux/plugins"
CONFIG="$HOME/.tmux.conf"

log() { printf '\n==> %s\n' "$*"; }
fail() { printf 'Erreur : %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || fail "git est necessaire. Installe git puis relance ce script."
command -v tmux >/dev/null 2>&1 || fail "tmux est necessaire (version >= 3.2). Installe tmux puis relance ce script."
[[ -f "$REPO_DIR/tmux.conf" ]] || fail "tmux.conf introuvable a cote du script."

mkdir -p "$PLUGINS_DIR"

# Idempotence : ne remplacer la configuration que si elle differe.
if [[ -f "$CONFIG" ]] && ! cmp -s "$REPO_DIR/tmux.conf" "$CONFIG"; then
  BACKUP="$CONFIG.backup.$(date +%Y%m%d-%H%M%S)"
  # Evite une collision rare de sauvegarde lors de relancements rapproches.
  while [[ -e "$BACKUP" ]]; do BACKUP="$BACKUP.bak"; done
  cp -p "$CONFIG" "$BACKUP"
  log "Configuration precedente sauvegardee dans $BACKUP"
fi
if [[ ! -f "$CONFIG" ]] || ! cmp -s "$REPO_DIR/tmux.conf" "$CONFIG"; then
  cp "$REPO_DIR/tmux.conf" "$CONFIG"
  log "Configuration installee dans $CONFIG"
else
  log "Configuration deja a jour"
fi

clone_if_missing() {
  local url="$1" target="$2" version="${3:-}"
  if [[ -d "$target/.git" ]]; then
    log "Deja present : $target (utilise TPM pour mettre a jour)"
  elif [[ -e "$target" ]]; then
    fail "$target existe mais n'est pas un depot git. Verifie ce dossier manuellement."
  else
    log "Installation de $(basename "$target")"
    if [[ -n "$version" ]]; then
      git clone --depth 1 --branch "$version" "$url" "$target"
    else
      git clone --depth 1 "$url" "$target"
    fi
  fi
}

clone_if_missing 'https://github.com/tmux-plugins/tpm.git' "$PLUGINS_DIR/tpm"
clone_if_missing 'https://github.com/catppuccin/tmux.git' "$PLUGINS_DIR/tmux" 'v2.3.2'
clone_if_missing 'https://github.com/tmux-plugins/tmux-cpu.git' "$PLUGINS_DIR/tmux-cpu"

if [[ -n "${TMUX:-}" ]]; then
  log "Rechargement de la configuration dans tmux"
  tmux source-file "$CONFIG"
elif tmux list-sessions >/dev/null 2>&1; then
  log "Rechargement du serveur tmux existant"
  tmux source-file "$CONFIG"
else
  log "Aucun serveur tmux actif : la config sera chargee au prochain lancement."
fi

cat <<'MESSAGE'

Installation terminee !
- Lance : tmux
- Plugins : Ctrl+B puis I (majuscule) pour installer/actualiser via TPM
- Mise a jour des plugins : Ctrl+B puis U (majuscule)
- GPU : le plugin tmux-cpu requiert nvidia-smi (NVIDIA) pour afficher son activite.
- Presse-papiers : OSC 52 doit etre pris en charge par ton terminal.
MESSAGE
