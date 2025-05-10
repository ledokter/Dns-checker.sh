#!/bin/bash

# === Vérification DNS avec support IPv4/IPv6 ===

echo "=== Configuration DNS requise ==="
echo "- Ajoutez chez votre registrar :"
echo "  • Enregistrement A pour ${DOMAIN} → IPv4 du VPS"
echo "  • Enregistrement AAAA pour ${DOMAIN} → IPv6 du VPS (si applicable)"
echo "  • Enregistrement CNAME pour www → ${DOMAIN}"
echo "  • Enregistrement A et AAAA wildcard (*.${DOMAIN}) → IPv4/IPv6 du VPS"

read -p "Entrez le domaine principal (ex: mondomaine.com) : " DOMAIN
read -p "Entrez l'adresse IPv4 de votre VPS : " IPV4
read -p "Entrez l'adresse IPv6 de votre VPS (laisser vide si non utilisé) : " IPV6

check_dns() {
    local domain="$1"
    local record_type="$2"
    local expected_ip="$3"
    local max_attempts=12
    local delay=10
    local attempt=1

    echo "Vérification ${record_type} pour $domain..."
    
    while [ $attempt -le $max_attempts ]; do
        resolved_ip=$(dig +short "$domain" "$record_type" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9a-fA-F:]+)')
        if [[ "$resolved_ip" == "$expected_ip" ]]; then
            echo "✅ ${record_type} pour $domain pointe vers $expected_ip"
            return 0
        else
            echo "⏳ Tentative $attempt/$max_attempts : ${record_type} pour $domain = ${resolved_ip:-Aucun}"
            sleep $delay
        fi
        attempt=$((attempt+1))
    done
    
    echo "❌ Échec de la propagation ${record_type} pour $domain"
    return 1
}

# Vérification IPv4
check_dns "$DOMAIN" "A" "$IPV4" || exit 1

# Vérification IPv6 (si fourni)
if [[ -n "$IPV6" ]]; then
    check_dns "$DOMAIN" "AAAA" "$IPV6" || exit 1
fi

# Vérification wildcard
WILDCARD_TEST="test.${DOMAIN}"
check_dns "$WILDCARD_TEST" "A" "$IPV4" || exit 1

if [[ -n "$IPV6" ]]; then
    check_dns "$WILDCARD_TEST" "AAAA" "$IPV6" || exit 1
fi

echo "=== Tous les enregistrements DNS sont valides ==="
