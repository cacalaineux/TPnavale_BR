Program navale;

uses crt;

//type enumération d'état des celules, bateaux, et flottes
TYPE
	etat=(vie,mort);

//type énumération de direction et de sens de la pose de bateau
TYPE
	Sens=(VH,VB,HG,HD);

//type de case de bateau représente les points de vie des bateaux, contient leur coordonnées
TYPE 
	celule = RECORD
		L :INTEGER;
		C :INTEGER;
		etat_case :etat;
		END;

//type de bateau à 1 pv, représente 1 point de vie de la flotte
TYPE
	flagada = RECORD
		PV1 :Celule;
		PV :INTEGER;
		etat_nav :etat;
		END;

//type de bateau à 2 points vie, représente 1 point de vie de la flotte
TYPE
	flougoudou = RECORD
		PV1 :celule;
		PV2 :celule;
		PV :INTEGER;
		etat_nav :etat;
		END;

//type de bateau à 3 points vie, représente 1 point de vie de la flotte
TYPE
	Flagadosse = RECORD
		PV1 :celule;
		PV2 :celule;
		PV3 :celule;
		PV :INTEGER;
		etat_nav :etat;
		END;

//type de flotte, donc de joueur
TYPE 
	flotte = RECORD
		unite1 :flagada;
		unite2 :flougoudou;
		unite3 :Flagadosse;
		PV :INTEGER;
		etat_flot :etat;
		ordre:INTEGER;
		END;



//but: initialisé les variables des joueurs.
//entre: les 2 joueurs de type flotte.
//sortie: les 2 variables joueurs initialisé.
PROCEDURE init (var joueur1,joueur2: flotte; coord: celule);
	VAR 
	BEGIN
		//init variable
		A:=1
		//parcours les différents bateaux des 2 flottes
		FOR i:=1 TO 3 DO
		BEGIN
			//parcours les differents champs des celules des bateaux
			FOR y:=1 TO A DO
			BEGIN
				//initialise les coordonées de chaque celules
				joueur1.unite,i.PV,A:=coord;
				joueur2.unite,i.PV,A:=coord;
			END;
			//incrémente pour parcourir les différents pv des bateaux
			A:=A+1

			//initialise les points de vie des bateaux à leur longueur
			joueur1.unite,i.PV:=A;
			joueur2.unite,i.PV:=A;

			//initialise l'etat des bateaux à vie
			joueur1.unite,i.etat_nav:=vie;
			joueur2.unite,i.etat_nav:=vie;
		END;
		//initialise les points de vie des joueurs au nombre de bateaux
		joueur1.PV:=3;
		joueur2.PV:=3;
		//initialise l'ordre des joueurs
		joueur1.ordre:=1;
		joueur1.ordre:=2;
	END;


//BUT: transférer la bonne flotte celon le tour de jeu
//ENTREES: les 2 flottes de joueur, et le tour de jeu
//SORTIES: la flotte qui correspond au tour de jeu
FUNCTION quel(joueur1,joueur2: flotte;nbT: INTEGER):flotte;
VAR joueur: flotte;
BEGIN
	joueur:=joueur1;
	//si le tour est paire, c'est le joueur numéros 2 qui joue
	If (nbT MOD 2 = 0) THEN
		joueur:=joueur2;

	flotte:=joueur;
END;


//BUT: verifie que la coordonnée donnée est valide
//ENTREE: Le joueur qui joue, la coordonnée entré par le joueur
//SORTIE: La validité de la coordonnée
FUNCTION verif (joueur: flotte; coord: celule): BOOLEAN; 
VAR A,cpt :INTEGER;
	okay :Boolean;
BEGIN
	//init variable
	okay:=TRUE;
	cpt:=0;
	A:=1;
	//si compris dans les limites du terrain cela regardera si la coordonnée est déjà utilisé
	If (coord.L>0 AND coord.L<11 AND coord.C>0 AND coord.C<11) THEN
		//la boucle qui incrémente les différents bateaux
		REPEAT
			//la boucle qui incrémente les pv des différents bateaux
			REPEAT
				cpt:=cpt+1;
				IF (coord=joueur.unite,A.PV,cpt) THEN //Tout marche sauf ça, je pense que c'est faut mais je ne sais pas comment faire autrement, avec la même logique.
				BEGIN
					okay:=FAUX;
				END;
			UNTIL ((cpt = A) OR (okay=FALSE));
			A:=A+1;
		UNTIL ((A=4) OR (okay=FALSE));

	ELSE
		okay:=FALSE;
	END;

	crea:=okay;
