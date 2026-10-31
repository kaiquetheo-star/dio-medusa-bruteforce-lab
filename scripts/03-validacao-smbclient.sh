#!/usr/bin/env bash
# ============================================================
#  Fase 4 — Validação do acesso com smbclient (Kali Linux)
#  Desafio DIO: força bruta SMB com Medusa
#
#  Uso:  ./03-validacao-smbclient.sh <IP_DO_ALVO> [USUARIO] [SENHA]
#  Ex.:  ./03-validacao-smbclient.sh 192.168.56.20 msfadmin msfadmin
#
#  ⚠️  Credencial na linha de comando SOMENTE em laboratório!
#      Em teste real, prefira o prompt interativo (sem a senha no comando).
# ============================================================

TARGET="${1:?Uso: $0 <IP_do_alvo> [USUARIO] [SENHA]}"
USER_FOUND="${2:-msfadmin}"
PASS_FOUND="${3:-msfadmin}"

echo "[*] Alvo: $TARGET  |  Credencial em teste: $USER_FOUND"
echo "[*] 1/2 — Listando compartilhamentos acessíveis..."
echo "----------------------------------------------------------"
smbclient -L //"$TARGET"/ -U "$USER_FOUND%$PASS_FOUND"
echo "----------------------------------------------------------"

echo
echo "[*] 2/2 — Acessando o share 'tmp' e listando arquivos..."
echo "----------------------------------------------------------"
smbclient //"$TARGET"/tmp -U "$USER_FOUND%$PASS_FOUND" -c 'ls'
echo "----------------------------------------------------------"

echo
echo "[+] Se os comandos acima listaram shares e arquivos sem erro de"
echo "    autenticação (NT_STATUS_LOGON_FAILURE), o acesso está CONFIRMADO."
echo "    Registrar isso no README encerra o ciclo: ataque -> validação -> evidência."
