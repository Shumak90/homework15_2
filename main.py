import sqlite3
from flask import Flask, render_template,jsonify
from app import connect


def main():
    app = Flask(__name__)

    @app.route('/<int:itemid>')
    def animals(itemid):
        result = connect(itemid)
        return jsonify(result)

    app.run()


if __name__ == '__main__':
    main()
