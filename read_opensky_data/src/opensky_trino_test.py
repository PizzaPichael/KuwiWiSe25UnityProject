from pyopensky.trino import Trino

trino = Trino()

# Get detailed trajectory data (state vectors)
trino.history(
    start="2019-11-01 09:00",
    stop="2019-11-01 12:00",
)
