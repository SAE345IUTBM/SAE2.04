DROP TABLE IF EXISTS donne, depose, ligne_commande, commande, etat, panier, user, defini, Avis, Velo, Materiaux, Fournisseur, Type_velo, Couleur, Marque;

CREATE TABLE IF NOT EXISTS Marque(
    id_marque INT NOT NULL AUTO_INCREMENT,
    libelle_marque VARCHAR(255),
    PRIMARY KEY(id_marque)
);

CREATE TABLE IF NOT EXISTS Couleur(
    id_couleur INT NOT NULL AUTO_INCREMENT,
    libelle_couleur VARCHAR(255),
    PRIMARY KEY(id_couleur)
);

CREATE TABLE IF NOT EXISTS Type_velo(
    id_type_velo INT NOT NULL AUTO_INCREMENT,
    libelle_type_velo VARCHAR(255) NOT NULL,
    PRIMARY KEY(id_type_velo)
);

CREATE TABLE IF NOT EXISTS Fournisseur(
    id_fournisseur INT NOT NULL AUTO_INCREMENT,
    libelle_fournisseur VARCHAR(255),
    PRIMARY KEY(id_fournisseur)
);

CREATE TABLE IF NOT EXISTS Materiaux(
   id_materiaux INT AUTO_INCREMENT,
   libelle_materiaux VARCHAR(255),
   PRIMARY KEY(id_materiaux)
);

CREATE TABLE IF NOT EXISTS Velo(
    id_velo INT NOT NULL AUTO_INCREMENT,
    libelle_velo VARCHAR(255),
    taille_roues_velo DECIMAL(3,1),
    poids_velo DECIMAL(3, 1),
    prix_velo DECIMAL(6,2),
    id_marque INT NOT NULL,
    id_type_velo INT NOT NULL,
    id_fournisseur INT NOT NULL,
    id_materiaux INT NOT NULL,
    PRIMARY KEY(id_velo),
    CONSTRAINT fk_marque_velo
       FOREIGN KEY (id_marque) REFERENCES Marque(id_marque),
    CONSTRAINT fk_type_velo_velo
        FOREIGN KEY(id_type_velo) REFERENCES Type_velo(id_type_velo),
    CONSTRAINT fk_fournisseur_velo
        FOREIGN KEY(id_fournisseur) REFERENCES Fournisseur(id_fournisseur),
    CONSTRAINT fk_materiaux_velo
        FOREIGN KEY(id_materiaux) REFERENCES Materiaux(id_materiaux)
);

CREATE TABLE IF NOT EXISTS defini (
    id_velo INT,
    id_couleur INT,
    stock_velo INT,
    image_velo VARCHAR(255),
    PRIMARY KEY (id_velo, id_couleur),
    CONSTRAINT fk_velo_defini
        FOREIGN KEY (id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_couleur_defini
        FOREIGN KEY (id_couleur) REFERENCES Couleur(id_couleur)
);

CREATE TABLE IF NOT EXISTS Avis(
    id_avis INT AUTO_INCREMENT,
    commentaire VARCHAR(255),
    PRIMARY KEY(id_avis)
 );

CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT,
    email VARCHAR(255),
    username VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255),
    est_actif TINYINT(1),
    pseudo VARCHAR(255),
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS etat(
    id_etat INT AUTO_INCREMENT,
    libelle_etat VARCHAR(255),
    PRIMARY KEY(id_etat)
);

CREATE TABLE IF NOT EXISTS commande(
    id_commande INT AUTO_INCREMENT,
    date_achat DATE,
    id_user INT,
    id_etat INT,
    PRIMARY KEY (id_commande),
    CONSTRAINT fk_commande_user
        FOREIGN KEY(id_user) REFERENCES user(id),
    CONSTRAINT fk_commande_etat
        FOREIGN KEY(id_etat) REFERENCES etat(id_etat)
);

CREATE TABLE IF NOT EXISTS ligne_commande(
    id_commande INT,
    id_velo INT,
    id_couleur INT,
    prix_unitaire NUMERIC(7,2),
    quantite INT,
    CONSTRAINT fk_ligne_commande_commande
        FOREIGN KEY(id_commande) REFERENCES commande(id_commande),
    CONSTRAINT fk_ligne_commande_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_ligne_commande_couleur
        FOREIGN KEY(id_couleur) REFERENCES Couleur(id_couleur)
);

