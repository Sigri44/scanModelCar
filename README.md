# scanModelCar
Get model of vehicule

## Introduction
Obtenir le modèle d'une voiture, ou d'une moto (pas encore fonctionnel), grâce à sa plaque d'immatriculation.
Le script ne fait rien d'illégal, il parcours simplement les sites Oscaro, Yakarouler et Pieces auto à votre place pour ne récupérer que le modèle en fonction de la plaque (il utilise la fonction "recherche par plaque" de chaque site).
Pour s'en servir, il suffit de lancer le script, et de saisir la plaque. Le script propose aussi de rechercher les fiches techniques correspondantes, et enregistre un historique des recherches.

## Installation sur Android
Si vous partez de 0, il faut d'abord installer Termux, puis ensuite récupérer le script via le dépôt, et enfin faire un raccourci. Tout est expliqué ci-dessous.
### Installer Termux
Termux est accessible depuis n'importe quel store : [Play](https://play.google.com/store/apps/details?id=com.termux&hl=fr), [F-Droid](https://f-droid.org/fr/packages/com.termux/), [Aptoide](https://termux.fr.aptoide.com/)... Donc il suffit de le télécharger et l'installer.
### Récupération du script
Pour récupérer le script, il va falloir récupérer tout le dépot avec l'outil **git**
* Ouvrir termux
* Installer git en saisissant la commande suivante : `apt install git -y`
* Récupérer ensuite le dépôt : `git clone https://git.mux.re/T0MuX/scripts`
* Créer le dossier des raccourcis termux : `mkdir .shortcuts`
* Copier le script dans le dossier : `cp ./scripts/plaque/plaque.sh ./.shortcuts/plaque`
* Fermer termux en tapant `exit`, ou en déroulant le menu des notification et en appuyant sur Exit en dessous de "Termux"
* Sur l'écran d'accueil, ajouter un widget "Termux shortcut"
* Choisir "plaque" dans la liste, et c'est joué :)

![](https://zupimages.net/up/19/25/4b57.png)

## Utilisation
Quand le script se lance, on a directement une invite à la saisie pour la plaque. On peut aussi saisir les commandes suivantes :
```
     ? aide
     h historique
    sh supprimer historique
     q quitter
```

## Exemples
### GNU/Linux (Manjaro)
![](https://zupimages.net/up/19/22/l0dv.png) ![](https://zupimages.net/up/19/22/ccf5.png) ![](https://zupimages.net/up/19/22/it6n.png)

### MSYS2 / Cygwin / Bash for windows
![](https://zupimages.net/up/19/22/rm8e.png) ![](https://zupimages.net/up/19/22/bo9i.png) ![](https://zupimages.net/up/19/22/01gx.png)

### Termux (Android)
![](https://zupimages.net/up/19/22/vkgz.png) ![](https://zupimages.net/up/19/22/shbe.png)

## Source
![T0MuX](https://git.mux.re/T0MuX/scripts/src/branch/master/plaque)
