CREATE TABLE Marque(
   id_marque INT AUTO_INCREMENT,
   libelle_marque VARCHAR(255),
   PRIMARY KEY(id_marque)
);

CREATE TABLE Couleur(
   id_couleur INT AUTO_INCREMENT,
   libelle_couleur VARCHAR(255),
   PRIMARY KEY(id_couleur)
);

CREATE TABLE Type_velo(
   id_type_velo INT AUTO_INCREMENT,
   libelle_type_velo VARCHAR(255) NOT NULL,
   PRIMARY KEY(id_type_velo)
);

CREATE TABLE Fournisseur(
   id_fournisseur INT AUTO_INCREMENT,
   libelle_fournisseur VARCHAR(255),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE utilisateur(
   id INT AUTO_INCREMENT,
   username VARCHAR(255),
   role VARCHAR(255),
   est_actif SMALLINT,
   pseudo VARCHAR(255),
   email VARCHAR(255),
   PRIMARY KEY(id)
);

CREATE TABLE Etat(
   id_etat INT AUTO_INCREMENT,
   libelle_etat VARCHAR(255),
   PRIMARY KEY(id_etat)
);

CREATE TABLE Materiaux(
   id_materiaux INT AUTO_INCREMENT,
   libelle_materiaux VARCHAR(255),
   PRIMARY KEY(id_materiaux)
);

CREATE TABLE Avis(
   id_avis INT AUTO_INCREMENT,
   commentaire VARCHAR(255),
   note DECIMAL(2,1),
   PRIMARY KEY(id_avis)
);

CREATE TABLE Velo(
   id_velo INT AUTO_INCREMENT,
   libelle_velo VARCHAR(255),
   taille_roues_velo DECIMAL(3,1),
   poids_velo DECIMAL(3,1),
   prix_velo DECIMAL(6,2),
   image_velo VARCHAR(255),
   stock_velo VARCHAR(50),
   id_materiaux INT NOT NULL,
   id_marque INT NOT NULL,
   id_couleur INT NOT NULL,
   id_fournisseur INT NOT NULL,
   id_type_velo INT NOT NULL,
   PRIMARY KEY(id_velo),
   FOREIGN KEY(id_materiaux) REFERENCES Materiaux(id_materiaux),
   FOREIGN KEY(id_marque) REFERENCES Marque(id_marque),
   FOREIGN KEY(id_couleur) REFERENCES Couleur(id_couleur),
   FOREIGN KEY(id_fournisseur) REFERENCES Fournisseur(id_fournisseur),
   FOREIGN KEY(id_type_velo) REFERENCES Type_velo(id_type_velo)
);

CREATE TABLE Commande(
   id_commande INT AUTO_INCREMENT,
   date_achat DATE,
   id_etat INT NOT NULL,
   id INT NOT NULL,
   PRIMARY KEY(id_commande),
   FOREIGN KEY(id_etat) REFERENCES Etat(id_etat),
   FOREIGN KEY(id) REFERENCES utilisateur(id)
);

CREATE TABLE Panier(
   id_panier INT AUTO_INCREMENT,
   date_ajout DATE,
   quantite_panier INT,
   id_velo INT NOT NULL,
   id INT NOT NULL,
   PRIMARY KEY(id_panier),
   FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
   FOREIGN KEY(id) REFERENCES utilisateur(id)
);

CREATE TABLE Ligne_commande(
   id_velo INT,
   id_commande INT,
   quantite INT,
   PRIMARY KEY(id_velo, id_commande),
   FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
   FOREIGN KEY(id_commande) REFERENCES Commande(id_commande)
);

CREATE TABLE Dépose(
   id_velo INT,
   id INT,
   id_avis INT,
   PRIMARY KEY(id_velo, id, id_avis),
   FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
   FOREIGN KEY(id) REFERENCES utilisateur(id),
   FOREIGN KEY(id_avis) REFERENCES Avis(id_avis)
);
