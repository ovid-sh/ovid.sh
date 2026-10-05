#!/usr/bin/env python3
"""Serve out/ the way the host will: /start is out/start.html, .md and
.jsonl as text. For looking at the site locally; not part of the build.

  ./serve.py [port]     default 8000, on every interface
"""
import http.server
import os
import sys

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".md": "text/markdown; charset=utf-8",
        ".txt": "text/plain; charset=utf-8",
        ".jsonl": "application/jsonl; charset=utf-8",
        ".html": "text/html; charset=utf-8",
        ".css": "text/css; charset=utf-8",
    }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=OUT, **kwargs)

    def translate_path(self, path):
        p = super().translate_path(path)
        if not os.path.exists(p) and os.path.exists(p + ".html"):
            return p + ".html"
        return p


port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
http.server.ThreadingHTTPServer(("", port), Handler).serve_forever()
