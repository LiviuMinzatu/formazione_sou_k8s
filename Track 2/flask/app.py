# Import the Flask class from the flask module
from flask import Flask

# Create a Flask application instance
app = Flask(__name__)

# Define a route for the root URL "/"
@app.route('/')
def hello():
    # Return this message when the root page is accessed
    return "Hello, World!"

# Main entry point of the application
if __name__ == '__main__':
    # Run the Flask app, listening on all network interfaces (0.0.0.0) on port 5000
    app.run(host='0.0.0.0', port=5000)