END;


//BUT: Verifier que le sens donnée par le joueur est correcte.
//ENTREES: le numéro du navire, les données du joueur, le sens choisie et la coordonnée donnée par le joueur.
//SORTIES: Si le sens et les coordonnées sont valide.
//UTILISE:verif.
FUNCTION verif_sens (num_nav:INTEGER;joueur:flotte;direc: sens; coord: celule): BOOLEAN;
VAR okay: BOOLEAN;
	cpt: INTEGER;
BEGIN
	//init les variables
	okay:=TRUE;
	cpt:=0;
	//verifie si la création devrait etre en vertical vers le haut
	IF (direct=VH) THEN
	BEGIN
		//verifie si la création verticale est possible
		IF (coord.C-num_nav>0) THEN
		BEGIN
			//verifie si la création n'emprinte pas de coordonnée déjà occupé
			REPEAT
				coord.C:=coord.C-1;
				IF (verif(joueur,coord)) THEN
				BEGIN
					cpt:=cpt+1
				ELSE
					okay:=FALSE;
				END;
			UNTIL (cpt=(num_nav-1)) OR (okay=FALSE);
		END;
	END;

	//verifie si la création devrait etre en vertical vers le haut
	IF (direct=VB) THEN
	BEGIN
		//verifie si la création verticale est possible
		IF (coord.C+num_nav<11) THEN
		BEGIN
			//verifie si la création n'emprinte pas de coordonnée déjà occupé
			REPEAT
				coord.C:=coord.C+1;
				IF (verif(joueur,coord)) THEN
				BEGIN
					cpt:=cpt+1
				ELSE
					okay:=FALSE;
				END;
			UNTIL (cpt=(num_nav-1)) OR (okay=FALSE);
		END;
	END;
	
	//verifie si la création devrait etre en horizontal vers la gauche
	IF (direct=HG) THEN
	BEGIN
		//verifie si la création horizontale est possible
		IF (coord.L-num_nav>0) THEN
		BEGIN
			//verifie si la création n'emprinte pas de coordonnée déjà occupé
			REPEAT
				coord.L:=coord.L-1;
				IF (verif(joueur,coord)) THEN
				BEGIN
					cpt:=cpt+1
				ELSE
					okay:=FALSE;
				END;
			UNTIL (cpt=(num_nav-1)) OR (okay=FALSE);
		END;
	END;

	//verifie si la création devrait etre en horizontal vers la droite
	IF (direct=VH) THEN
	BEGIN
		//verifie si la création horizontale est possible
		IF (coord.L+num_nav<11) THEN
		BEGIN
			//verifie si la création n'emprinte pas de coordonnée déjà occupé
			REPEAT
				coord.L:=coord.L+1;
				IF (verif(joueur,coord)) THEN
				BEGIN
					cpt:=cpt+1
				ELSE
					okay:=FALSE;
				END;
			UNTIL (cpt=(num_nav-1)) OR (okay=FALSE);
		END;
	END;
	verif_sens:=okay;
END;



{
Je ne l'utilise pas, je l'ai faite car c'étais demandé, mais je n'ai pas réussi dans ma réalisation de la bataille navale à l'utiliser.

//BUT:Compare 2 cases
//ENTREE:2 variable type celule
//SORTIE:1 boolean
//UTILISE:
FUNCTION Compare(coord,coord2: celule): BOOLEAN;
VAR okay: BOOLEAN;
begin
	//si les coordonnées cellules correspondent
	if (coord=coord2) then
		okay:=TRUE
	else
		okay:=FALSE;


	Compare:=okay;	
end;
}


//BUT: proceder au ajustement du à l'attaque du joueur
//ENTREES: la coordonnée d'attaque, et la flotte entrain de joué
//SORTIES:	la flotte avec les ajustements de l'attaque si touché
//UTILISE:
PROCEDURE Attaque_bateau(coord:celule;var joueur:flotte);
VAR okay: BOOLEAN.
	cpt,A: INTEGER;
