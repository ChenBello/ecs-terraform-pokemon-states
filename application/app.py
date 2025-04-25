# CRUD Pokemon DAL (Data Access Layer)

from flask import Flask, render_template, jsonify
import json
import random
import os

app = Flask(__name__)

def get_random_pokemon():
    json_path = os.path.join(os.path.dirname(__file__), 'AllPokemons.json')
    with open(json_path, 'r') as file:
        pokemons = json.load(file)
        return random.choice(pokemons)

@app.route('/')
def index():
    random_pokemon = get_random_pokemon()
    return render_template('index.html', pokemon=random_pokemon)

@app.route("/health")
def health_check():
    return "OK", 200

@app.route('/random_pokemon', methods=['GET'])
def random_pokemon():
    pokemon = get_random_pokemon()
    return jsonify(pokemon)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)

    # app.run(debug=True)
