from fastapi import FastAPI
from container_manager import reset_container, reset_all, get_status

app = FastAPI()

@app.post("/reset")
def reset_all_containers():
    return reset_all()

@app.post("/reset/{container}")
def reset_single(container: str):
    return {"result": reset_container(container)}

@app.get("/status")
def status():
    return get_status()