BEGIN
	//init variable
	okay:=FALSE;
	//incrémente les bateaux
	REPEAT
		//incrémente les célules des bateaux
		REPEAT
			cpt:=cpt+1;
			//test si la coordonnée de l'attaque correspond à l'emplacement d'une case d'un des bateaux
			IF (coord=joueur.unite,A.PV,cpt) THEN
			BEGIN
				joueur.unite,A.PV,cpt.etat_case:=mort; //met l'état de la celule à mort
				joueur.unite,A.PV:=joueur.unite,A.PV-1;	//enleve 1 point de vie au bateau
				okay:=TRUE;	//met vrai pour sortir de la boucle si touché
				Writeln ('toucher');
				//si toute les celules sont touché et que l'état est encore en vie.
				IF ((joueur.unite,A.PV=0) AND (joueur.unite,A.etat_nav=vie)) THEN 
				BEGIN
					joueur.unite,A.etat_nav:=mort; //met l'état du bateau à mort
					Writeln ('couler');		
					joueur.PV:=joueur.PV-1;	//enleve 1 point de vie au joueur
				END;
			END;
		UNTIL ((cpt = A) OR (okay=TRUE)); // si touché ou si toute les celules ont été vérifié
	A:=A+1;
	UNTIL ((A=4) OR (okay=TRUE)); // si toucher ou si tout les bateaux ont été vérifié

	IF (okay=FALSE) THEN
		Writeln ('rater');

END;


//BUT: La création d'un navire, mis dans une flotte.
//ENTREES: La direction, le numéro du navire, la coordonnée.
//SORTIES: Un navire dans une flotte.
//UTILISE:
FUNCTION crea_nav(direc: sens;num_nav: INTEGER;coord: celule): flotte;
VAR inter: flotte;
BEGIN
	//Creer le bateau, En verticale vers le haut
	IF (direct=VH) THEN
	BEGIN
		FOR i:=0 TO num_nav DO
		BEGIN
			coord.C:=coord.C-i;
			inter.unite,num_nav.PV,i+1:=coord;
		END;
	END;
	//Creer le bateau, En verticale vers le bas
	IF (direct=VB) THEN
	BEGIN
		FOR i:=0 TO num_nav DO
		BEGIN
			coord.C:=coord.C+i;
			inter.unite,num_nav.PV,i+1:=coord;
		END;
	END;
	//Creer le bateau, En horizontal vers la gauche
	IF (direct=HG) THEN
	BEGIN
		FOR i:=0 TO num_nav DO
		BEGIN
			coord.L:=coord.L-i;
			inter.unite,num_nav.PV,i+1:=coord;
		END;
	END;
	//Creer le bateau, En horizontal vers la droite
	IF (direct=HD) THEN
	BEGIN
		FOR i:=0 TO num_nav DO
		BEGIN
			coord.L:=coord.L+i;
			inter.unite,num_nav.PV,i+1:=coord;
		END;
	END;

	crea_nav.unite,num_nav:=inter.unite,num_nav;
END;



VAR coord : celule;
	joueur1, joueur2, joueur:flotte;
	direct: sens;
	num_nav,nbT: INTEGER;


