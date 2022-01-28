DROP TABLE IF EXISTS etat,panier,ligne_commande,commande,user;

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

CREATE TABLE IF NOT EXISTS commande(
    id_commande INT AUTO_INCREMENT,
    date_achat DATE,
    id_user INT,
    id_etat INT,
    PRIMARY KEY (id_commande),
    CONSTRAINT fk_commande_user
        FOREIGN KEY(id_user) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS ligne_commande(
    id_commande INT,
    id_velo INT,
    prix_unitaire NUMERIC(7,2),
    quantite INT,
    CONSTRAINT fk_ligne_commande_commande
        FOREIGN KEY(id_commande) REFERENCES commande(id_commande),
    CONSTRAINT fk_ligne_commande_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo)
);

CREATE TABLE IF NOT EXISTS panier(
    id_panier INT AUTO_INCREMENT,
    date_ajout DATE,
    id_user INT,
    id_velo INT,
    prix_unit NUMERIC(7,2),
    quantite INT,
    PRIMARY KEY(id_panier),
    CONSTRAINT fk_panier_user
        FOREIGN KEY(id_user) REFERENCES user(id),
    CONSTRAINT fk_panier_velo
        FOREIGN KEY(id_velo) REFERENCES Velo(id_velo)
);

CREATE TABLE IF NOT EXISTS etat(
    id_etat INT AUTO_INCREMENT,
    libelle VARCHAR(255),
    PRIMARY KEY(id_etat)
);

INSERT INTO user (id, email, username, password, role,  est_actif) VALUES
(NULL, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1),
(NULL, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client', 1),
(NULL, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',1);
