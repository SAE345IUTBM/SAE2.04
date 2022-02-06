#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    id_commande = request.form.get('idCommande', '')
    sql = "SELECT commande.id_commande AS id_commande, commande.id_etat AS id_etat, commande.date_achat AS date_achat, etat.libelle_etat AS libelle_etat, SUM(ligne_commande.quantite) AS nbr_articles, SUM(ligne_commande.quantite * ligne_commande.prix_unitaire) AS prix_total FROM commande INNER JOIN ligne_commande ON commande.id_commande = ligne_commande.id_commande INNER JOIN etat ON commande.id_etat = etat.id_etat GROUP BY commande.id_commande ORDER BY commande.date_achat DESC"
    mycursor.execute(sql)
    commandes = mycursor.fetchall()
    sql = "SELECT *, ligne_commande.prix_unitaire * ligne_commande.quantite AS prix_ligne FROM ligne_commande INNER JOIN Velo ON ligne_commande.id_velo = Velo.id_velo WHERE id_commande = %s"
    mycursor.execute(sql, id_commande)
    articles_commande = mycursor.fetchall()
    return render_template('admin/commandes/show.html', commandes=commandes, articles_commande=articles_commande)


@admin_commande.route('/admin/commande/valider', methods=['get','post'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    id_commande = request.form.get('idCommande', '')
    print("---------------------------------")
    print(id_commande)
    sql = "UPDATE commande SET id_etat = 2 WHERE id_commande = %s"
    mycursor.execute(sql, id_commande)
    get_db().commit()
    return redirect('/admin/commande/show') 
