import os
import re

directory = r"c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib"
import_stmt = "import 'package:medi_connect/core/constants/app_constants.dart';\n"

# We want to replace:
# 1. ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"] or similar with AppConstants.bloodGroups
# 2. 'O+' or "O+" with AppConstants.defaultBloodGroup

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Replace arrays
    content = re.sub(r'\[\s*[\'"]A\+[\'"]\s*,\s*[\'"]A-[\'"]\s*,\s*[\'"]B\+[\'"]\s*,\s*[\'"]B-[\'"]\s*,\s*[\'"]O\+[\'"]\s*,\s*[\'"]O-[\'"]\s*,\s*[\'"]AB\+[\'"]\s*,\s*[\'"]AB-[\'"]\s*\]', 'AppConstants.bloodGroups', content)
    content = re.sub(r'\[\s*[\'"]A\+[\'"]\s*,\s*[\'"]A-[\'"]\s*,\s*[\'"]B\+[\'"]\s*,\s*[\'"]B-[\'"]\s*,\s*[\'"]AB\+[\'"]\s*,\s*[\'"]AB-[\'"]\s*,\s*[\'"]O\+[\'"]\s*,\s*[\'"]O-[\'"]\s*\]', 'AppConstants.bloodGroups', content)
    
    # Replace default blood group literal
    content = re.sub(r'[\'"]O\+[\'"]', 'AppConstants.defaultBloodGroup', content)

    if content != original_content:
        # add import if not present
        if "app_constants.dart" not in content:
            # find last import
            imports = list(re.finditer(r'^import\s+[\'"].*?[\'"];$', content, re.MULTILINE))
            if imports:
                last_import = imports[-1]
                content = content[:last_import.end()] + "\n" + import_stmt + content[last_import.end():]
            else:
                content = import_stmt + "\n" + content

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {filepath}")

for root, _, files in os.walk(directory):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

print("Blood group replacements complete.")
