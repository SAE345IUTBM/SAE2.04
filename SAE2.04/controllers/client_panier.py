#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

from datetime import datetime

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id = request.form.get('idArticle', '')
    quantite = request.form.get('quantite', '')
    if quantite == '':
        quantite = 0
    if int(quantite) > 0:
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
            sql = "INSERT INTO panier VALUES (NULL, %s, %s, %s, %s)"
            date_panier = datetime.now().strftime('%Y-%m-%d %H/%M:%S')
            tuple_panier = (date_panier, quantite, session['user_id'], id)
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
    sql = "SELECT * FROM panier WHERE id_user = %s"
    mycursor.execute(sql, session['user_id'])
    panier = mycursor.fetchall()
    for item in panier:
        qte = item['quantite_panier']
        id_velo = item['id_velo']
        sql = "SELECT stock_velo FROM Velo WHERE id_velo = %s"
        mycursor.execute(sql, id_velo)
        stock_velo = mycursor.fetchone()['stock_velo']
        sql = "UPDATE Velo SET stock_velo = %s WHERE id_velo = %s"
        tuple_velo = (stock_velo + qte, id_velo)
        mycursor.execute(sql, tuple_velo)

    sql = "DELETE FROM panier WHERE id_user = %s"
    mycursor.execute(sql, session['user_id'])
    get_db().commit()
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    id = request.form.get('idArticle', '')
    sql = "SELECT id_panier, quantite_panier FROM panier WHERE id_velo = %s AND id_user = %s"
    tuple_panier = (id, session['user_id'])
    mycursor.execute(sql, tuple_panier)

    panier = mycursor.fetchone()
    id_panier = panier['id_panier']
    qte = panier['quantite_panier']

    sql = "SELECT stock_velo FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id)
    stock = mycursor.fetchone()['stock_velo']

    sql = "UPDATE Velo SET stock_velo = %s WHERE id_velo = %s"
    tuple_velo = (stock + qte, id)
    mycursor.execute(sql, tuple_velo)

    sql = "DELETE FROM panier WHERE id_panier = %s"
    mycursor.execute(sql, id_panier)

    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    # SQL
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)

    print('word:' + filter_word + str(len(filter_word)))
    if filter_word or filter_word == '':
        if len(filter_word) > 1:
            if filter_word.isalpha():
                session['filter_word'] = filter_word
            else:
                flash(u'Votre mot recherché doit uniquement être composé de lettres')
        else:
            if len(filter_word) == 1:
                flash(u'votre mot recherché doit être composé de au moins 2 lettres')
            else:
                session.pop('filter_word', None)
    if filter_prix_min or filter_prix_max:
        if filter_prix_min.isdecimal() and filter_prix_max.isdecimal():
            if int(filter_prix_min) < int(filter_prix_max):
                session['filter_prix_min'] = filter_prix_min
                session['filter_prix_max'] = filter_prix_max
            else:
                flash(u'min < max')
        else:
            flash(u'min et max doivent être des numériques')
    if filter_types and filter_types != []:
        print('filter_types:', filter_types)
        if isinstance(filter_types, list):
            check_filter_type = True
            for number_type in filter_types:
                print('test', number_type)
                if not number_type.isdecimal():
                    check_filter_type = False
            if check_filter_type:
                session['filter_types'] = filter_types

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
