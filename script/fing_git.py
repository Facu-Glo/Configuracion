#!/usr/bin/env python3
"""
Git Repository Finder - Versión Python
Encuentra repositorios git con configuración JSON flexible

Dependencias recomendadas:
- fd: Para búsqueda rápida (sudo apt install fd-find)
- fzf: Para selección interactiva (sudo apt install fzf)
- eza: Para listado mejorado (cargo install eza)

Si las herramientas no están disponibles, usa fallbacks automáticos:
- fd -> os.walk() (más lento)
- eza -> ls -> Python puro
- fzf -> selección manual numerada
"""

import json
import os
import subprocess
from pathlib import Path
from typing import List, Dict, Optional, Tuple
import argparse
import re


class GitFinder:
    def __init__(self, config_file: str = "git_finder_config.json"):
        self.config_file = config_file
        self.config = self.load_config()

    def load_config(self) -> Dict:
        """Carga la configuración desde el archivo JSON"""
        default_config = {
            "search_paths": [str(Path.home())],
            "ignore_patterns": [
                ".local",
                "go",
                ".zen",
                "node_modules",
                "__pycache__",
                ".cache",
                ".fzf-tab",
                "yay",
                ".mozilla",
                "Gentleman.Dots",
            ],
            "max_depth": 10,
            "show_preview": True,
            "color_modified": "red",
            "color_clean": "white",
        }

        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, "r") as f:
                    user_config = json.load(f)
                    # Merge configs
                    default_config.update(user_config)
                    return default_config
            except (json.JSONDecodeError, IOError) as e:
                print(f"Error loading config: {e}. Using defaults.")
                return default_config
        else:
            # Crear archivo de configuración por defecto
            self.save_config(default_config)
            return default_config

    def save_config(self, config: Dict):
        """Guarda la configuración en el archivo JSON"""
        try:
            with open(self.config_file, "w") as f:
                json.dump(config, f, indent=2)
        except IOError as e:
            print(f"Error saving config: {e}")

    def should_ignore_path(self, path: str) -> bool:
        """Verifica si un path debe ser ignorado según los patrones"""
        for pattern in self.config["ignore_patterns"]:
            if re.search(pattern, path):
                return True
        return False

    def find_git_directories(self) -> List[Tuple[str, bool]]:
        """Encuentra todos los directorios git válidos usando fd"""
        # Intentar con fd primero
        try:
            self._check_command_availability("fd")
            return self._find_with_fd()
        except FileNotFoundError:
            print("⚠️  'fd' no disponible, usando método alternativo (más lento)")
            return self._find_with_walk()

    def _check_command_availability(self, command: str):
        """Verifica si un comando está disponible"""
        possible_paths = [
            command,  # En PATH
            f"/usr/bin/{command}",
            f"/usr/local/bin/{command}",
            f"/bin/{command}",
            "fdfind" if command == "fd" else None,  # fd a veces se instala como fdfind
        ]

        env = os.environ.copy()

        for cmd_path in possible_paths:
            if cmd_path is None:
                continue
            try:
                result = subprocess.run(
                    [cmd_path, "--version"],
                    capture_output=True,
                    text=True,
                    timeout=5,
                    env=env,
                )
                if result.returncode == 0:
                    return cmd_path
            except (FileNotFoundError, subprocess.TimeoutExpired):
                continue

        raise FileNotFoundError(f"Command '{command}' not found")

    def _find_with_fd(self) -> List[Tuple[str, bool]]:
        """Encuentra directorios git usando fd (método rápido)"""
        git_dirs = []

        # Encontrar el comando fd disponible
        try:
            fd_cmd = self._check_command_availability("fd")
        except FileNotFoundError:
            raise

        # Construir comando fd
        cmd = [fd_cmd, "-t", "d", "-H", ".git"]

        # Añadir rutas de búsqueda
        cmd.extend(self.config["search_paths"])

        # Añadir patrones de ignorado
        for pattern in self.config["ignore_patterns"]:
            cmd.extend(["-E", pattern])

        # Añadir profundidad máxima
        if self.config["max_depth"] > 0:
            cmd.extend(["--max-depth", str(self.config["max_depth"])])

        # Ejecutar dirname en cada resultado
        cmd.extend(["--exec", "dirname", "{}", ";"])

        try:
            env = os.environ.copy()
            result = subprocess.run(
                cmd, capture_output=True, text=True, timeout=30, env=env
            )

            if result.returncode != 0:
                print(f"Error ejecutando fd: {result.stderr}")
                return []

            # Procesar resultados
            candidate_dirs = set()  # Usar set para evitar duplicados
            for line in result.stdout.strip().split("\n"):
                if line.strip():
                    candidate_dirs.add(line.strip())

            # Verificar cada directorio candidato
            for dir_path in candidate_dirs:
                if self.is_valid_git_repo(dir_path):
                    has_changes = self.has_git_changes(dir_path)
                    git_dirs.append((dir_path, has_changes))

        except subprocess.TimeoutExpired:
            print("Error: Timeout buscando repositorios")
            return []
        except Exception as e:
            print(f"Error buscando repositorios: {e}")
            return []

        return sorted(git_dirs, key=lambda x: (not x[1], x[0]))  # Modificados primero

    def _find_with_walk(self) -> List[Tuple[str, bool]]:
        """Encuentra directorios git usando os.walk (método fallback)"""
        git_dirs = []

        for search_path in self.config["search_paths"]:
            if not os.path.exists(search_path):
                continue

            for root, dirs, _ in os.walk(search_path):
                # Filtrar directorios que deben ser ignorados
                dirs[:] = [
                    d
                    for d in dirs
                    if not self.should_ignore_path(os.path.join(root, d))
                ]

                # Limitar profundidad
                depth = root.replace(search_path, "").count(os.sep)
                if depth >= self.config["max_depth"]:
                    dirs.clear()
                    continue

                if ".git" in dirs:
                    # Verificar que es un repositorio git válido
                    if self.is_valid_git_repo(root):
                        has_changes = self.has_git_changes(root)
                        git_dirs.append((root, has_changes))

        return sorted(git_dirs, key=lambda x: (not x[1], x[0]))  # Modificados primero

    def is_valid_git_repo(self, path: str) -> bool:
        """Verifica si es un repositorio git válido"""
        try:
            result = subprocess.run(
                ["git", "-C", path, "rev-parse", "--is-inside-work-tree"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode != 0:
                return False

            # Verificar que es el directorio raíz del repo
            result = subprocess.run(
                ["git", "-C", path, "rev-parse", "--show-toplevel"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            return result.returncode == 0 and result.stdout.strip() == path
        except (subprocess.TimeoutExpired, FileNotFoundError):
            return False

    def has_git_changes(self, path: str) -> bool:
        """Verifica si el repositorio tiene cambios"""
        try:
            result = subprocess.run(
                ["git", "-C", path, "status", "--short"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            return result.returncode == 0 and bool(result.stdout.strip())
        except (subprocess.TimeoutExpired, FileNotFoundError):
            return False

    def get_git_status(self, path: str) -> str:
        """Obtiene el status git del repositorio"""
        try:
            result = subprocess.run(
                ["git", "-C", path, "-c", "color.status=always", "status", "--short"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode == 0 and result.stdout.strip():
                return result.stdout.strip()
            return "No hay modificaciones"
        except (subprocess.TimeoutExpired, FileNotFoundError):
            return "Error al obtener status"

    def get_directory_listing(self, path: str) -> str:
        """Obtiene el listado del directorio usando eza o ls como fallback"""
        # Obtener PATH del entorno
        env = os.environ.copy()

        # Intentar con eza primero (como en la versión original)
        for eza_cmd in ["eza", "/usr/bin/eza", "/usr/local/bin/eza"]:
            try:
                result = subprocess.run(
                    [eza_cmd, "--color=always", "-l", path],
                    capture_output=True,
                    text=True,
                    timeout=5,
                    env=env,
                )
                if result.returncode == 0:
                    return result.stdout
            except FileNotFoundError:
                continue
            except subprocess.TimeoutExpired:
                return "Timeout listando directorio con eza"

        # Fallback a ls con colores
        for ls_cmd in ["ls", "/bin/ls", "/usr/bin/ls"]:
            try:
                result = subprocess.run(
                    [ls_cmd, "-la", "--color=always", path],
                    capture_output=True,
                    text=True,
                    timeout=5,
                    env=env,
                )
                if result.returncode == 0:
                    return result.stdout
            except FileNotFoundError:
                continue
            except subprocess.TimeoutExpired:
                return "Timeout listando directorio con ls"

        # Último recurso: usar Python puro
        try:
            import stat
            import time

            items = []
            for item in os.listdir(path):
                item_path = os.path.join(path, item)
                try:
                    st = os.stat(item_path)
                    mode = stat.filemode(st.st_mode)
                    size = st.st_size
                    mtime = time.strftime("%b %d %H:%M", time.localtime(st.st_mtime))
                    items.append(f"{mode} {size:>8} {mtime} {item}")
                except (OSError, PermissionError):
                    items.append(f"????????? {item}")

            return "\n".join(items)
        except Exception:
            return "Error al listar directorio"

    def format_path(self, path: str, has_changes: bool) -> str:
        """Formatea el path con colores"""
        if has_changes:
            return f"\033[31m{path}\033[0m"  # Rojo para modificados
        else:
            return f"\033[37m{path}\033[0m"  # Blanco para limpios

    def show_preview(self, path: str):
        """Muestra el preview del repositorio"""
        print(f"\033[32m󰊢 Git Status:\033[0m")
        print(self.get_git_status(path))
        print(f"\n📁 Contenido:")
        print(self.get_directory_listing(path))

    def interactive_select(self) -> Optional[str]:
        """Selección interactiva usando fzf si está disponible"""
        git_dirs = self.find_git_directories()

        if not git_dirs:
            print("No se encontraron repositorios git")
            return None

        # Verificar si fzf está disponible
        try:
            subprocess.run(["fzf", "--version"], capture_output=True, check=True)
            has_fzf = True
        except (subprocess.CalledProcessError, FileNotFoundError):
            has_fzf = False

        if has_fzf and self.config["show_preview"]:
            return self._select_with_fzf(git_dirs)
        else:
            return self._select_manual(git_dirs)

    def _select_with_fzf(self, git_dirs: List[Tuple[str, bool]]) -> Optional[str]:
        """Selección usando fzf con preview (igual que la versión bash original)"""
        try:
            # Verificar que fzf está disponible
            fzf_cmd = self._check_command_availability("fzf")
        except FileNotFoundError:
            return self._select_manual(git_dirs)

        try:
            # Crear input para fzf con formato similar al original
            fzf_input = []
            for path, has_changes in git_dirs:
                if has_changes:
                    fzf_input.append(f"1\t{path}\t\033[31m{path}\033[0m")
                else:
                    fzf_input.append(f"2\t{path}\t\033[37m{path}\033[0m")

            fzf_input_str = "\n".join(fzf_input)

            # Comando fzf con preview que usa rutas completas
            preview_cmd = """
            path=$(echo {} | cut -f2)
            echo -e "\\033[32m󰊢 Git Status:\\033[0m"
            status_output=$(git -C "$path" -c color.status=always status --short 2>/dev/null)
            if [[ -n "$status_output" ]]; then
                echo "$status_output"
            else
                echo "No hay modificaciones"
            fi
            echo -e "\\n📁 Contenido:"
            (eza --color=always -l "$path" 2>/dev/null || /usr/bin/eza --color=always -l "$path" 2>/dev/null || ls -la --color=always "$path" 2>/dev/null || /bin/ls -la --color=always "$path")
            """

            env = os.environ.copy()
            result = subprocess.run(
                [fzf_cmd, "--ansi", "--with-nth=3", "--preview", preview_cmd],
                input=fzf_input_str,
                capture_output=True,
                text=True,
                env=env,
            )

            if result.returncode == 0:
                # Extraer el path de la línea seleccionada
                selected_line = result.stdout.strip()
                if selected_line:
                    return selected_line.split("\t")[1]
            return None
        except Exception as e:
            print(f"Error con fzf: {e}")
            return self._select_manual(git_dirs)

    def _select_manual(self, git_dirs: List[Tuple[str, bool]]) -> Optional[str]:
        """Selección manual sin fzf"""
        print("Repositorios git encontrados:")
        for i, (path, has_changes) in enumerate(git_dirs, 1):
            status = "🔴" if has_changes else "✅"
            print(f"{i:2d}. {status} {path}")

        try:
            choice = input("\nSelecciona un número (Enter para cancelar): ").strip()
            if not choice:
                return None

            index = int(choice) - 1
            if 0 <= index < len(git_dirs):
                return git_dirs[index][0]
            else:
                print("Número inválido")
                return None
        except ValueError:
            print("Entrada inválida")
            return None

    def list_repositories(self):
        """Lista todos los repositorios encontrados"""
        git_dirs = self.find_git_directories()

        if not git_dirs:
            print("No se encontraron repositorios git")
            return

        print(f"Encontrados {len(git_dirs)} repositorios:")
        for path, has_changes in git_dirs:
            status = "🔴 MODIFICADO" if has_changes else "✅ LIMPIO"
            print(f"{status:15} {path}")


def main():
    parser = argparse.ArgumentParser(description="Encontrar y navegar repositorios git")
    parser.add_argument("-l", "--list", action="store_true", help="Listar repositorios")
    parser.add_argument(
        "-c",
        "--config",
        help="Archivo de configuración",
        default="git_finder_config.json",
    )
    parser.add_argument(
        "--create-config",
        action="store_true",
        help="Crear archivo de configuración de ejemplo",
    )
    parser.add_argument(
        "--check-deps", action="store_true", help="Verificar dependencias disponibles"
    )

    args = parser.parse_args()

    finder = GitFinder(args.config)

    if args.create_config:
        print(f"Archivo de configuración creado: {args.config}")
        return

    if args.check_deps:
        print("Verificando dependencias...")

        # Verificar fd
        try:
            fd_cmd = finder._check_command_availability("fd")
            print(f"✅ fd disponible: {fd_cmd}")
        except FileNotFoundError:
            print("❌ fd no disponible (usará os.walk como fallback)")

        # Verificar fzf
        try:
            fzf_cmd = finder._check_command_availability("fzf")
            print(f"✅ fzf disponible: {fzf_cmd}")
        except FileNotFoundError:
            print("❌ fzf no disponible (usará selección manual)")

        # Verificar eza
        try:
            eza_cmd = finder._check_command_availability("eza")
            print(f"✅ eza disponible: {eza_cmd}")
        except FileNotFoundError:
            print("❌ eza no disponible (usará ls como fallback)")

        # Verificar ls
        try:
            ls_cmd = finder._check_command_availability("ls")
            print(f"✅ ls disponible: {ls_cmd}")
        except FileNotFoundError:
            print("❌ ls no disponible (usará listado Python)")

        return

    if args.list:
        finder.list_repositories()
    else:
        selected = finder.interactive_select()
        if selected:
            print(f"Cambiando a: {selected}")
            # En bash esto cambiaría el directorio
            # En Python, solo mostramos el path seleccionado
            print(f"cd '{selected}'")


if __name__ == "__main__":
    main()
