DROP TABLE IF EXISTS Vendu, Velo, Fournisseur, Type_velo, Couleur, Marque;

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

CREATE TABLE IF NOT EXISTS Velo(
    id_velo INT NOT NULL AUTO_INCREMENT,
    libelle_velo VARCHAR(255),
    taille_roues_velo DECIMAL(3,1),
    poids_velo DECIMAL(3, 1),
    prix_velo DECIMAL(6,2),
    image_velo VARCHAR(255),
    id_marque INT NOT NULL,
    id_couleur INT NOT NULL,
    id_type_velo INT NOT NULL,
    PRIMARY KEY(id_velo),
    CONSTRAINT fk_marque_velo
       FOREIGN KEY (id_marque) REFERENCES Marque(id_marque),
    CONSTRAINT fk_couleur_velo
       FOREIGN KEY(id_couleur) REFERENCES Couleur(id_couleur),
    CONSTRAINT fk_type_velo_velo
        FOREIGN KEY(id_type_velo) REFERENCES Type_velo(id_type_velo)
);

CREATE TABLE Vendu(
    id_velo INT NOT NULL,
    id_fournisseur INT NOT NULL,
    PRIMARY KEY(id_velo, id_fournisseur),
    CONSTRAINT fk_vente_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo),
    CONSTRAINT fk_fournisseur_velo
        FOREIGN KEY(id_fournisseur) REFERENCES Fournisseur(id_fournisseur)
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

INSERT INTO Velo VALUES 
(NULL, 'Dirt Jump Dave', 31, 8, 1100, 'Cannondale_1.png', 1, 3, 1),
(NULL, 'F-Si Carbon 5', 31, 8, 1800, 'Cannondale_2.png', 1, 4, 1),
(NULL, 'Team Machine SLR', 29, 7.1, 8999, 'BMC_1.png', 2, 3, 3),
(NULL, 'Road Machine', 29, 7.1, 4899, 'BMC_2.png', 2, 8, 3),
(NULL, 'Edge 3.9', 29, 11, 599, 'Lapierre_1.jpg', 3, 3, 1),
(NULL, 'Xelius 8.0', 31, 9, 5399, 'Lapierre_2.png', 3, 7, 3),
(NULL, 'Riverside 500', 26, 15, 299, 'Btwin_1.jpg', 4, 3, 2),
(NULL, 'GAN Dura-Ace', 26, 10, 299, 'Pinarello_1.jpg', 5, 1, 3),
(NULL, 'X2', 28, 11, 399, 'Nakamura_1.jpg', 6, 1, 2),
(NULL, 'E-ST 100', 27.5, 22.5, 999, 'Rockrider_1.jpg', 7, 6, 1),
(NULL, 'E-ST 520', 27.5, 22.7, 1799, 'Rockrider_2.jpg', 7, 2, 1),
(NULL, 'E-ST 500', 27.5, 22.2, 1299, 'Rockrider_3.jpg', 7, 6, 1),
(NULL, 'MARLIN 8 SRAM SX', 27.5, 13.2, 1024, 'Trek_1.jpg', 8, 7, 1),
(NULL, 'Verve+ 3', 29, 24, 3000, 'Trek_1.jpg', 7, 3, 2);
