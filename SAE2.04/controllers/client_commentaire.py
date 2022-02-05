#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_commentaire = Blueprint('client_commentaire', __name__,
                        template_folder='templates')

@client_commentaire.route('/client/comment/add', methods=['POST'])
def client_comment_add():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    user_id = request.form.get('idUser', None)
    commentaire = request.form.get('commentaire', None)
    note = request.form.get('note', None)
    print(article_id)
    sql = "INSERT INTO Avis (commentaire, note) VALUES (%s, %s)"
    tuple_insert = (commentaire, note)
    mycursor.execute(sql, tuple_insert)
    mycursor.execute("SELECT last_insert_id() AS last_insert_id")
    id_avis = mycursor.fetchone()['last_insert_id']
    sql = "INSERT INTO depose VALUES (%s, %s, %s)"
    tuple_insert = (article_id, user_id, id_avis)
    mycursor.execute(sql, tuple_insert)
    get_db().commit()

    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))

@client_commentaire.route('/client/comment/delete', methods=['POST'])
def client_comment_detete():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    user_id = request.form.get('idUser', None)
    avis_id = request.form.get('idAvis', None)

    sql = "DELETE FROM depose WHERE id_velo = %s AND id_user = %s AND id_avis = %s"
    tuple_delete = (article_id, user_id, avis_id)
    mycursor.execute(sql, tuple_delete)

    sql = "DELETE FROM Avis WHERE id_avis = %s"
    mycursor.execute(sql, avis_id)

    get_db().commit()
    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))