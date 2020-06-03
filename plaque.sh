#!/bin/bash

# Couleurs
N="\e[0m"
V="\e[92m"
J="\e[93m"
R="\e[31m"
B="\e[94m"
BC="\e[34m"

cat="    " # Pour que la variable $cat prenne autant de place dans le script que sur le stdout...
type=A # type Auto par défaut
oscflag=0; yakaflag=0; paflag=0 # déclaration des variables "flag"

logo() {
echo -e $J" _____  _"
echo "|  __ \| |"
echo "| |__) | | __ _  __ _ _MuX_  ___"
echo "|  ___/| |/ _\` |/ _\` | | | |/ _ \\"
echo "| |    | | (_| | (_| | |_| |  __/"
echo "|_|    |_|\__,_|\__, |\__,_|\___|"
echo "               $cat| |"
echo "                   |_|"
}

clear; logo
#echo; read -p "Auto / Moto ? (A/M) " typech # Je commente tant que je ne trouve pas de site de moto qui fait de la recherche de modèle par plaque
if [ -z $typech ]
	then type=A
	cat=Auto
	else
	if [ $typech = M ] || [ $typech = m ]
		then type=M
		cat=Moto
	fi
fi

# Debut de la grande boucle
while :
do
clear;logo

# Saisie plaque
echo -e -n "${B}# Plaque: $N"
if [ -z $plkreplay ]; then read plk; else plk=$plkreplay; plkreplay=; fi

# Test entrée & exec commandes
if [ "$plk" = q ] || [ "$plk" = e ]; then echo; exit; fi

if [ "$plk" = h ]
then clear; logo; echo -e "${V}Historique des plaques recherchées :$J"
	if [ $type = M ]
	then if [ -f ~/.plkhm ]; then cat .plkhm; else echo -e "${J}vide$N";fi
	else if [ -f ~/.plkh ]
		then
		count=1
		total=$(cat ~/.plkh | wc -l)

		while read -r line; do
		        echo "$count) $line"
		        if [ $count -eq $total ]; then break; fi
		        ((count++))
		done < ~/.plkh
		echo
		read -p "Rejouer une plaque ? (1-$total) / Retour menu ? (*) " plkch

		if [ $plkch -gt 0 ] && [ $plkch -lt 100 ]
			then plkreplay=$(cat ~/.plkh | head -n${plkch} | tail -n1 | cut -d\  -f1)
			else echo
		fi

		else
		echo -e "${J}vide$N"
		read
		fi
	fi
fi

if [ "$plk" = sh ]
then clear; logo
	if [ $type = M ]
	then if [ -f ~/.plkhm ]; then rm .plkhm; echo -e "${J}Historique Moto supprimé.$N"; else echo -e "${J}déja vide$N"; fi
	else if [ -f ~/.plkh ]; then rm .plkh; echo -e "${J}Historique Auto supprimé.$N"; else echo -e "${J}déja vide$N"; fi
	fi
read
fi

if [ "$plk" = "?" ] || [ "$plk" = "help" ]; then
	clear; logo; echo -e "${V}Aide :$J\n"
	echo -e "$J  ? - aide"
	echo -e "$J  h - historique"
	echo -e "$J sh - supprimer historique"
	echo -e "$J  q - quitter"
fi

# Si aucune commande, lancer la recherche de plaque (ouverture du grand IF "recup info")
if [ "$plk" != "h" ] && [ "$plk" != "sh" ] && [ "$plk" != "help" ] && [ "$plk" != "?" ] && [ "$plk" != "" ]
then


# RECOLTE
# Envoi des requetes pour récupérer les infos dans les variables

if [ $type = M ]
then

# Surplusmoto https://www.surplusmotos.com
# visiblement pas au point (version beta), re-essayer plus tard

# France Casse https://www.francecasse.fr/moto/pieces-moto.htm
# pas au point non plus... faire tests plus tard

echo En cours de test/script...


else
echo -e "\nRecherche...\n"
# Oscaro
#curl -s -d "plateValue=$plk&genartId=null" -X POST https://www.oscaro.com/Catalog/SearchEngine/GetPlateSearchResult | cut -d\" -f10 > osctmp
wget -qO- --post-data "plateValue=$plk&genartId=null" https://www.oscaro.com/Catalog/SearchEngine/GetPlateSearchResult 2>/dev/null | cut -d\" -f10 > osctmp
osc=`cat osctmp | head -n1`

# Yakarouler
#curl -s "https://www.yakarouler.com/car_search/immat?immat=$plk&name=undefined&redirect=true" > yaktmp
wget -qO- "https://www.yakarouler.com/car_search/immat?immat=$plk&name=undefined&redirect=true" > yaktmp 2>/dev/null
yak1=`cat yaktmp | grep title-car | awk -F"<|>" '{print $3}'`
yak2=`cat yaktmp | grep "Code moteur" | awk -F";|<" '{print $6}'`

# Pieces auto
#curl -s "https://www.piecesauto.com/homepage/numberplate?value=$plk" > patmp
wget -qO- "https://www.piecesauto.com/homepage/numberplate?value=$plk" > patmp 2>/dev/null
pacarid=`awk -F":|}" '{print $2}' patmp`
#curl -s "https://www.piecesauto.com//common/seekCar?carid=$pacarid&language=fr" > patmp
wget -qO- "https://www.piecesauto.com//common/seekCar?carid=$pacarid&language=fr" > patmp 2>/dev/null
paurl=`cat patmp`
#curl -s "https://www.piecesauto.com$paurl" > patmp
wget -qO- "https://www.piecesauto.com$paurl" > patmp 2>/dev/null
pa=`grep -A1 "$paurl#sommaire" patmp | sed -e 's/&nbsp;/ /g' -e 's/\t//g' | tr -d '\n' | awk -F'>|<' '{print $3}'`

