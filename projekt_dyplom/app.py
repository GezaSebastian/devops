from flask import Flask, jsonify, request import prometheus_client from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(name)
REQUESTS = Counter('app_requests_total', 'Total HTTP requests')

@app.route('/') def hello(): REQUESTS.inc() return jsonify(message="Hello from simple Flask app")

@app.route('/health') def health(): return jsonify(status="ok")

@app.route('/echo', methods=['POST']) def echo(): REQUESTS.inc() data = request.get_json(silent=True) or {} return jsonify(received=data)

@app.route('/metrics') def metrics(): return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if name == 'main': app.run(host='0.0.0.0', port=5000)