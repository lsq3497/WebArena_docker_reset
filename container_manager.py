import subprocess
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SCRIPTS_DIR = BASE_DIR / "scripts"

# 映射容器名称 → 对应脚本
CONTAINER_SCRIPTS = {
    "shopping": "reset_shopping.sh",
    "shopping_admin": "reset_shopping_admin.sh",
    "forum": "reset_forum.sh",
    "gitlab": "reset_gitlab.sh",
    "kiwix": "reset_kiwix.sh",
    "map": "reset_map.sh",
}

def run_script(script_name: str) -> str:
    script_path = SCRIPTS_DIR / script_name

    if not script_path.exists():
        return f"Script not found: {script_path}"

    try:
        output = subprocess.check_output(
            ["bash", str(script_path)],
            stderr=subprocess.STDOUT,
            text=True
        )
        return output
    except subprocess.CalledProcessError as e:
        return f"Error running {script_name}:\n{e.output}"

def reset_container(container: str) -> str:
    if container not in CONTAINER_SCRIPTS:
        return f"Unknown container: {container}"

    script_name = CONTAINER_SCRIPTS[container]
    return run_script(script_name)

def reset_all() -> dict:
    results = {}
    for container, script in CONTAINER_SCRIPTS.items():
        results[container] = run_script(script)
    return results

def get_status() -> dict:
    try:
        output = subprocess.check_output(
            ["docker", "ps", "--format", "{{.Names}} {{.Status}}"],
            text=True
        )
        lines = output.strip().split("\n")
        status = {}

        for line in lines:
            if not line.strip():
                continue
            parts = line.split(" ", 1)
            status[parts[0]] = parts[1]

        return status
    except Exception as e:
        return {"error": str(e)}

