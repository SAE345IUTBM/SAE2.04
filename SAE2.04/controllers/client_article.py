#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')      # remplace /client
def client_article_show():                                 # remplace client_index
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM Velo INNER JOIN Fournisseur ON Velo.id_fournisseur = Fournisseur.id_fournisseur ORDER BY id_velo")
    articles = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Type_velo")
    types_articles = mycursor.fetchall()
    sql = "SELECT * FROM panier INNER JOIN Velo ON panier.id_velo = Velo.id_velo WHERE id_user = %s"
    mycursor.execute(sql, session['user_id'])
    articles_panier = mycursor.fetchall()
    print(articles_panier)
    mycursor.execute("SELECT * FROM panier")
    print(mycursor.fetchall())
    sql = "SELECT SUM(Velo.prix_velo * panier.quantite_panier) AS prix_total FROM panier INNER JOIN Velo ON panier.id_velo = Velo.id_velo WHERE panier.id_user = %s"
    mycursor.execute(sql, session['user_id'])
    prix_total = mycursor.fetchone()['prix_total']
    print(prix_total)
    return render_template('client/boutique/panier_article.html', articles=articles, articlesPanier=articles_panier, prix_total=prix_total, itemsFiltre=types_articles)

@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    sql = "SELECT * FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id)
    article = mycursor.fetchall()
    commentaires=None
    commandes_articles=None
    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles)