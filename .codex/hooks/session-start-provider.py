from pathlib import Path


def read_provider() -> str:
    env_path = Path(".env")
    if not env_path.exists():
        return "none"

    for raw_line in env_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue

        key, value = line.split("=", 1)
        if key.strip() == "TASK_MANAGER_PROVIDER":
            return value.strip().strip('"').strip("'") or "none"

    return "none"


if __name__ == "__main__":
    print(f"Onion: TASK_MANAGER_PROVIDER ativo = {read_provider()}")
