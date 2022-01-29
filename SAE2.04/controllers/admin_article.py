#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                        template_folder='templates')

@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM Velo INNER JOIN Type_velo ON Velo.id_type_velo = Type_velo.id_type_velo INNER JOIN Marque ON Velo.id_marque = Marque.id_marque INNER JOIN Couleur ON Velo.id_couleur = Couleur.id_couleur ORDER BY id_velo")
    articles = mycursor.fetchall()
    return render_template('admin/article/show_article.html', articles=articles)

@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM Marque")
    marque = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Couleur")
    couleur = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Type_velo")
    type_velo = mycursor.fetchall()
    return render_template('admin/article/add_article.html', marque=marque, couleur=couleur, type_velo=type_velo)

@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    nom_velo = request.form.get('nom_velo', '')
    taille_roues = float(request.form.get('taille_roues', ''))
    poids_velo = float(request.form.get('poids_velo', ''))
    prix_velo = float(request.form.get('prix_velo', ''))
    # stock = request.form.get('stock', '')
    id_marque = int(request.form.get('id_marque', ''))
    id_couleur = int(request.form.get('id_couleur', ''))
    id_type_velo = int(request.form.get('id_type_velo', ''))
    image_velo = request.form.get('image_velo', '')
    stock_velo = request.form.get('stock_velo', '')

    sql = "INSERT INTO Velo VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    tuple_velo = (nom_velo, taille_roues, poids_velo, prix_velo, image_velo, stock_velo, id_marque, id_couleur, id_type_velo)
    print(tuple_velo)
    mycursor = get_db().cursor()
    mycursor.execute(sql, tuple_velo)
    get_db().commit()

    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/delete')
def delete_article():
    mycursor = get_db().cursor()
    # id = request.args.get('id', '')
    id_velo = request.args.get('id_velo', '')
    sql = "DELETE FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id_velo)
    get_db().commit()
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/edit/<int:id>', methods=['GET'])
def edit_article(id):
    mycursor = get_db().cursor()
    sql = "SELECT * FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id)
    velo = mycursor.fetchone()
    mycursor.execute("SELECT * FROM Marque")
    marque = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Couleur")
    couleur = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Type_velo")
    type_velo = mycursor.fetchall()
    return render_template('admin/article/edit_article.html', velo=velo, marque=marque, couleur=couleur, type_velo=type_velo)

@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    nom_velo = request.form['nom_velo']
    id_velo = int(request.form.get('id_velo', ''))
    taille_roues = float(request.form.get('taille_roues', ''))
    poids_velo = float(request.form.get('poids_velo', ''))
    prix_velo = float(request.form.get('prix_velo', ''))
    # stock_velo = request.form.get('stock_velo', '')
    id_marque = int(request.form.get('id_marque', ''))
    id_couleur = int(request.form.get('id_couleur', ''))
    id_type_velo = int(request.form.get('id_type_velo', ''))
    image_velo = request.form.get('image_velo', '')
    stock_velo = request.form.get('stock_velo', '')

    mycursor = get_db().cursor()
    sql = "UPDATE Velo SET libelle_velo = %s, taille_roues_velo = %s, poids_velo = %s, prix_velo = %s, id_marque = %s, id_couleur = %s, id_type_velo = %s, image_velo = %s, stock_velo = %s WHERE id_velo = %s"
    tuple_velo = (nom_velo, taille_roues, poids_velo, prix_velo, id_marque, id_couleur, id_type_velo, image_velo, stock_velo, id_velo)
    mycursor.execute(sql, tuple_velo)
    get_db().commit()

    return redirect(url_for('admin_article.show_article'))
