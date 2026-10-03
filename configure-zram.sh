
#!/usr/bin/env bash
set -euo pipefail

CONFIG="/etc/systemd/zram-generator.conf"

if [[ $EUID -ne 0 ]]; then
    echo "Uruchom skrypt przez sudo:"
    echo "sudo ./configure-zram.sh"
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Ten skrypt wymaga systemu opartego na APT (np. Ubuntu, Debian, Zorin OS)."
    exit 1
fi

echo "=================================="
echo "       LINUX ZRAM CONFIGURATOR"
echo "=================================="
echo
echo "Wybierz rozmiar ZRAM:"
echo
echo "  1)  8 GiB"
echo "  2) 16 GiB"
echo "  3) 24 GiB"
echo "  4) 32 GiB"
echo "  5) 48 GiB"
echo "  6) 64 GiB"
echo "  7) Własny rozmiar"
echo
read -r -p "Twój wybór [1-7]: " choice

case "$choice" in
    1) ZRAM_SIZE=8192 ;;
    2) ZRAM_SIZE=16384 ;;
    3) ZRAM_SIZE=24576 ;;
    4) ZRAM_SIZE=32768 ;;
    5) ZRAM_SIZE=49152 ;;
    6) ZRAM_SIZE=65536 ;;
    7)
        read -r -p "Podaj rozmiar w GiB (np. 12): " custom_size
        if [[ ! "$custom_size" =~ ^[1-9][0-9]*$ ]]; then
            echo "Nieprawidłowy rozmiar."
            exit 1
        fi
        ZRAM_SIZE=$((custom_size * 1024))
        ;;
    *)
        echo "Nieprawidłowy wybór."
        exit 1
        ;;
esac

echo
echo "Wybrany rozmiar: $((ZRAM_SIZE / 1024)) GiB"
echo "Kompresja: ZSTD"
echo "Priorytet swap: 100"
echo

read -r -p "Czy zapisać konfigurację? [t/N]: " confirm
if [[ ! "$confirm" =~ ^[tT]$ ]]; then
    echo "Anulowano."
    exit 0
fi

echo
echo "Sprawdzanie systemd-zram-generator..."

if ! dpkg -s systemd-zram-generator >/dev/null 2>&1; then
    apt-get update
    apt-get install -y systemd-zram-generator
fi

if [[ -f "$CONFIG" ]]; then
    BACKUP="${CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
    cp -a "$CONFIG" "$BACKUP"
    echo "Poprzednia konfiguracja zapisana w:"
    echo "$BACKUP"
fi

cat > "$CONFIG" <<EOF
[zram0]
zram-size = ${ZRAM_SIZE}
compression-algorithm = zstd
swap-priority = 100
EOF

systemctl daemon-reload

echo
echo "=================================="
echo "      KONFIGURACJA ZAPISANA"
echo "=================================="
echo
cat "$CONFIG"
echo
echo "Aby zastosować nowy rozmiar, uruchom ponownie komputer:"
echo
echo "sudo reboot"
echo
echo "Po restarcie sprawdź:"
echo "zramctl"
echo "swapon --show"
