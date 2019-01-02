from flask import Flask
from random import randint
import sys

app = Flask(__name__)
_port=10000

@app.route("/")
def index():
	return "Hej"+str(_port)



if __name__ == "__main__":
	if len(sys.argv) > 1:
		_port=sys.argv[1]
	else:
		_port=randint(10000,10100)
	app.run(host="0.0.0.0",port=_port)
