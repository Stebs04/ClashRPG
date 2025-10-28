# Indica che questo script "estende" o "specializza" le funzionalità
# del nodo CharacterBody2D. Questo ci dà accesso a variabili come 'velocity'
# e a funzioni come 'move_and_slide()'.
extends CharacterBody2D

# La parola chiave '@export' rende questa variabile visibile e modificabile
# nell'editor di Godot (nel pannello Ispettore).
# 'var speed' dichiara una nuova variabile chiamata 'speed'.
# ': float' specifica che questa variabile conterrà un numero con la virgola (decimale).
# '= 300.0' assegna un valore iniziale di 300.0 a 'speed'.
# Questa variabile controllerà la velocità di movimento del personaggio in pixel al secondo.
@export var speed: float = 300.0

# La parola chiave '@onready' fa sì che Godot aspetti che il nodo
# sia completamente pronto ("ready") nella scena prima di assegnare il valore
# a questa variabile. Questo è importante per accedere ad altri nodi.
# 'var sprite_animato' dichiara una nuova variabile chiamata 'sprite_animato'.
# ': AnimatedSprite2D' specifica che questa variabile conterrà un riferimento
# a un nodo di tipo AnimatedSprite2D.
# '= $Sprite' assegna alla variabile un riferimento al nodo figlio chiamato "Sprite".
# Il simbolo '$' è una scorciatoia per la funzione 'get_node()'.
# Assicurati che il nome "Sprite" corrisponda ESATTAMENTE al nome
# del tuo nodo AnimatedSprite2D nella scena 'player.tscn'!
@onready var sprite_animato: AnimatedSprite2D = $Sprite

# Questa è una funzione speciale chiamata automaticamente da Godot ad ogni
# "passo" di fisica (di default, 60 volte al secondo).
# È il posto ideale per mettere il codice che gestisce il movimento e le collisioni.
# 'delta' è un parametro passato da Godot che rappresenta il tempo (in secondi)
# trascorso dall'ultimo passo di fisica. Non lo usiamo qui, ma è utile
# per movimenti indipendenti dal framerate.
func _physics_process(delta):

	# --- PASSO 1: GESTIONE DELL'INPUT ---
	# Dichiara una variabile locale chiamata 'direction'.
	# 'Input' è un oggetto globale di Godot che gestisce input da tastiera, mouse, etc.
	# 'get_vector()' è una funzione comoda che controlla quattro azioni di input
	# (definite nel menu Progetto -> Impostazioni Progetto -> Mappa Input)
	# e restituisce un vettore di direzione (Vector2).
	# Es: Se premi D ("move_right"), restituisce (1, 0).
	# Es: Se premi W ("move_up"), restituisce (0, -1) (Y è negativo verso l'alto).
	# Es: Se premi D e W, restituisce (1, -1) normalizzato (non più veloce in diagonale).
	# Se non premi nulla, restituisce (0, 0).
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# --- PASSO 2: CALCOLO DELLA VELOCITÀ ---
	# 'velocity' è una variabile speciale ereditata da CharacterBody2D.
	# Rappresenta la velocità desiderata per il movimento in questo frame.
	# Moltiplichiamo il vettore 'direction' (che ha lunghezza 0 o 1)
	# per la nostra variabile 'speed' (300.0).
	# Es: Se direction è (1, 0), velocity diventa (300.0, 0).
	# Es: Se direction è (0, 0), velocity diventa (0, 0).
	velocity = direction * speed

	# --- PASSO 3: ESECUZIONE DEL MOVIMENTO ---
	# 'move_and_slide()' è la funzione principale di CharacterBody2D per il movimento.
	# Usa la variabile 'velocity' che abbiamo appena impostato per provare a muovere
	# il corpo. Gestisce automaticamente le collisioni con altri corpi fisici
	# (basandosi sulla CollisionShape2D del Player) e fa "scivolare" il personaggio
	# lungo i muri invece di fermarlo bruscamente.
	move_and_slide()

	# --- PASSO 4: AGGIORNAMENTO DELL'ANIMAZIONE ---
	# Chiamiamo la nostra funzione personalizzata 'update_animation'
	# e le passiamo il vettore 'direction' che abbiamo calcolato prima.
	# Questo mantiene il codice di _physics_process più pulito e organizzato.
	update_animation(direction)


# Definiamo una nostra funzione personalizzata per gestire la logica dell'animazione.
# Riceve il vettore 'direction' come input (parametro).
func update_animation(direction):

	# Controlla se il personaggio è fermo.
	# 'direction.length()' calcola la lunghezza del vettore. Se è 0,
	# significa che il vettore è (0, 0), quindi nessun tasto di movimento è premuto.
	if direction.length() == 0:
		# Prima di cambiare l'animazione, controlliamo se quella attuale
		# NON è già "idle". Questo evita di riavviare l'animazione "idle"
		# ad ogni frame in cui siamo fermi.
		if sprite_animato.animation != "idle":
			# '.animation' è una proprietà del nodo AnimatedSprite2D che tiene traccia
			# del nome dell'animazione attualmente in riproduzione.
			# '.play("nome_animazione")' è la funzione che avvia un'animazione specifica.
			sprite_animato.play("idle")
	# Altrimenti (se la lunghezza NON è 0), significa che il personaggio si sta muovendo.
	else:
		# Controlliamo se l'animazione attuale NON è già "run".
		# Questo evita di riavviare l'animazione "run" ad ogni frame
		# mentre ci stiamo muovendo.
		if sprite_animato.animation != "walk":
			# Avvia l'animazione chiamata "run".
			sprite_animato.play("walk")

		# --- GESTIONE DELLA DIREZIONE DELLO SPRITE (Flip) ---
		# Controlla se ci stiamo muovendo orizzontalmente verso sinistra.
		# 'direction.x' è la componente X del vettore di direzione.
		# Se è minore di 0, stiamo premendo 'A' (o il tasto mappato a "move_left").
		if direction.x < 0:
			# 'flip_h' è una proprietà booleana (vero/falso) di AnimatedSprite2D.
			# Se impostata a 'true', lo sprite viene disegnato ribaltato orizzontalmente.
			sprite_animato.flip_h = true
		# Altrimenti, se ci stiamo muovendo orizzontalmente verso destra.
		# Se 'direction.x' è maggiore di 0, stiamo premendo 'D' (o "move_right").
		elif direction.x > 0:
			# Imposta 'flip_h' a 'false' per assicurarti che lo sprite guardi
			# nella sua direzione originale (di solito, verso destra).
			sprite_animato.flip_h = false
		# Nota: Se direction.x è esattamente 0 (movimento solo verticale),
		# non cambiamo 'flip_h'. In questo modo, il personaggio continuerà
		# a guardare nell'ultima direzione orizzontale in cui stava andando.
