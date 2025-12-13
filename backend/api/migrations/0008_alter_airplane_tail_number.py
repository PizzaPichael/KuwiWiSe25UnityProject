# Generated manually to bump tail_number length to 10
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("api", "0007_alter_type_options"),
    ]

    operations = [
        migrations.AlterField(
            model_name="airplane",
            name="tail_number",
            field=models.CharField(max_length=10, unique=True),
        ),
    ]
