import ast
import os
import sys

file_path = r"C:\LocalWork\xAquaticRisk\controlpanel\server.py"

try:
    with open(file_path, "r", encoding="utf-8") as f:
        source = f.read()

    tree = ast.parse(source)

    target_names = {
        "check_analysis_portable", "get_analysis_runtime_config", 
        "get_self_contained_runtime_status", "_get_server_status_info", 
        "list_runs_with_mcs", "list_map_explorer_runs", 
        "get_analysis_exposure_models", "_resolve_mc_store_paths", 
        "_build_map_geometry", "_build_map_timeseries", 
        "discover_runs", "run_detail", "tail_log", 
        "_parse_log_lines", "analysis_job_status", "analysis_job_outputs"
    }

    functions = {}
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef):
            calls = set()
            for subnode in ast.walk(node):
                if isinstance(subnode, ast.Call):
                    if isinstance(subnode.func, ast.Name):
                        calls.add(subnode.func.id)
                    elif isinstance(subnode.func, ast.Attribute):
                        calls.add(subnode.func.attr)
            
            functions[node.name] = {
                "start": node.lineno,
                "end": getattr(node, "end_lineno", node.lineno),
                "calls": calls
            }

    reachable = set()
    queue = [t for t in target_names if t in functions]
    
    while queue:
        name = queue.pop(0)
        if name in functions and name not in reachable:
            reachable.add(name)
            for call in functions[name]["calls"]:
                if call in functions and call not in reachable:
                    queue.append(call)

    print("---RESULTS---")
    print("ANALYSIS RELATED FUNCTIONS:")
    for name in sorted(reachable):
        f = functions[name]
        print(f"{name}: {f['start']}-{f['end']}")

    print("\nPREP-ONLY FUNCTIONS (EXCLUDED):")
    for name in sorted(functions):
        if name not in reachable:
            f = functions[name]
            print(f"{name}: {f['start']}-{f['end']}")

except Exception as e:
    print(f"ERROR: {e}")
