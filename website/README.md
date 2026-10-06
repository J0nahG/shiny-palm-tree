# Paradise Cove Resort — intentionally vulnerable Flask demo

**For an isolated educational lab only.** The application intentionally contains stored XSS and Jinja2 SSTI vulnerabilities. It binds to `127.0.0.1` by default.

## Run

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000`.

## Demo flow

1. Log in with the hardcoded password `paradise-cove-password`. The app creates a hardcoded `resort_session` cookie and uses it to protect Concierge Preview.
2. In the guestbook, demonstrate stored XSS with a harmless page modification such as:

```html
<script>document.querySelector('header h1').textContent='DEFACED RESORT';</script>
```

3. To demonstrate why XSS can expose script-readable authentication state without sending it anywhere, use:

```html
<script>alert(document.cookie)</script>
```

4. In **Concierge Preview**, confirm SSTI with:

```jinja2
{{ 7 * 7 }}
```

It renders `49`, proving user input is being evaluated as a Jinja template.

For an RCE lesson, the vulnerable primitive is intentionally present in `render_template_string(message)`, but the README stops at a non-destructive SSTI proof rather than supplying an OS-command payload.

## Vulnerabilities to explain

- **Stored XSS:** `{{ comment | safe }}` suppresses Jinja's normal escaping.
- **Authentication:** login uses a hardcoded password and session token for the isolated demo.
- **SSTI:** attacker-controlled text is passed into `render_template_string`, causing Jinja expressions to execute server-side.
- **Fixes:** remove `|safe`, sanitize any intentionally allowed HTML, set authentication cookies `HttpOnly`/`Secure`, and never treat untrusted input as template source. Replace the hardcoded demo credentials with a real authentication system in production.
