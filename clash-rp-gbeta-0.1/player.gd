extends CharacterBody2D

# Definiamo la velocità del nostro giocatore.
# '300.0' è in pixel al secondo. Puoi cambiarlo!
@export var speed: float = 300.0

func _physics_process(delta):
	# Questa funzione viene chiamata ad ogni frame di fisica.
	# È il posto migliore per tutto ciò che riguarda il movimento.

	# 1. Ottenere l'input del giocatore.
	# Godot controlla le nostre azioni della "Mappa Input".
	# 'get_vector' crea una direzione (un "vettore") dalle nostre 4 azioni.
	# Es: Se premi D ("move_right") e W ("move_up"), 
	# il vettore sarà (1, -1) (destra e su).
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# 2. Calcolare la velocità
	# Moltiplichiamo la direzione (che è lunga 0 o 1) per la nostra velocità.
	velocity = direction * speed

	# 3. Muovere il personaggio!
	# 'move_and_slide()' è la funzione magica di CharacterBody2D.
	# Dice a Godot: "Muovi questo corpo usando la sua 'velocity',
	# e se colpisce qualcosa, scivolaci contro."
	move_and_slide()
