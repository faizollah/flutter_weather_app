from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route('/weather/<city>')
def get_weather(city):
    try:
        API_KEY = ''
        BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

        # Pass parameters as a dictionary
        params = {
            'q': city,
            'appid': API_KEY
        }

        # This will automatically URL-encode the city name (and other parameters)
        response = requests.get(BASE_URL, params=params)
        data = response.json()

        # Check if response from OpenWeatherMap API is not successful
        if response.status_code != 200:
            return jsonify({"error": data.get("message", "Unknown error")}), response.status_code

        # Extract necessary data
        weather_data = {
            "city": city,
            "temperature": round(data["main"]["temp"] - 273.15, 2),  # Convert Kelvin to Celsius
            "description": data["weather"][0]["description"],
            "humidity": data["main"]["humidity"],  # Extract humidity value
            "visibility": data["visibility"]  # Extract visibility value
        }
        return jsonify(weather_data)

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Request error: {str(e)}"}), 500
    except KeyError:
        return jsonify({"error": "Unexpected data structure from the API"}), 500
    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500
