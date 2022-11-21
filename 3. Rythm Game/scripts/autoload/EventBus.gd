extends Node

# Emitted everytime we move a half-beat forward in a song
signal beat_incremented (msg)

# Emitted when the player made an action that increases the score
signal scored (msg)
