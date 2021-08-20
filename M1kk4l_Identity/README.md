# M1kk4l Identity

### Her er et simpelt identitet script hvor man kan lave et identitet når man joiner første gang.

## Installation
Tag filen M1kk4l_Identity og lig ind i din resources folder. Derefter skal du starte den i din server.cfg eller server_resources. 

Hvis du ikke har gjort så man starter med navnet Skift Navn, så skal du ind i [vrp]/vrp/cfg/identity.lua, og ændre cfg.random_first_names til:

```lua
cfg.random_first_names = {
	"Skift"
}
```
og under cfg.random_last_names skal du ændre den til: 

```lua
cfg.random_last_names = {
	"Navn"
}
```

## Krav 

pNotify
