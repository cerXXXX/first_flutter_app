import os

# Папка с ассетами
ASSETS_DIR = 'assets'

# Функция для рекурсивного обхода файлов
def find_assets(directory):
    asset_paths = []
    for root, _, files in os.walk(directory):
        for file in files:
            path = os.path.join(root, file).replace('\\', '/')  # Для Windows
            asset_paths.append(path)
    return asset_paths

# Генерация строк для pubspec.yaml
def generate_pubspec_assets():
    assets = find_assets(ASSETS_DIR)
    if not assets:
        print(f'В папке "{ASSETS_DIR}" не найдено файлов.')
        return

    print('assets:')
    for asset in assets:
        print(f'  - {asset}')

if __name__ == '__main__':
    generate_pubspec_assets()
