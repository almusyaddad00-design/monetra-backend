import urllib.request
import urllib.error
import json

base_url = "https://monetra-backend-production-8b0d.up.railway.app"

print("=" * 60)
print("TESTING BACKEND CONNECTIVITY")
print("=" * 60)

# Test 1: Root endpoint
print("\n1. Testing root endpoint...")
try:
    req = urllib.request.Request(base_url)
    with urllib.request.urlopen(req, timeout=30) as response:
        print(f"   ✓ Status: {response.status}")
        body = response.read().decode('utf-8')[:200]
        print(f"   ✓ Response preview: {body}")
except urllib.error.HTTPError as e:
    print(f"   ✗ HTTP Error {e.code}")
    print(f"   ✗ Body: {e.read().decode('utf-8')[:200]}")
except Exception as e:
    print(f"   ✗ Failed: {e}")

# Test 2: API Register endpoint
print("\n2. Testing POST /api/register...")
try:
    data = {
        "name": "Test User",
        "email": "test@example.com",
        "password": "password123"
    }
    req = urllib.request.Request(
        f"{base_url}/api/register",
        data=json.dumps(data).encode('utf-8'),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        method='POST'
    )
    with urllib.request.urlopen(req, timeout=30) as response:
        print(f"   ✓ Status: {response.status}")
        body = response.read().decode('utf-8')
        print(f"   ✓ Response: {body[:500]}")
except urllib.error.HTTPError as e:
    print(f"   ✗ HTTP Error {e.code}")
    error_body = e.read().decode('utf-8')
    print(f"   ✗ Error response: {error_body[:500]}")
    # 422 is expected (validation error) - that's actually good!
    if e.code == 422:
        print("   ℹ Note: 422 means validation error - API is working!")
except Exception as e:
    print(f"   ✗ Failed: {e}")

# Test 3: API Login endpoint
print("\n3. Testing POST /api/login...")
try:
    data = {
        "email": "test@example.com",
        "password": "password123"
    }
    req = urllib.request.Request(
        f"{base_url}/api/login",
        data=json.dumps(data).encode('utf-8'),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        method='POST'
    )
    with urllib.request.urlopen(req, timeout=30) as response:
        print(f"   ✓ Status: {response.status}")
        body = response.read().decode('utf-8')
        print(f"   ✓ Response: {body[:500]}")
except urllib.error.HTTPError as e:
    print(f"   ✗ HTTP Error {e.code}")
    error_body = e.read().decode('utf-8')
    print(f"   ✗ Error response: {error_body[:500]}")
    # 401 or 422 is expected - that's actually good!
    if e.code in [401, 422]:
        print("   ℹ Note: Error code means API is working, just credentials invalid!")
except Exception as e:
    print(f"   ✗ Failed: {e}")

print("\n" + "=" * 60)
print("TEST COMPLETE")
print("=" * 60)
