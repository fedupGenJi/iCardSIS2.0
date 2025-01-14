from flask import Flask,render_template,flash




app=Flask(__name__)
@app.route('/')
def index():
    # flash("Welcome to SiCardSIS API")
    return render_template("index.html")



if __name__=="__main__":
    app.run(debug=True,port=7000)
