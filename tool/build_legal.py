"""Builds docs/privacy.html and docs/terms.html from assets/legal/*.md, the
same text the app shows, so the Play listing and the app never disagree.

    python tool/build_legal.py

Host with GitHub Pages (Settings -> Pages -> Deploy from branch -> /docs).
"""
import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title} · Ripped</title>
<style>
  :root {{ color-scheme: dark light; }}
  body {{
    margin: 0; background: #0E0F11; color: #F5F5F4;
    font: 16px/1.6 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  }}
  main {{ max-width: 720px; margin: 0 auto; padding: 48px 20px 80px; }}
  h1 {{ font-size: 2rem; margin: 0 0 8px; }}
  h2 {{ font-size: 1.25rem; margin: 32px 0 8px; }}
  p, li {{ color: #D4D4D8; }}
  a {{ color: #C6F432; }}
  nav {{ margin-bottom: 32px; }}
  nav a {{ margin-right: 16px; }}
  @media (prefers-color-scheme: light) {{
    body {{ background: #FAFAF9; color: #111214; }}
    p, li {{ color: #3F3F46; }}
    a {{ color: #4F7A00; }}
  }}
</style>
</head>
<body>
<main>
<nav><a href="privacy.html">Privacy policy</a><a href="terms.html">Terms of use</a><a href="delete-account.html">Delete account</a></nav>
{body}
</main>
</body>
</html>
"""


def inline(text: str) -> str:
    text = html.escape(text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)
    return re.sub(
        r"([\w.+-]+@[\w-]+(?:\.[\w-]+)+)", r'<a href="mailto:\1">\1</a>', text
    )


def render(md: str) -> tuple[str, str]:
    out, in_list, title = [], False, "Ripped"
    for raw in md.splitlines():
        line = raw.strip()
        if line.startswith("- "):
            if not in_list:
                out.append("<ul>")
                in_list = True
            out.append(f"<li>{inline(line[2:])}</li>")
            continue
        if in_list:
            out.append("</ul>")
            in_list = False
        if not line:
            continue
        if line.startswith("# "):
            title = line[2:]
            out.append(f"<h1>{inline(title)}</h1>")
        elif line.startswith("## "):
            out.append(f"<h2>{inline(line[3:])}</h2>")
        else:
            out.append(f"<p>{inline(line)}</p>")
    if in_list:
        out.append("</ul>")
    return title, "\n".join(out)


def main() -> None:
    docs = ROOT / "docs"
    docs.mkdir(exist_ok=True)
    for name in ("privacy", "terms", "delete-account"):
        md = (ROOT / "assets" / "legal" / f"{name}.md").read_text(encoding="utf-8")
        if "[CONTACT EMAIL]" in md:
            print(f"warning: {name}.md still has [CONTACT EMAIL]")
        title, body = render(md)
        (docs / f"{name}.html").write_text(PAGE.format(title=title, body=body), encoding="utf-8")
    (docs / "index.html").write_text(
        PAGE.format(
            title="Ripped",
            body="<h1>Ripped</h1><p>A minimalist, personal workout app.</p>",
        ),
        encoding="utf-8",
    )
    print("docs/ written")


if __name__ == "__main__":
    main()
