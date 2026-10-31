#!/usr/bin/env bash
# ============================================================
#  Fase 1 — Enumeração do alvo (Kali Linux)
#  Desafio DIO: força bruta SMB com Medusa
#
#  Uso:  ./01-enumeracao.sh <IP_DO_ALVO>
#  Ex.:  ./01-enumeracao.sh 192.168.56.20
# ============================================================

TARGET="${1:?Uso: $0 <IP_do_alvo>}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/results"
mkdir -p "$OUT"

echo "[*] Alvo: $TARGET"
echo "[*] Ferramentas necessárias: nmap, enum4linux (sudo apt install -y nmap enum4linux)"

echo
echo "[*] 1/3 — Portas e versões SMB (139/445)..."
nmap -sV -p 139,445 "$TARGET" | tee "$OUT/01-nmap-smb.txt"

echo
echo "[*] 2/3 — Enumeração de usuários SMB (script NSE)..."
nmap --script smb-enum-users.nse -p 445 "$TARGET" | tee "$OUT/01-smb-enum-users.txt"

echo
echo "[*] 3/3 — Enumeração completa com enum4linux (null session)..."
enum4linux -a "$TARGET" | tee "$OUT/02-enum4linux.txt"

echo
echo "[+] Pronto! Revise os arquivos em results/ e atualize wordlists/users.txt"
echo "    Ex.: echo 'usuario_descoberto' >> wordlists/users.txt"
