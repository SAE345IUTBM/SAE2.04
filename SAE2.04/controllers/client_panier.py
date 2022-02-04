#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id = request.form.get('idArticle', '')
    quantite = request.form.get('quantite', '')
    sql = "SELECT id_panier, quantite_panier FROM panier WHERE id_user = %s AND id_velo = %s"
    tuple_1 = (session['user_id'], id)
    mycursor.execute(sql, tuple_1)
    resultat = mycursor.fetchone()
    if resultat is not None:
        qte = resultat['quantite_panier']
        id_pan = resultat['id_panier']
        sql = "UPDATE panier SET quantite_panier = %s WHERE id_panier = %s"
        tuple_panier = (qte + int(quantite), id_pan)
    else:
        sql = "INSERT INTO panier VALUES (NULL, NOW(), %s, %s, %s)"
        tuple_panier = (quantite, session['user_id'], id)
    mycursor.execute(sql, tuple_panier)
    sql = "SELECT stock_velo FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id)
    stock = mycursor.fetchone()['stock_velo']
    sql = "UPDATE Velo SET stock_velo = %s WHERE id_velo = %s"
    tuple_update = (int(stock) - int(quantite), id)
    mycursor.execute(sql, tuple_update)
    get_db().commit()
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))

@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id = request.form.get('idArticle', '')
    sql = "SELECT id_panier, quantite_panier FROM panier WHERE id_user = %s AND id_velo = %s"
    tuple_1 = (session['user_id'], id)
    mycursor.execute(sql, tuple_1)
    resultat = mycursor.fetchone()
    if resultat['quantite_panier'] == 1:
        sql = "DELETE FROM panier WHERE id_panier = %s"
        mycursor.execute(sql, resultat['id_panier'])
    else:
        sql = "UPDATE panier SET quantite_panier = %s WHERE id_panier = %s"
        tuple_panier = (int(resultat['quantite_panier']) - 1, resultat['id_panier'])
        mycursor.execute(sql, tuple_panier)
    sql = "SELECT stock_velo FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id)
    stock = mycursor.fetchone()['stock_velo']
    sql = "UPDATE Velo SET stock_velo = %s"
    mycursor.execute(sql, int(stock) + 1)
    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    mycursor = get_db().cursor()
    sql = "DELETE FROM panier WHERE id_user = %s"
    mycursor.execute(sql, session['user_id'])
    get_db().commit()
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    # SQL
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    print("suppr filtre")
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))
