#!/usr/bin/env python3
import os 
import sys

ICON_MAP = {
    "spotify-launcher.desktop": "spotifyV2",
    "zen.desktop": "zen_1",
    "slack.desktop": "slack_white",
    "postman.desktop": "postman_2",
    "obsidian.desktop": "obsidianV2",
    "org.kde.okular.desktop": "okular_1",
    "org.wezfurlong.wezterm.desktop": "zen_white",
    "com.obsproject.Studio.desktop": "obs_1"
}

BASE_PATH = "/usr/share/applications"

def update_icon(desktop_file, new_icon):
    file_path = os.path.join(BASE_PATH, desktop_file)

    if not os.path.exists(file_path):
        print(f"[!] No se encontró: {file_path}")
        return

    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()

        with open(file_path, 'w') as file:
            changed = False
            for line in lines:
                if line.startswith("Icon="):
                    file.write(f"Icon={new_icon}\n")
                    changed = True
                else:
                    file.write(line)
            if changed:
                print(f"[+] Actualizado: {file_path} con Icon={new_icon}")
            else:
                file.write(f"Icon={new_icon}\n")
                print(f"[+] Línea Icon agregada a: {desktop_file}")
    except Exception as e:
        print(f"[X] Error procesando {desktop_file}: {e}")

if __name__ == "__main__":
    if os.getuid() != 0:
        print("Debes ejecutar este script como root (sudo python update_icons.py)")
        sys.exit(1)
        
    for desktop, icon in ICON_MAP.items():
        update_icon(desktop, icon)
    
    print("\nProceso terminado. Es posible que debas reiniciar tu entorno o dock.")
