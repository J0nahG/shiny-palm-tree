from flask import Flask, render_template, request, redirect, url_for, make_response, render_template_string

app = Flask(__name__)
app.secret_key = "demo-only-secret"

COMMENTS = []
HARDCODED_PASSWORD = "paradise-cove-password"
SESSION_TOKEN = "rsv_7f3a9c2e1b6d4a8f0c5e9b2d7a1f6c3e"

@app.route("/")
def index():
    username = "Checked-in guest" if request.cookies.get("resort_session") == SESSION_TOKEN else "Guest"
    return render_template("index.html", username=username, comments=COMMENTS)

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        if request.form.get("password") != HARDCODED_PASSWORD:
            return render_template("login.html", error="Invalid password."), 401

        resp = make_response(redirect(url_for("index")))
        resp.set_cookie("resort_session", SESSION_TOKEN, httponly=True, samesite="Lax")
        return resp
    return render_template("login.html")

@app.route("/guestbook", methods=["POST"])
def guestbook():
    comment = request.form.get("comment", "")
    # Intentionally stored without sanitization.
    COMMENTS.append(comment)
    return redirect(url_for("index"))

@app.route("/preview", methods=["GET", "POST"])
def preview():
    if request.cookies.get("resort_session") != SESSION_TOKEN:
        return redirect(url_for("login"))

    if request.method == "POST":
        message = request.form.get("message", "Welcome to Paradise Cove Resort!")
        # INTENTIONALLY VULNERABLE SSTI:
        # untrusted input becomes the Jinja template itself.
        return render_template_string(
            "<link rel='stylesheet' href='/static/style.css'>"
            "<main class='card'><h1>Concierge Preview</h1>" + message +
            "<p><a href='/preview'>Back</a></p></main>"
        )
    return render_template("preview.html")

@app.route("/clear", methods=["POST"])
def clear():
    COMMENTS.clear()
    return redirect(url_for("index"))

if __name__ == "__main__":
    # Bind to localhost by default so the demo is not exposed to the LAN.
    app.run(host="127.0.0.1", port=5000, debug=False)
