import requests
import json

API_URL = "http://localhost:41595/api/item/addBookmark"
TOKEN = "18cc59fc-95b1-4209-b55e-6d3b831e0c80"
ITEM_ID = "MKJ7IDGAH9K32"
FOLDER_ID = "KTNWWCK3F0ONQ"

payload = {
    "id": ITEM_ID,
    "folderId": FOLDER_ID,
    "token": TOKEN
}

try:
    response = requests.post(API_URL, json=payload)
    print(response.status_code)
    print(response.text)
except Exception as e:
    print(e)
