import os

from celery import Celery
from celery.signals import worker_ready

# Set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'plane_api.settings')

app = Celery('plane_api')

app.conf.beat_schedule = {
    "fetch-airplane-positions": {
        "task": "api.tasks.fetch_data",
        "schedule": 300.0,
    },
}

@worker_ready.connect
def trigger_initial_fetch(sender, **kwargs):
    """
    Fire one fetch as soon as the worker is ready.

    Using worker_ready (instead of on_after_configure) avoids racing the broker
    connection during startup, which made the initial send_task occasionally
    get lost.
    """
    sender.app.send_task("api.tasks.fetch_data")

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#   should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django apps.
app.autodiscover_tasks()


@app.task(bind=True, ignore_result=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
