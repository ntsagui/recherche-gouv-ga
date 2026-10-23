#!/usr/bin/env bash
# check-ga-php.sh — Teste en direct les domaines gabonais et détecte PHP / le CMS.
#
# Usage :
#   ./scripts/check-ga-php.sh                 # lit les domaines depuis domaines-gouv-ga.csv
#   ./scripts/check-ga-php.sh budget.gouv.ga sante.gouv.ga   # ou une liste explicite
#
# Sortie :
#   - un tableau lisible sur la sortie standard
#   - un fichier resultats-live.csv (domaine,http,server,x_powered_by,cms,php,indices)
#
# Aucune intrusion : le script ne fait que des requêtes HTTP(S) normales (comme un
# navigateur) sur la page d'accueil, et lit les en-têtes + le HTML public.
# Nécessite : bash, curl. À lancer depuis une machine qui atteint les sites
# (réseau sortant ouvert, DNS .ga résolu — p. ex. au Gabon).

set -u
UA="Mozilla/5.0 (compatible; inventaire-gouv-ga/1.0)"
TIMEOUT=25
OUT="resultats-live.csv"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
CSV="$HERE/domaines-gouv-ga.csv"

# --- Construire la liste des domaines -------------------------------------
domains=()
if [ "$#" -gt 0 ]; then
  domains=("$@")
elif [ -f "$CSV" ]; then
  # 1re colonne, sans l'en-tête
  while IFS=',' read -r d _rest; do
    [ "$d" = "domaine" ] && continue
    [ -z "$d" ] && continue
    domains+=("$d")
  done < "$CSV"
else
  echo "Aucun domaine fourni et $CSV introuvable." >&2
  exit 1
fi

echo "domaine,http,server,x_powered_by,cms,php,indices" > "$OUT"
printf '%-34s %-5s %-14s %-16s %-11s %-6s %s\n' "DOMAINE" "HTTP" "SERVER" "X-POWERED-BY" "CMS" "PHP" "INDICES"
printf '%0.s-' {1..120}; echo

for d in "${domains[@]}"; do
  d="$(echo "$d" | tr -d '[:space:]')"
  hdr="$(mktemp)"; body="$(mktemp)"
  # GET en suivant les redirections ; -D dump les en-têtes, -o le corps
  code="$(curl -sSL --max-time "$TIMEOUT" -A "$UA" \
            -D "$hdr" -o "$body" -w '%{http_code}' "https://$d/" 2>/dev/null)"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    printf '%-34s %-5s %-14s %-16s %-11s %-6s %s\n' "$d" "ERR" "-" "-" "-" "?" "curl rc=$rc (injoignable/DNS/TLS)"
    echo "$d,ERR,,,,?,curl_rc=$rc" >> "$OUT"
    rm -f "$hdr" "$body"; continue
  fi

  server="$(grep -i '^server:'        "$hdr" | tail -1 | cut -d: -f2- | tr -d '\r' | sed 's/^ *//')"
  xpb="$(   grep -i '^x-powered-by:'  "$hdr" | tail -1 | cut -d: -f2- | tr -d '\r' | sed 's/^ *//')"
  xgen="$(  grep -i '^x-generator:'   "$hdr" | tail -1 | cut -d: -f2- | tr -d '\r' | sed 's/^ *//')"
  cookies="$(grep -i '^set-cookie:'   "$hdr" | tr -d '\r')"

  hints=""
  php="indetermine"
  cms="inconnu"

  # --- Signaux PHP (en-têtes) ---
  echo "$xpb" | grep -qi 'php'       && { php="oui"; hints="$hints x-powered-by:php"; }
  echo "$cookies" | grep -qi 'PHPSESSID' && { php="oui"; hints="$hints PHPSESSID"; }

  # --- CMS (balise generator / en-tête / chemins d'assets dans le HTML) ---
  gen="$(grep -io '<meta[^>]*name=["'\'']generator["'\''][^>]*>' "$body" | head -1)"
  if echo "$gen $xgen" | grep -qi 'wordpress'; then cms="WordPress"; php="oui"; hints="$hints generator:WordPress"; fi
  if echo "$gen $xgen" | grep -qi 'joomla';    then cms="Joomla";    php="oui"; hints="$hints generator:Joomla"; fi
  if echo "$gen $xgen" | grep -qi 'drupal';    then cms="Drupal";    php="oui"; hints="$hints generator:Drupal"; fi

  if [ "$cms" = "inconnu" ]; then
    if grep -qiE 'wp-content|wp-includes|/wp-json' "$body"; then cms="WordPress"; php="oui"; hints="$hints wp-content"; fi
  fi
  if [ "$cms" = "inconnu" ]; then
    if grep -qiE '/media/system/|index\.php\?option=com_|/templates/[a-z0-9_-]+/' "$body"; then cms="Joomla"; php="oui"; hints="$hints joomla-paths"; fi
  fi
  if [ "$cms" = "inconnu" ]; then
    if grep -qiE '/sites/default/files|\?q=node/|data-drupal' "$body"; then cms="Drupal"; php="oui"; hints="$hints drupal-paths"; fi
  fi

  # Lien en .php visible => PHP (sans CMS identifié)
  if [ "$php" = "indetermine" ] && grep -qiE 'href=["'\''][^"'\'' ]*\.php' "$body"; then
    php="oui"; hints="$hints lien.php"
  fi

  [ -z "$server" ] && server="-"
  [ -z "$xpb" ]    && xpb="-"
  [ -z "$hints" ]  && hints="-"

  printf '%-34s %-5s %-14.14s %-16.16s %-11s %-6s %s\n' "$d" "$code" "$server" "$xpb" "$cms" "$php" "$hints"
  echo "$d,$code,\"$server\",\"$xpb\",$cms,$php,\"$(echo "$hints" | sed 's/^ *//')\"" >> "$OUT"
  rm -f "$hdr" "$body"
done

echo
echo "Résultats détaillés écrits dans : $OUT"
