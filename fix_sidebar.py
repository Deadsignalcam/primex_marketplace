from pathlib import Path

p = Path("lib/screens/dashboard_screen.dart")
txt = p.read_text(encoding="utf-8")

txt = txt.replace(
"sideTab('Saved', Icons.star),",
"""sideTab('Saved', Icons.star),
                  sideTab('Profile Levels', Icons.person),"""
)

txt = txt.replace(
"children: [",
"""children: [
                const SizedBox(height: 8),"""
)

p.write_text(txt, encoding="utf-8")

print("Sidebar repaired successfully")
