#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()
    sql = "SELECT * FROM panier WHERE id_user = %s"
    mycursor.execute(sql, session['user_id'])
    panier = mycursor.fetchall()
    if panier is None or len(panier) < 1:
        flash(u'Pad d\'articles dans le panier')
        return redirect('/client/article/show')

    sql = "INSERT INTO commande(date_achat, id_user, id_etat) VALUES (%s, %s, %s)"
    date_commande = datetime.now().strftime('%Y-%m-%d %H/%M:%S')
    tuple_insert = (date_commande, session['user_id'], 1)
    mycursor.execute(sql, tuple_insert)
    mycursor.execute("SELECT last_insert_id() as last_insert_id")
    commande_id = mycursor.fetchone()

    for item in panier:
        tuple_insert = (session['user_id'], item['id_velo'])
        sql = "DELETE FROM panier WHERE id_user = %s AND id_velo = %s"
        mycursor.execute(sql, tuple_insert)
        sql = "SELECT prix_velo FROM Velo WHERE id_velo = %s"
        mycursor.execute(sql, item['id_velo'])
        prix = mycursor.fetchone()
        sql = "INSERT INTO ligne_commande(id_commande, id_velo, id_couleur, prix_unitaire, quantite) VALUES (%s, %s, %s, %s, %s)"
        tuple_insert = (commande_id['last_insert_id'], item['id_velo'], item['id_couleur'], prix['prix_velo'], item['quantite_panier'])
        mycursor.execute(sql, tuple_insert)

    get_db().commit()
    flash(u'Commande ajoutée')
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_commande = request.form.get('idCommande', '')
    sql = "SELECT commande.id_commande AS id_commande, commande.id_etat AS id_etat, commande.date_achat AS date_achat, etat.libelle_etat AS libelle_etat, SUM(ligne_commande.quantite) AS nbr_articles, SUM(ligne_commande.quantite * ligne_commande.prix_unitaire) AS prix_total FROM commande INNER JOIN ligne_commande ON commande.id_commande = ligne_commande.id_commande INNER JOIN etat ON commande.id_etat = etat.id_etat WHERE id_user = %s GROUP BY commande.id_commande ORDER BY commande.date_achat DESC"
    mycursor.execute(sql, session['user_id'])
    commandes = mycursor.fetchall()
    sql = "SELECT *, ligne_commande.prix_unitaire * ligne_commande.quantite AS prix_ligne FROM ligne_commande INNER JOIN Velo ON ligne_commande.id_velo = Velo.id_velo INNER JOIN Couleur ON ligne_commande.id_couleur = Couleur.id_couleur WHERE id_commande = %s"
    mycursor.execute(sql, id_commande)
    articles_commande = mycursor.fetchall()
    print(articles_commande)
    return render_template('client/commandes/show.html', commandes=commandes, articles_commande=articles_commande)

