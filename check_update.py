import ast
file_path = r'C:\LocalWork\xAquaticRisk\controlpanel\server.py'
with open(file_path, 'r', encoding='utf-8') as f:
    source = f.read()
tree = ast.parse(source)
for node in ast.walk(tree):
    if isinstance(node, ast.FunctionDef):
        for subnode in ast.walk(node):
            if isinstance(subnode, ast.Call) and isinstance(subnode.func, ast.Name) and subnode.func.id == 'update':
                print(f'Function {node.name} calls update')
