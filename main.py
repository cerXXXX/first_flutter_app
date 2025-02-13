import os

ASSETS_DIR = "assets"  # Укажи путь к папке с ассетами, если она в другом месте

def get_folders(root_dir):
    folders = set()
    for root, dirs, files in os.walk(root_dir):
        if files:  # Добавляем только папки, содержащие файлы
            folders.add(root.replace("\\", "/") + "/")
    return sorted(folders)

def generate_pubspec_entries(folders):
    print("flutter:")
    print("  assets:")
    for folder in folders:
        print(f"    - {folder}")

if __name__ == "__main__":
    if os.path.exists(ASSETS_DIR):
        folders = get_folders(ASSETS_DIR)
        generate_pubspec_entries(folders)
    else:
        print(f"Папка '{ASSETS_DIR}' не найдена.")
