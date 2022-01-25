CREATE TABLE Marque(
   id_marque INT AUTO INCREMENT,
   libelle_marque VARCHAR(255),
   logo_marque VARCHAR(255),
   PRIMARY KEY(id_marque)
);

CREATE TABLE Couleur(
   id_couleur INT AUTO INCREMENT,
   libelle_couleur VARCHAR(255),
   PRIMARY KEY(id_couleur)
);

CREATE TABLE Type_vélo(
   id_type_velo INT AUTO INCREMENT,
   libelle_type_velo VARCHAR(255) NOT NULL,
   PRIMARY KEY(id_type_velo)
);

CREATE TABLE Fournisseur(
   id_fournisseur INT AUTO INCREMENT,
   libelle_fournisseur VARCHAR(255),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE Vélo(
   id_velo INT AUTO INCREMENT,
   libelle_velo VARCHAR(255),
   modele_velo VARCHAR(255),
   taille_roues_velo DECIMAL(3,1),
   poids_velo DECIMAL(3,1),
   prix_velo DECIMAL(6,2),
   image_velo VARCHAR(255),
   id_marque INT NOT NULL,
   id_couleur INT NOT NULL,
   id_type_velo INT NOT NULL,
   PRIMARY KEY(id_velo),
   FOREIGN KEY(id_marque) REFERENCES Marque(id_marque),
   FOREIGN KEY(id_couleur) REFERENCES Couleur(id_couleur),
   FOREIGN KEY(id_type_velo) REFERENCES Type_vélo(id_type_velo)
);

CREATE TABLE Vendu(
   id_velo INT,
   id_fournisseur INT,
   PRIMARY KEY(id_velo, id_fournisseur),
   FOREIGN KEY(id_velo) REFERENCES Vélo(id_velo),
   FOREIGN KEY(id_fournisseur) REFERENCES Fournisseur(id_fournisseur)
)