# Nettoyage des accents
yak1=`echo $yak1 | sed 's/&Euml;/Ë/'`
yak1=`echo $yak1 | sed 's/&eacute;/é/'`

# SORTIE
newline=`echo -e "\n"`

# Oscaro
osctest=`echo $osc | awk -F"<|>| " '{print $3}'`
if [ "$osctest" = "HTML" ] || [ "$osctest" = "html" ] || [ "$osc" = "emptyIdPolTypesDictionnary" ] || [ "$osc" = "$newline" ]
	then echo -e "${V}- Oscaro\n${R}rien trouvé";oscflag=0
	else echo -e "${V}- Oscaro\n$J$osc$N";oscflag=1
fi

# Yakarouler
yaktest=`cat yaktmp | grep triangle | cut -d\  -f20`
if [ "$yaktest" = "aucun" ] || [ "$yak1" = "" ]
	then echo -e "${V}- Yakarouler\n${R}rien trouvé";yakaflag=0
	else echo -e "${V}- Yakarouler\n$J$yak1\nCode moteur $yak2$N";yakaflag=1
fi

# Pieces auto
patest=`echo $pa`
if [ "$patest" = "$newline" ]
	then echo -e "${V}- Pièces auto\n${R}rien trouvé$N";paflag=0
	else echo -e "${V}- Pièces auto\n$J$pa$N";paflag=1
fi


# Suppression des tmp et fermeture du IF "recup info"
rm osctmp yaktmp patmp
fi
fi

# Definition $model
if [ $oscflag = 1 ] || [ $yakaflag = 1 ] || [ $paflag = 1 ]
        then
        model=
        if [ $oscflag = 1 ]; then model=`echo $osc | awk -F' ' '{print $1" "$2" "$3" "$4" "$5}'`; yakaflag=0; paflag=0; fi
        if [ $yakaflag = 1 ]; then model=`echo $yak1 | awk -F' ' '{print $1" "$2" "$3" "$4" "$5}'`; paflag=0; fi
        if [ $paflag = 1 ]; then model=`echo $pa | awk -F' ' '{print $1" "$2" "$3" "$4" "$5}'`; fi
fi

if [ $oscflag = 0 ] && [ $yakaflag = 0 ] && [ $paflag = 0 ] && [ "$plk" != "h" ] && [ "$plk" != "sh" ] && [ "$plk" != "help" ] && [ "$plk" != "?" ] && [ "$plk" != "" ]
	then
	echo -e "\nAucune plaque trouvée !"
	sleep 2
fi

# Proposition de chercher la fiche technique (si auto) sur zeperf (beta)
if [ $type != M ]
then

if [ $oscflag = 1 ] || [ $yakaflag = 1 ] || [ $paflag = 1 ]
then
	echo; read -n1 -p "Fiche technique zeperf + autotitre ? (o/N) " ftch
	if [ "$ftch" = "o" ] || [ "$ftch" = "O" ]
	then
		if [ -f /c/Windows/explorer.exe ]; then cmdurl=explorer.exe; fi # MSYS2
		if [ -f ../usr/bin/termux-open ]; then cmdurl=termux-open; fi # Termux
		if [ -f /usr/bin/xdg-open ]; then cmdurl=xdg-open; fi # GNU/Linux
		if [ -z $cmdurl ]; then echo Aucun lanceur trouvé !; fi

		# Recherche sur zeperf avec Qwant, avec le 1er site qui a trouvé la plaque
		if [ $oscflag = 1 ]; then $cmdurl "https://lite.qwant.com/?q=site:zeperfs.com $model&t=web"; $cmdurl "https://www.autotitre.com/redir-ft.php?q=$model"; elif
		   [ $yakaflag = 1 ]; then $cmdurl "https://lite.qwant.com/?q=site:zeperfs.com $model&t=web"; $cmdurl "https://www.autotitre.com/redir-ft.php?q=$model"; elif
		   [ $paflag = 1 ]; then $cmdurl "https://lite.qwant.com/?q=site:zeperfs.com $model&t=web"; $cmdurl "https://www.autotitre.com/redir-ft.php?q=$model"; fi

	fi

fi

fi # test si != moto

# Ajout plaque en historique
if [ "$plk" != "h" ] && [ "$plk" != "sh" ] && [ "$plk" != "help" ] && [ "$plk" != "?" ] && [ "$plk" != "" ]
then

# Détection si plaque déjà recherchée, si oui ne pas la rajouter à nouveau
grep -q $plk ~/.plkh
if [ $? -eq 0 ]; then plkR=1; else plkR=0; fi

# Test si Moto (sinon Auto)
if [ $type = M ]
# Si Moto, juste mettre la plaque
then echo "$plk" >> ~/.plkhm

# Si Auto, mettre plaque et modele
else if [ $oscflag = 1 ] || [ $yakaflag = 1 ] || [ $paflag = 1 ]
	then
	if [ $plkR -eq 0 ]; then echo "$plk $model" >> ~/.plkh; fi
	fi
fi # fermeture test si Moto

fi # fermeture test si commande au lieu de plaque

if [ "$plk" = "?" ]; then echo;echo "Appuyer sur une touche pour revenir..."; read; fi

# Remise des flags à 0
oscflag=0; yakaflag=0; paflag=0

# Et on boucle !
done
