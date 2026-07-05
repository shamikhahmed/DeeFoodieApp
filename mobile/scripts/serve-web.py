#!/usr/bin/env python3
"""SPA-friendly static server for Flutter web build (fallback to index.html)."""
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
ROOT = os.getcwd()


class SpaHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)

    def do_GET(self):
        path = self.path.split('?', 1)[0]
        candidate = os.path.join(ROOT, path.lstrip('/'))
        if path != '/' and not os.path.isfile(candidate):
            self.path = '/index.html'
        return super().do_GET()


if __name__ == '__main__':
    with ThreadingHTTPServer(('', PORT), SpaHandler) as httpd:
        print(f'Serving {ROOT} on http://localhost:{PORT}')
        httpd.serve_forever()
