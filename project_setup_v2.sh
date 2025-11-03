#!/bin/bash
# project_setup.sh - Tworzenie struktury projektu
# Użycie:
#   ./project_setup.sh [-n|--no-readme] <nazwa_projektu> [katalog1 katalog2 ...]
# Przykłady:
#   ./project_setup.sh myproj
#   ./project_setup.sh -n myproj src bin logs
#   ./project_setup.sh --no-readme myproj

set -euo pipefail

# Domyślne katalogi
base_dirs=("src" "tests" "docs" "config")

# Flagi
SKIP_README=0

# Parsowanie opcji prostym sposobem (obsługuje -n i --no-readme oraz -h/--help)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--no-readme)
      SKIP_README=1
      shift
      ;;
    -h|--help)
      cat <<EOF
Użycie:
  $0 [-n|--no-readme] <nazwa_projektu> [katalog1 katalog2 ...]

Opcje:
  -n, --no-readme    Pomija tworzenie README.md
  -h, --help         Pokaż tę pomoc

Jeżeli podasz dodatkowe nazwy katalogów po nazwie projektu, zostaną użyte zamiast domyślnych:
  ./project_setup.sh myproj src bin logs
EOF
      exit 0
      ;;
    --) # koniec opcji
      shift
      break
      ;;
    -*)
      echo "Nieznana opcja: $1"
      exit 1
      ;;
    *) # pierwszy nie-opcyjny argument to nazwa projektu
      break
      ;;
  esac
done

# Sprawdzamy, czy podano nazwę projektu
if [[ $# -eq 0 ]]; then
  echo "Użycie: $0 [-n|--no-readme] <nazwa_projektu> [katalog1 katalog2 ...]"
  exit 1
fi

project_name="$1"
shift

# Jeżeli podano dodatkowe katalogi — używamy ich, w przeciwnym razie domyślne
if [[ $# -gt 0 ]]; then
  project_dirs=("$@")
else
  project_dirs=("${base_dirs[@]}")
fi

# Funkcja do bezpiecznego tworzenia katalogu
create_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    echo "⚠ Katalog $dir już istnieje"
    return 1
  fi
  if mkdir -p "$dir"; then
    echo "✅ Utworzono katalog $dir"
    return 0
  else
    echo "❌ Błąd przy tworzeniu $dir"
    return 1
  fi
}

# Funkcja do tworzenia podstawowego README
create_readme() {
  local project="$1"
  local -n dirs_ref=$2   # przekazujemy nazwę tablicy jako referencję
  cat > "$project/README.md" << EOF
# $project

## O projekcie
Opis projektu

## Struktura
$(for d in "${dirs_ref[@]}"; do echo "- \`$d/\`"; done)

## Instalacja
\`\`\`bash
git clone ...
cd $project
\`\`\`
EOF
  echo "✅ Utworzono README.md"
}

# (opcjonalnie) funkcja tworząca przykładowy plik konfiguracyjny
create_sample_config() {
  local project="$1"
  echo "name=$project" > "$project/config/project.conf" 2>/dev/null || true
  # jeżeli katalog config nie istnieje, create_dir powinien go utworzyć wcześniej
}

# Główna logika
echo "🚀 Tworzenie struktury projektu $project_name..."

# Tworzenie głównego katalogu (jeśli istnieje, informujemy i kończymy)
if ! create_dir "$project_name"; then
  echo "❌ Katalog projektu '$project_name' już istnieje — przerwano."
  exit 1
fi

# Tworzenie podkatalogów
for dir in "${project_dirs[@]}"; do
  create_dir "$project_name/$dir" || true
done

# (opcjonalnie) utwórz przykładowy plik konfiguracyjny jeśli jest katalog config
if printf '%s\n' "${project_dirs[@]}" | grep -qx "config"; then
  create_sample_config "$project_name"
fi

# Tworzenie README (chyba że pominięto)
if [[ $SKIP_README -eq 0 ]]; then
  create_readme "$project_name" project_dirs
else
  echo "ℹ️ Pomijanie tworzenia README.md (flaga --no-readme ustawiona)"
fi

# Inicjalizacja git
if command -v git &>/dev/null; then
  (
    cd "$project_name" || exit 0
    git init &>/dev/null
    echo "✅ Zainicjalizowano repozytorium Git"
  )
else
  echo "ℹ️ git nie jest zainstalowany — pominięto inicjalizację repozytorium"
fi

echo "✨ Projekt $project_name został pomyślnie utworzony!"
