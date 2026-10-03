
# Linux ZRAM

Prosty konfigurator ZRAM dla systemów Linux opartych na APT, takich jak Ubuntu, Debian i Zorin OS.

Projekt służy wyłącznie do konfiguracji ZRAM.

## Funkcje

- Wybór rozmiaru ZRAM z menu.
- Dostępne rozmiary: 8, 16, 24, 32, 48 i 64 GiB.
- Możliwość podania własnego rozmiaru.
- Kompresja ZSTD.
- Priorytet swap: 100.
- Automatyczna instalacja `systemd-zram-generator`, jeśli nie jest zainstalowany.
- Kopia zapasowa poprzedniej konfiguracji.
- Nie usuwa ani nie wyłącza istniejącego swapu na dysku.

## Instalacja

Sklonuj repozytorium:

```bash
git clone https://github.com/Pioter1236/linux-ZRAM.git
cd linux-ZRAM
```

Nadaj skryptowi uprawnienia wykonywania:

```bash
chmod +x configure-zram.sh
```

Uruchom konfigurator:

```bash
sudo ./configure-zram.sh
```

## Wybór rozmiaru

Po uruchomieniu pojawi się menu:

```text
1)  8 GiB
2) 16 GiB
3) 24 GiB
4) 32 GiB
5) 48 GiB
6) 64 GiB
7) Własny rozmiar
```

Wybierz numer i potwierdź zapisanie konfiguracji.

## Zastosowanie konfiguracji

Po zapisaniu konfiguracji wymagany jest restart systemu:

```bash
sudo reboot
```

## Sprawdzanie działania

Rozmiar i wykorzystanie ZRAM:

```bash
zramctl
```

Aktywne urządzenia swap:

```bash
swapon --show
```

Podgląd na żywo:

```bash
watch -n 1 zramctl
```

## Ważne informacje

ZRAM jest skompresowanym obszarem wymiany przechowywanym w pamięci RAM. Podany rozmiar jest pojemnością logiczną, a nie ilością fizycznego RAM-u rezerwowaną od razu.

Rzeczywisty współczynnik kompresji zależy od danych. Przykładowe 4:1 nie jest gwarantowane.

Priorytet 100 sprawia, że ZRAM jest preferowany przed swapem o niższym priorytecie. Istniejący swap dyskowy pozostaje oddzielnym urządzeniem i nie jest modyfikowany przez ten projekt.