CREATE TABLE IF NOT EXISTS panier(
    id_panier INT AUTO_INCREMENT,
    date_ajout DATE,
    quantite_panier INT,
    id_user INT,
    id_velo INT,
    id_couleur INT,
    PRIMARY KEY(id_panier),
    CONSTRAINT fk_panier_user
        FOREIGN KEY(id_user) REFERENCES user(id),
    CONSTRAINT fk_panier_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_panier_couleur
        FOREIGN KEY(id_couleur) REFERENCES Couleur(id_couleur)
);

CREATE TABLE IF NOT EXISTS depose(
    id_velo INT,
    id_user INT,
    id_avis INT,
    PRIMARY KEY(id_velo, id_user, id_avis),
    CONSTRAINT fk_depose_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_deposse_user
        FOREIGN KEY(id_user) REFERENCES user(id),
    CONSTRAINT fk_depose_avis
        FOREIGN KEY(id_avis) REFERENCES Avis(id_avis)
 );

CREATE TABLE IF NOT EXISTS donne(
    id_velo INT,
    id_user INT,
    note DECIMAL(2, 1),
    PRIMARY KEY(id_velo, id_user),
    CONSTRAINT fk_donne_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_donne_user
        FOREIGN KEY(id_user) REFERENCES user(id)
);

INSERT INTO Marque VALUES
(NULL, 'Cannondale'),
(NULL, 'BMC'),
(NULL, 'Lapierre'),
(NULL, 'Btwin'),
(NULL, 'Pinarello'),
(NULL, 'Nakamura'),
(NULL, 'Rockrider'),
(NULL, 'Trek'),
(NULL, 'Canyon');

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
(NULL, 'Dirt Jump Dave', 31, 8, 1100, 1, 1, 2, 4),
(NULL, 'F-Si Carbon 5', 31, 8, 1800, 1, 1, 3, 4),
(NULL, 'Team Machine SLR', 29, 7.1, 8999, 2, 3, 5, 3),
(NULL, 'Road Machine', 29, 7.1, 4899, 2, 3, 6, 3),
(NULL, 'Edge 3.9', 29, 11, 599, 3, 1, 3, 1),
(NULL, 'Xelius 8.0', 31, 9, 5399, 3, 3, 5, 3),
(NULL, 'Riverside 500', 26, 15, 299, 4, 2, 1, 2),
(NULL, 'GAN Dura-Ace', 29, 10, 4999, 5, 3, 3, 3),
(NULL, 'X2', 28, 11, 399, 6, 2, 2, 1),
(NULL, 'E-ST 100', 27.5, 22.5, 999, 7, 1, 1, 1),
(NULL, 'E-ST 520', 27.5, 22.7, 1799, 7, 1, 1, 1),
(NULL, 'E-ST 500', 27.5, 22.2, 1299, 7, 1, 1, 1),
(NULL, 'MARLIN 8 SRAM SX', 27.5, 13.2, 1024, 8, 1, 6, 1),
(NULL, 'Verve+ 3', 29, 24, 3000, 8, 2, 4, 1),
(NULL, 'Lux Trail CF 7', 29, 11.7, 4299, 9, 1, 5, 3);


INSERT INTO defini VALUES
(1, 3, 4219, 'Cannondale_1.png'),
(2, 4, 3781, 'Cannondale_2.png'),
(3, 3, 753, 'BMC_1.png'),
(4, 8, 1128, 'BMC_2.png'),
(5, 3, 6212, 'Lapierre_1.jpg'),
(6, 7, 977, 'Lapierre_2.png'),
(7, 3, 17544, 'Btwin_1.jpg'),
(8, 1, 951, 'Pinarello_1.jpg'),
(9, 1, 14816, 'Nakamura_1.png'),
(10, 6, 5294, 'Rockrider_1.jpg'),
(11, 2, 3105, 'Rockrider_2.jpg'),
(12, 6, 3843, 'Rockrider_3.jpg'),
(13, 7, 7667, 'Trek_1.jpg'),
(14, 3, 2437, 'Trek_2.png'),
(15, 2, 1931, 'Canyon_1.jpeg'),
(15, 3, 1485, 'Canyon_2.jpeg');

INSERT INTO user (id, email, username, password, role,  est_actif) VALUES
(NULL, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1),
(NULL, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client', 1),
(NULL, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',1);

INSERT INTO etat (libelle_etat) VALUES
('En attente'),
('Expédié'),
('Validé'),
('Confirmé');
