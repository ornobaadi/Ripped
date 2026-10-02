"""Prints line coverage for lib/domain from coverage/lcov.info.

    flutter test --coverage
    python tool/coverage_report.py
"""
import sys

stats = {}
current = None
for line in open('coverage/lcov.info', encoding='utf-8'):
    if line.startswith('SF:'):
        current = line[3:].strip().replace('\\', '/')
    elif line.startswith('DA:') and current and '/domain/' in current:
        _, hits = line[3:].split(',')[:2]
        entry = stats.setdefault(current, [0, 0])
        entry[0] += 1
        entry[1] += int(hits) > 0

total = sum(v[0] for v in stats.values())
hit = sum(v[1] for v in stats.values())
for path, (lines, covered) in sorted(stats.items()):
    print(f"{100 * covered / lines:5.1f}%  {path.split('lib/')[-1]}")
pct = 100 * hit / total if total else 0
print(f"domain: {hit}/{total} lines = {pct:.1f}%")
sys.exit(0 if pct >= 90 else 1)
