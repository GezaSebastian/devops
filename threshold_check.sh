#!/usr/bin/env bash
# threshold_check.sh
# Sprawdza zajętość dysku dla podanej ścieżki i porównuje z progami warn/crit.
# Exit codes: 0=OK, 1=WARNING, 2=CRITICAL, 3=UNKNOWN (błąd)

set -o errexit
set -o nounset
set -o pipefail

LOGFILE="/var/log/threshold_check.log"
: "${LOGFILE:=/tmp/threshold_check.log}"  # fallback jeśli brak prawa do /var/log

print_usage() {
  cat <<USG
Użycie:
  $0 --path /mountpoint --warn 75 --crit 90 [--verbose]

Przykład:
  $0 --path / --warn 80 --crit 95
USG
}

log() {
  local level="$1"; shift
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  # próba zapisu do LOGFILE, jeśli się nie uda, wypisz na stderr
  if ! printf "%s [%s] %s\n" "$ts" "$level" "$*" >> "$LOGFILE" 2>/dev/null; then
    printf "%s [%s] %s\n" "$ts" "$level" "$*" >&2
  fi
}

# Domyślne wartości
PATH_TO_CHECK=""
WARN=""
CRIT=""
VERBOSE=0

# Proste parsowanie argumentów (obsługuje --opt value lub --opt=value)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path=*) PATH_TO_CHECK="${1#*=}"; shift ;;
    --path) PATH_TO_CHECK="$2"; shift 2 ;;
    --warn=*) WARN="${1#*=}"; shift ;;
    --warn) WARN="$2"; shift 2 ;;
    --crit=*) CRIT="${1#*=}"; shift ;;
    --crit) CRIT="$2"; shift 2 ;;
    --verbose) VERBOSE=1; shift ;;
    -h|--help) print_usage; exit 0 ;;
    *) echo "Nieznany argument: $1"; print_usage; exit 3 ;;
  esac
done

# Walidacja wejścia
if [[ -z "$PATH_TO_CHECK" || -z "$WARN" || -z "$CRIT" ]]; then
  log "ERROR" "Brakuje wymaganych parametrów."
  print_usage
  exit 3
fi

# Sprawdź, czy podana ścieżka istnieje
if [[ ! -e "$PATH_TO_CHECK" ]]; then
  log "ERROR" "Ścieżka $PATH_TO_CHECK nie istnieje."
  exit 3
fi

# Sprawdź czy WARN i CRIT są liczbami całkowitymi (0-100)
if ! [[ "$WARN" =~ ^[0-9]+$ ]] || ! [[ "$CRIT" =~ ^[0-9]+$ ]]; then
  log "ERROR" "Progi muszą być liczbami całkowitymi (np. 70). Otrzymano warn='$WARN' crit='$CRIT'."
  exit 3
fi

# logiczna walidacja progów
if (( WARN >= CRIT )); then
  log "ERROR" "Próg ostrzegawczy (--warn=$WARN) musi być mniejszy niż krytyczny (--crit=$CRIT)."
  exit 3
fi

# Pobierz procent zajętości dysku dla danej ścieżki (bez nagłówka)
# Używamy df -P aby wymusić przewidywalne formatowanie
disk_usage_pct=$(df -P "$PATH_TO_CHECK" 2>/dev/null | awk 'NR==2 {gsub(/%/,"",$5); print $5}')
if [[ -z "$disk_usage_pct" ]]; then
  log "ERROR" "Nie udało się odczytać użycia dysku dla $PATH_TO_CHECK."
  exit 3
fi

# Log wejściowy
log "INFO" "Sprawdzam $PATH_TO_CHECK: użycie ${disk_usage_pct}% (warn=$WARN, crit=$CRIT)."
if [[ $VERBOSE -eq 1 ]]; then
  echo "DEBUG: użycie=${disk_usage_pct}%"
fi

# Porównanie z progami i odpowiedni exit code + log
if (( disk_usage_pct >= CRIT )); then
  log "CRITICAL" "Użycie ${disk_usage_pct}% >= ${CRIT}% dla $PATH_TO_CHECK"
  echo "CRITICAL - ${disk_usage_pct}% used on ${PATH_TO_CHECK}"
  exit 2
elif (( disk_usage_pct >= WARN )); then
  log "WARNING" "Użycie ${disk_usage_pct}% >= ${WARN}% dla $PATH_TO_CHECK"
  echo "WARNING - ${disk_usage_pct}% used on ${PATH_TO_CHECK}"
  exit 1
else
  log "OK" "Użycie ${disk_usage_pct}% < ${WARN}% dla $PATH_TO_CHECK"
  echo "OK - ${disk_usage_pct}% used on ${PATH_TO_CHECK}"
  exit 0
fi
