from flask import Flask, request, Response
from flask_cors import CORS  # Import the CORS extension
import requests
from flask_cors import cross_origin

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# Base URL for the services, assuming they are running on localhost with different ports #C:\Users\moelr\AppData\Local\Android\Sdk\emulator\emulator -avd Pixel_XL_API_30 -read-only
SERVICE_URLS = {
    "stations": "http://192.168.100.5:8082",
    "gazoles": "http://192.168.100.5:8083",
    "services": "http://192.168.100.5:8084",
    "utilisateurs": "http://192.168.100.5:8086",
    # Assuming there's a service2 URL1
}
@app.route('/<name>/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
@app.route('/<name>', methods=['GET', 'POST', 'PUT', 'DELETE'])
@cross_origin() 
def service_proxy(name, path=""):
    print(f"Received request for {name} with path {path}")
    # Check if service name is valid
    if name in SERVICE_URLS: 
        url = f'{SERVICE_URLS[name]}/{path}'
        if path in ['registre', 'login']:
            # Forward the request based on its method
            response = forward_request(request.method, url, request)
        else:
            # Check if the 'Authorization' header is present
            if 'Authorization' not in request.headers:
                return Response("Authorization header is missing", status=401)
            else:
                # Extract token from the Authorization header
                token = request.headers['Authorization'].split(' ')[1]
                
                # Verify the token with the user service
                verify_url = f"{SERVICE_URLS['utilisateurs']}/verifier"
                verify_response = requests.post(verify_url, data={'token': token})
                
                # Check if the token verification was successful
                if verify_response.status_code == 200:
                    print('ok')  # Debugging purposes
                    # Forward the request if the token is verified
                    response = forward_request(request.method, url, request)
                else:
                    # If token verification fails, return an unauthorized response
                    return Response("Invalid or expired token", status=401)

        # Return the forwarded response
        return Response(response.content, status=response.status_code, mimetype=response.headers['Content-Type'])
    else:
        return Response(f"Service {name} not found", status=404)

def forward_request(method, url, request):
    # Forward the request based on its method
    if method == 'GET':
        return requests.get(url, params=request.args)
    elif method == 'POST':
        # Forwarding JSON data as an example, adjust if using form data
        return requests.post(url, json=request.json, headers=request.headers)
    elif method == 'PUT':
        # Example for PUT, similar to POST
        return requests.put(url, json=request.json, headers=request.headers)
    elif method == 'DELETE':
        return requests.delete(url, headers=request.headers)
    else:
        return Response("Unsupported method", status=405)

if __name__ == '__main__':
    app.run(host='192.168.100.5',port=8085)