BEGIN
	//init variable
	coord.L:=0;
	coord.C:=0;
	coord.etat_case:=vie;
	init(joueur1,joueur2,coord);
	nbT:=0;
	num_nav:=1;
	//explication des règles
	Writeln ('C est une bataille navale qui se joue à 2, chacun à sa flotte de 3 bateau, le premier qui détruit les 3 bateaux de l autre à gagné');
	Writeln ('il y a un bateau de 1 case, 2 cases et 3 cases, vous allez donner leur position dans cette ordre');
	Writeln ('Sur une map de 10 sur 10, vous allez chacun votre tour donner la coordonnée du premier bloc de votre bateau puis la direction et le sens de son emplacement');
	REPEAT

		nbT:=nbT+1;
		joueur:=quel(joueur1,joueur2,nbT);

		//renseignement du tour
		Writeln ('joueur',joueur.ordre);

		//opération d'emplacement du 1 er bateau
		REPEAT
			Writeln ('entrez la coordonnée de votre premier bateau, colonne et ligne');
			Writeln ('elle doit être valide, compris entre 1 et 10 et ne pas avoir déja été utilisé')
			Readln (coord.C);
			Readln (coord.L);
		UNTIL (verif(coord));
		joueur.unite,num_nav.PV1:=coord;

		//opération d'emplacement du 2 eme bateau
		num_nav:=2;
		REPEAT
			Writeln ('entrez la coordonnée de votre second bateau, colonne et ligne');
			Writeln ('elle doit être valide, compris entre 1 et 10 et ne pas avoir déja été utilisé');
			Readln (coord.C);
			Readln (coord.L);

			Writeln ('entrez une direction de positionnement valide,colonne et ligne');
			Writeln ('cela implique que le positionnement doit rester dans le terrain et ne doit pas comprendre de case déjà occupé');
			Writeln ('Entrez VH, pour un positionnement verticale, en plaçant les cases vert le haut');
			Writeln ('Entrez VB, pour un positionnement verticale, en plaçant les cases vert le bas');
			Writeln ('Entrez HG, pour un positionnement horizontal, en plaçant les cases vert la gauche');
			Writeln ('Entrez HD, pour un positionnement horizontal, en plaçant les cases vert la droite');
			Readln (direct);
		UNTIL (verif(coord)) AND (verif_sens(num_nav,joueur,direct,coord));

		//opération d'emplacement du 3 eme bateau
		num_nav:=3;
		REPEAT
			Writeln ('entrez la coordonnée de votre second bateau, colonne et ligne');
			Writeln ('elle doit être valide, compris entre 1 et 10 et ne pas avoir déja été utilisé');
			Readln (coord.C);
			Readln (coord.L);

			Writeln ('entrez une direction de positionnement valide,colonne et ligne');
			Writeln ('cela implique que le positionnement doit rester dans le terrain et ne doit pas comprendre de case déjà occupé');
			Writeln ('Entrez VH, pour un positionnement verticale, en plaçant les cases vert le haut');
			Writeln ('Entrez VB, pour un positionnement verticale, en plaçant les cases vert le bas');
			Writeln ('Entrez HG, pour un positionnement horizontal, en plaçant les cases vert la gauche');
			Writeln ('Entrez HD, pour un positionnement horizontal, en plaçant les cases vert la droite');
			Readln (direct);
		UNTIL (verif(coord)) AND (verif_sens(num_nav,joueur,direct,coord));

		joueur,nbT:=joueur;
	UNTIL (nbT=2);

	//init variable pour débuter le jeu
	nbT:=1;
	joueur:=joueur1;
	//Boucle du tour de jeu
	REPEAT
		//init variable
		coord.C:=0;
		coord.L:=0;
		okay:=FALSE;

		//renseignement sur le tour
		Writeln ('tour numéros:',nbT);
		Writeln ('tour du joueur',joueur.ordre);

		//oblige la prise d'une bonne coordonnée
		REPEAT
			Writeln ('entrez la coordonnée de votre	attaque, colonne et ligne');
			Writeln ('elle doit être valide, compris entre 1 et 10 et ne pas avoir déja été utilisé');
			Readln (coord.C);
			Readln (coord.L);
		UNTIL (coord.L>0 AND coord.L<11 AND coord.C>0 AND coord.C<11) THEN

		//incrémente le nombre de tour
		nbT:=nbT+1;
		joueur:=quel(joueur1,joueur2,nbT);

		//appelle la procedure d'attaque
		Attaque_bateau(coord,joueur,okay);

		//retransmet les opérations éffectué chez le bon joueur
		IF (nbT MOD 2 = 0) THEN
			joueur2:=joueur
		ELSE
			joueur1:=joueur;

	UNTIL (joueur.PV=0); //jusuqua ce que l'un des joueur n'as plus aucun bateau
	//désigne le vainqueur
	IF (joueur.ordre=1) THEN
		Writeln ('le joueur',2,'à gagné')
	ELSE
		Writeln ('le joueur',1,'à gagné');

	Readln;

END.