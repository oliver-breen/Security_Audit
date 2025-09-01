from flask import Flask, request, render_template_string, g, redirect, url_for
import sqlite3
import os

app = Flask(__name__)
DB_PATH = 'data.db'

# Insecure DB access for demo purposes (vulnerable to SQL Injection).
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        need_init = not os.path.exists(DB_PATH)
        db = g._database = sqlite3.connect(DB_PATH)
        if need_init:
            with db:
                db.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT)")
                db.execute("INSERT INTO users (name, email) VALUES ('alice', 'alice@example.com')")
                db.execute("INSERT INTO users (name, email) VALUES ('bob', 'bob@example.com')")
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

@app.route('/')
def index():
    return '''
    <h1>Vulnerable App — For Local Testing Only</h1>
    <ul>
      <li><a href="/search">Search (SQLi demo)</a></li>
      <li><a href="/comments">Comments (Reflected XSS demo)</a></li>
    </ul>
    '''

# Vulnerable search endpoint (string formatting -> SQLi)
@app.route('/search', methods=['GET', 'POST'])
def search():
    results = []
    q = ''
    if request.method == 'POST':
        q = request.form.get('q', '')
        db = get_db()
        # INTENTIONALLY VULNERABLE: direct string interpolation
        sql = "SELECT id, name, email FROM users WHERE name = '%s'" % q
        try:
            cur = db.execute(sql)
            results = cur.fetchall()
        except Exception as e:
            results = [('error', str(e))]
    return render_template_string('''
      <h2>Search users (vulnerable)</h2>
      <form method="post">
        <input name="q" value="{{q}}">
        <button type="submit">Search</button>
      </form>
      <pre>{{results}}</pre>
      <p>Example injection: ' OR '1'='1</p>
    ''', q=q, results=results)

# Reflected XSS demo
@app.route('/comments', methods=['GET', 'POST'])
def comments():
    comment = ''
    if request.method == 'POST':
        comment = request.form.get('comment', '')
        # INTENTIONALLY VULNERABLE: we render user input without escaping
    return render_template_string('''
      <h2>Comments (reflected XSS demo)</h2>
      <form method="post">
        <textarea name="comment">{{comment}}</textarea><br/>
        <button type="submit">Post</button>
      </form>
      <h3>Latest</h3>
      <div>{{comment}}</div>
      <p>Try: &lt;script&gt;alert('XSS')&lt;/script&gt;</p>
    ''', comment=comment)

# Header disclosure demo
@app.route('/headers')
def headers():
    return "Server headers demo", 200, {'Server': 'DemoServer/1.2.3', 'X-Powered-By': 'Flask'}

if __name__ == '__main__':
    app.run(debug=True)