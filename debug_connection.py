import urllib.request
import urllib.error
import json

base_url = "https://monetra-backend-production-8b0d.up.railway.app"

def test_url(url, method="GET", data=None):
    print(f"\nTesting {method} {url}...")
    req = urllib.request.Request(url, method=method)
    if data:
        req.data = json.dumps(data).encode('utf-8')
        req.add_header('Content-Type', 'application/json')
        req.add_header('Accept', 'application/json')
    
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            print(f"Status: {response.status}")
            print(f"Body: {response.read().decode('utf-8')[:500]}")
    except urllib.error.HTTPError as e:
        print(f"Status: {e.code}")
        print(f"Error Body: {e.read().decode('utf-8')[:500]}")
    except Exception as e:
        print(f"Failed: {e}")

# 1. Root
test_url(base_url)

# 2. Login
test_url(f"{base_url}/api/login", method="POST", data={})

# 3. Register
test_url(f"{base_url}/api/register", method="POST", data={})
