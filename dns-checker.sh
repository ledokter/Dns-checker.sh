# === ETAPE DNS : Configuration et validation ===

echo "=== Configuration DNS requise ==="
echo "- Ajoutez chez votre registrar (OVH, Gandi, etc.) :"
echo "    • Un enregistrement A pour le domaine principal (ex: mondomaine.com) vers l'IP de votre VPS"
echo "    • Un enregistrement CNAME pour www vers votre domaine principal"
echo "    • Un enregistrement A wildcard (*.mondomaine.com) vers l'IP de votre VPS (pour multisite sous-domaines)"
read -p "Entrez le domaine principal (ex: mondomaine.com) : " DOMAIN
read -p "Entrez l'adresse IP de votre VPS : " IP

echo
echo "Vérification automatique de la propagation DNS pour $DOMAIN et *.${DOMAIN}..."
# Fonction de vérification DNS propagation pour un domaine
check_dns() {
    local domain="$1"
    local expected_ip="$2"
    local max_attempts=15
    local delay=20
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        resolved_ip=$(dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)
        if [[ "$resolved_ip" == "$expected_ip" ]]; then
            echo "✅ $domain pointe bien vers $expected_ip."
            return 0
        else
            echo "⏳ Tentative $attempt/$max_attempts : $domain pointe vers $resolved_ip (attendu: $expected_ip)."
            sleep $delay
        fi
        attempt=$((attempt+1))
    done
    echo "❌ Propagation DNS non terminée pour $domain. Veuillez réessayer plus tard."
    exit 1
}

# Vérification du domaine principal
check_dns "$DOMAIN" "$IP"

# Vérification du wildcard (exemple : test.mondomaine.com)
WILDCARD_SUB="test.${DOMAIN}"
echo "Test du wildcard avec le sous-domaine $WILDCARD_SUB..."
check_dns "$WILDCARD_SUB" "$IP"

echo "La propagation DNS est confirmée pour $DOMAIN et $WILDCARD_SUB."
