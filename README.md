# dns-propagation-check.sh

## Description

Ce script Bash interactif vérifie la bonne configuration et la propagation DNS pour un domaine principal et son wildcard, étape essentielle avant le déploiement d’un site multisite ou d’une infrastructure web avancée.

Il guide l’utilisateur pour :
- Créer les enregistrements DNS nécessaires chez le registrar (A,AAAA, CNAME, wildcard A & AAAA)
- Saisir le domaine et l’adresse IP cible
- Vérifier automatiquement, via des requêtes DNS, que le domaine principal et un sous-domaine wildcard pointent bien vers l’IP attendue

Le script s’arrête si la propagation n’est pas effective, évitant ainsi toute erreur lors des étapes suivantes du déploiement.

## Fonctionnalités

- Instructions claires pour la configuration DNS chez le registrar
- Vérification automatique de la propagation DNS (domaine principal et wildcard)
- Boucle de vérification avec attente et relance jusqu’à propagation effective ou timeout
- Affichage explicite de l’état de chaque vérification

## Prérequis

- Bash
- Le paquet `dnsutils` (pour la commande `dig`) :

sudo apt install dnsutils


## Utilisation

chmod +x dns-propagation-check.sh
./dns-propagation-check.sh

Le script vous demandera :
- Le nom du domaine principal (ex : mondomaine.com)
- L’adresse IP de votre VPS

Il vous rappellera les enregistrements à créer chez votre registrar, puis vérifiera la propagation DNS pour :
- Le domaine principal
- Un sous-domaine de test (pour le wildcard, ex : test.mondomaine.com)

## Exemple de sortie
=== Configuration DNS requise ===

Ajoutez chez votre registrar (OVH, Gandi, etc.) :

Un enregistrement A pour le domaine principal (ex: mondomaine.com) vers l'IP de votre VPS

Un enregistrement CNAME pour www vers votre domaine principal

Un enregistrement A wildcard (*.mondomaine.com) vers l'IP de votre VPS (pour multisite sous-domaines)
Entrez le domaine principal (ex: mondomaine.com) : mondomaine.com
Entrez l'adresse IP de votre VPS : 192.0.2.10
Vérification automatique de la propagation DNS pour mondomaine.com et *.mondomaine.com...
✅ mondomaine.com pointe bien vers 192.0.2.10.
Test du wildcard avec le sous-domaine test.mondomaine.com...
✅ test.mondomaine.com pointe bien vers 192.0.2.10.
La propagation DNS est confirmée pour mondomaine.com et test.mondomaine.com.

Fonctionnalités ajoutées :
Support IPv6 : Vérifie les enregistrements AAAA si une IPv6 est fournie

Gestion des wildcards : Contrôle à la fois les enregistrements A et AAAA pour les sous-domaines

Détection automatique : Regex unique pour IPv4 (192.168.1.1) et IPv6 (2001:db8::1)

Sortie claire : Indique le type d'enregistrement vérifié (A/AAAA) et l'état de chaque check

chmod +x dns-check.sh
./dns-check.sh

# Sortie :
# ✅ A pour mondomaine.com pointe vers 92.184.123.123
# ✅ AAAA pour mondomaine.com pointe vers 2001:db8::1
# ✅ A pour test.mondomaine.com pointe vers 92.184.123.123
# ✅ AAAA pour test.mondomaine.com pointe vers 2001:db8::1
# === Tous les enregistrements DNS sont valides ===


