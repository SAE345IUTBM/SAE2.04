#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_type_article = Blueprint('admin_type_article', __name__,
                        template_folder='templates')

@admin_type_article.route('/admin/type-article/show')
def show_type_article():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT Type_velo.id_type_velo, Type_velo.libelle_type_velo, COUNT(Velo.id_velo) AS nb_velo FROM Type_velo LEFT JOIN Velo ON Type_velo.id_type_velo = Velo.id_type_velo GROUP BY Type_velo.id_type_velo")
    types_articles = mycursor.fetchall()
    print(types_articles)
    return render_template('admin/type_article/show_type_article.html', types_articles=types_articles)

@admin_type_article.route('/admin/type-article/add', methods=['GET'])
def add_type_article():
    return render_template('admin/type_article/add_type_article.html')

@admin_type_article.route('/admin/type-article/add', methods=['POST'])
def valid_add_type_article():
    mycursor = get_db().cursor()
    libelle = request.form.get('nom_type_velo', '')
    sql = "INSERT INTO Type_velo VALUES (NULL, %s)"
    mycursor.execute(sql, libelle)
    get_db().commit()
    return redirect('/admin/type-article/show') #url_for('show_type_article')

@admin_type_article.route('/admin/type-article/delete')
def delete_type_article():
    mycursor = get_db().cursor()
    id_type_velo = request.args.get('id_type_velo', '')
    id_velo = request.args.get('id_velo', '')
    print(id_velo)
    sql = "DELETE FROM Velo WHERE id_velo = %s"
    mycursor.execute(sql, id_velo)
    get_db().commit()
    sql = "SELECT libelle_velo, stock_velo, id_velo, id_type_velo FROM Velo WHERE id_type_velo = %s"
    mycursor.execute(sql, id_type_velo)
    velo = mycursor.fetchall()
    sql = "SELECT COUNT(id_velo) AS nbr_articles FROM Velo WHERE id_type_velo = %s GROUP BY id_type_velo"
    mycursor.execute(sql, id_type_velo)
    nbr_articles = mycursor.fetchone()
    print(velo)
    if len(velo) > 0:
        return render_template('admin/type_article/delete_type_article.html', velo=velo, nbr_articles=nbr_articles)

    else:
        sql = "DELETE FROM Type_velo WHERE id_type_velo = %s"
        mycursor.execute(sql, id_type_velo)
        get_db().commit()
        return redirect('/admin/type-article/show') #url_for('show_type_article')

@admin_type_article.route('/admin/type-article/edit/<int:id>', methods=['GET'])
def edit_type_article(id):
    mycursor = get_db().cursor()
    sql = "SELECT * FROM Type_velo WHERE id_type_velo = %s"
    mycursor.execute(sql, id)
    type_velo = mycursor.fetchone()
    return render_template('admin/type_article/edit_type_article.html', type_velo=type_velo)

@admin_type_article.route('/admin/type-article/edit', methods=['POST'])
def valid_edit_type_article():
    mycursor = get_db().cursor()
    id = request.form.get('id_type_velo')
    libelle = request.form.get('nom_type_velo')
    sql = "UPDATE Type_velo SET libelle_type_velo = %s WHERE id_type_velo = %s"
    tuple_type_velo = (libelle, id)
    mycursor.execute(sql, tuple_type_velo)
    get_db().commit()
    return redirect('/admin/type-article/show') #url_for('show_type_article')







