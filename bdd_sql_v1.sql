DROP TABLE IF EXISTS Depose, commande, etat, panier, ligne_commande, user, Velo, Fournisseur, Type_velo, Couleur, Marque;

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

CREATE TABLE Depose(
   id_velo INT,
   id INT,
   id_avis INT,
   PRIMARY KEY(id_velo, id, id_avis),
   FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
   FOREIGN KEY(id) REFERENCES utilisateur(id),
   FOREIGN KEY(id_avis) REFERENCES Avis(id_avis)
);

INSERT INTO Marque VALUES
(NULL, 'Cannondale'),
(NULL, 'BMC'),
(NULL, 'Lapierre'),
(NULL, 'Btwin'),
(NULL, 'Pinarello'),
(NULL, 'Nakamura'),
(NULL, 'Rockrider'),
(NULL, 'Trek');

INSERT INTO Couleur VALUES
(NULL, 'Noir'),
(NULL, 'Blanc'),
(NULL, 'Gris'),
(NULL, 'Jaune'),
(NULL, 'Vert'),
(NULL, 'Bleu'),
(NULL, 'Rouge'),
(NULL, 'Sable');

INSERT INTO Type_velo VALUES
(NULL, 'VTT'),
(NULL, 'VTC'),
(NULL, 'Route');

INSERT INTO Fournisseur VALUES
(NULL, 'Decathlon'),
(NULL, 'Intersport'),
(NULL, 'Alltricks'),
(NULL, 'Wareega'),
(NULL, 'Probikeshop'),
(NULL, 'Bikester');

INSERT INTO Materiaux VALUES
(NULL, 'Aluminium'),
(NULL, 'Acier'),
(NULL, 'Carbone'),
(NULL, 'Titane');

INSERT INTO Velo VALUES
(NULL, 'Dirt Jump Dave', 31, 8, 1100, 'Cannondale_1.png', 4219, 1, 3, 1, 2, 4),
(NULL, 'F-Si Carbon 5', 31, 8, 1800, 'Cannondale_2.png', 3830, 1, 4, 1, 3, 4),
(NULL, 'Team Machine SLR', 29, 7.1, 8999, 'BMC_1.png', 737, 2, 3, 3, 5, 3),
(NULL, 'Road Machine', 29, 7.1, 4899, 'BMC_2.png', 1152, 2, 8, 3, 6, 3),
(NULL, 'Edge 3.9', 29, 11, 599, 'Lapierre_1.jpg', 11072,  3, 3, 1, 3, 1),
(NULL, 'Xelius 8.0', 31, 9, 5399, 'Lapierre_2.png', 2384, 3, 7, 3, 5, 3),
(NULL, 'Riverside 500', 26, 15, 299, 'Btwin_1.jpg', 18411, 4, 3, 2, 1, 2),
(NULL, 'GAN Dura-Ace', 29, 10, 4999, 'Pinarello_1.jpg', 2139, 5, 1, 3, 3, 3),
(NULL, 'X2', 28, 11, 399, 'Nakamura_1.png', 16486, 6, 1, 2, 2, 1),
(NULL, 'E-ST 100', 27.5, 22.5, 999, 'Rockrider_1.jpg', 6423, 7, 6, 1, 1, 1),
(NULL, 'E-ST 520', 27.5, 22.7, 1799, 'Rockrider_2.jpg', 3159, 7, 2, 1, 1, 1),
(NULL, 'E-ST 500', 27.5, 22.2, 1299, 'Rockrider_3.jpg', 3840, 7, 6, 1, 1, 1),
(NULL, 'MARLIN 8 SRAM SX', 27.5, 13.2, 1024, 'Trek_1.jpg', 7108, 8, 7, 1, 6, 1),
(NULL, 'Verve+ 3', 29, 24, 3000, 'Trek_2.png', 1982, 7, 3, 2, 4, 1);

INSERT INTO user (id, email, username, password, role,  est_actif) VALUES
(NULL, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1),
(NULL, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client', 1),
(NULL, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',1);
