# api/migrations/0002_seed_types.py
from django.db import migrations

TYPES = [
    "G280", "GLF2", "GLF3", "GLF4", "GLF5", "GLF6", "GA7C", "CL30", "CL35", "CL60", "GL5T", "GLEX", "F2TH", "F900", "FA10", "FA20", "FA50", "FA6X", "FA7X", "FA8X", "E35L", "E50P", "E545", "E550", "E55P", "PC24", "C25A", "C25B", "C25C", "C25D", "C500", "C510", "C525", "C550", "C551", "C552", "C560", "C56X", "C650", "C680", "C68A", "C700", "C750", "HDJT", "BE20", "BE30", "BE10", "BE90", "BE9L", "BE40", "PRM1", "EA50", "H25B", "H25C", "LJ23", "LJ24", "LJ25", "LJ28", "LJ31", "LJ35", "LJ36", "LJ40", "LJ45", "LJ55", "LJ60", "LJ75", "MU30", "WW24", "SJ30", "P180"
]

def seed_types(apps, schema_editor):
    Type = apps.get_model("api", "Type")
    for t in TYPES:
        Type.objects.get_or_create(type=t)

class Migration(migrations.Migration):
    dependencies = [("api", "0001_initial")]
    operations = [migrations.RunPython(seed_types, migrations.RunPython.noop)]
