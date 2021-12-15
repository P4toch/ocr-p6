#! /usr/bin/env python

import os
import json
from flask import Flask, request, Response  # pip3 install flask
from pymongo import MongoClient  # pip3 install pymongo

app = Flask(__name__)

_MONGO_CLIENT = None
_MONGODB_HOST = os.getenv('MONGODB_PRIVATE_IP')
_MONGODB_PORT = 27017
_MONGODB_USERNAME = 'python'
_MONGODB_PASSWORD = 'python-pwd'
_MONGODB_AUTH_SOURCE = 'ocr'
_MONGODB_COLLECTION = None
_MONGODB_COLLECTION_NAME = 'ocr.ligue1'


def mongodb_connect():
    global _MONGO_CLIENT
    global _MONGODB_HOST, _MONGODB_PORT
    global _MONGODB_USERNAME, _MONGODB_PASSWORD, _MONGODB_AUTH_SOURCE
    global _MONGODB_COLLECTION, _MONGODB_COLLECTION_NAME

    if _MONGO_CLIENT is None:
        _MONGO_CLIENT = MongoClient(
            host=_MONGODB_HOST,
            port=_MONGODB_PORT,
            username=_MONGODB_USERNAME,
            password=_MONGODB_PASSWORD,
            authSource=_MONGODB_AUTH_SOURCE
        )
        _MONGODB_COLLECTION = _MONGO_CLIENT[_MONGODB_AUTH_SOURCE][_MONGODB_COLLECTION_NAME]

    if _MONGO_CLIENT is None:
        return False
    else:
        return True


def json_get_ranking():
    global _MONGODB_COLLECTION

    mongodb_connect()

    records = _MONGODB_COLLECTION.find()
    # records = collection.find({"club": "Paris-SG"})

    my_json_array = []

    for rec in records:
        club = str(rec['club'])
        mj = int(rec['mj'])
        g = int(rec['g'])
        n = int(rec['n'])
        p = int(rec['p'])
        bp = int(rec['bp'])
        bc = int(rec['bc'])
        db = bp - bc
        pts = g * 3 + n
        my_json = {"club": club, "mj": mj, "g": g, "n": n, "p": p, "bp": bp, "bc": bc, "db": db, "pts": pts}
        # print(my_json)
        my_json_array.append(my_json)

    my_json_array = sorted(my_json_array, key=lambda k: (k['pts'], k['bp']), reverse=True)

    return Response(json.dumps(my_json_array), mimetype='application/json')


@app.route('/', methods=['GET'])
@app.route('/html_display', methods=['GET'])
def html_display():
    return html_display_ranking()


@app.route('/json_display', methods=['GET'])
def json_display():
    records = json_get_ranking()
    return records


@app.route('/json_delete', methods=['DELETE'])
def json_delete():
    # curl -X DELETE -d 'club=Lyloux' http://localhost:5000/json_delete
    global _MONGODB_COLLECTION

    club = request.form.get('club')

    mongodb_connect()
    cursor = _MONGODB_COLLECTION.find({"club": club})

    if len(list(cursor)) == 1:
        _MONGODB_COLLECTION.delete_one({"club": club})
        my_json = {'ok': 1, 'description': club + ' has been deleted !'}
    else:
        my_json = {'ok': 0, 'description': club + ' does not exist !'}

    return Response(json.dumps(my_json), mimetype='application/json')


"""
    curl -X POST \
        -d 'club=Paris-SG' \
        -d 'mj=16' \
        -d 'g=13' \
        -d 'n=2' \
        -d 'p=1' \
        -d 'bp=35' \
        -d 'bc=15' \
        http://localhost:5000/json_upsert
"""

@app.route('/json_upsert', methods=['POST', 'PUT'])
def json_upsert():
    global _MONGODB_COLLECTION

    club = request.form.get('club')
    mj = request.form.get('mj')
    g = request.form.get('g')
    n = request.form.get('n')
    p = request.form.get('p')
    bp = request.form.get('bp')
    bc = request.form.get('bc')

    mongodb_connect()

    cursor = _MONGODB_COLLECTION.find({"club": club})
    if len(list(cursor)) == 1:
        _MONGODB_COLLECTION.delete_one({"club": club})
        res = {'ok': 1, 'description': club + ' has been upserted !'}
    else:
        res = {'ok': 1, 'description': club + ' has been inserted !'}

    my_json = {
        "club": club,
        "mj": float(mj),
        "g": float(g),
        "n": float(n),
        "p": float(p),
        "bp": float(bp),
        "bc": float(bc)
    }
    _MONGODB_COLLECTION.insert_one(my_json)

    return Response(json.dumps(res), mimetype='application/json')


"""
    curl -X POST \
        -d 'club=Paris-SG' \
        -d 'mj=16' \
        -d 'g=13' \
        -d 'n=2' \
        -d 'p=1' \
        -d 'bp=35' \
        -d 'bc=15' \
        http://localhost:5000/html_form
"""


@app.route('/html_form', methods=['GET', 'POST', 'PUT'])
def html_form():
    global _MONGODB_COLLECTION

    if request.method == 'POST' or request.method == 'PUT':

        club = request.form.get('club')
        mj = request.form.get('mj')
        g = request.form.get('g')
        n = request.form.get('n')
        p = request.form.get('p')
        bp = request.form.get('bp')
        bc = request.form.get('bc')

        mongodb_connect()
        _MONGODB_COLLECTION.delete_one({"club": club})
        my_json = {
            "club": club,
            "mj": float(mj),
            "g": float(g),
            "n": float(n),
            "p": float(p),
            "bp": float(bp),
            "bc": float(bc)
        }
        _MONGODB_COLLECTION.insert_one(my_json)

        html = '''
        <br><br>
        <table style="border:1px solid black;">
            <tr></tr><td align="left" width="650px" nowrap>Record upserted !</td>
        </table>
        '''

        return html + html_display()

    # if request.method == 'GET':

    my_form = '''
        <br><br>
        <form method="POST">
        <table style="border:1px solid black;">
            <tr><td width="100px" nowrap><b>Club: </b></td><td><input type="text" name="club"></td></tr>
            <tr><td width="100px" nowrap><b>MJ:   </b></td><td><input type="text" name="mj"></td></tr>
            <tr><td width="100px" nowrap><b>G:    </b></td><td><input type="text" name="g"></td></tr>
            <tr><td width="100px" nowrap><b>N:    </b></td><td><input type="text" name="n"></td></tr>
            <tr><td width="100px" nowrap><b>P:    </b></td><td><input type="text" name="p"></td></tr>
            <tr><td width="100px" nowrap><b>BP:   </b></td><td><input type="text" name="bp"></td></tr>
            <tr><td width="100px" nowrap><b>BC:   </b></td><td><input type="text" name="bc"></td></tr>
            <tr><td colspan="2" align="right"><input type="submit" value="Submit"></td></tr>
        </table>
        </form>
    '''

    my_form = my_form + html_display()

    return my_form


def html_display_ranking():
    records = json_get_ranking().get_json()

    html = """
    <br><br>
    <table style="border:1px solid black;">
        <tr></tr><td colspan="9" bgcolor="#d1d1d1" align="middle"><font size="5" face="Courier New"><b>French Soccer Championship</b></font></td>
        <tbody>
        <tr>
            <td width="200px" align="left"   nowrap style="border:1px solid black;"><b>Club</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>MJ</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>G</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>N</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>P</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>BP</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>BC</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>DB</b></td>
            <td width="50px"  align="middle" nowrap style="border:1px solid black;"><b>Pts</b></td>
        </tr>
    """

    for rec in records:
        html = html + '<tr>'
        html = html + '<td align="left">' + str(rec['club'])      + '</td>'
        html = html + '<td align="middle">' + str(int(rec['mj']))   + '</td>'
        html = html + '<td align="middle">' + str(int(rec['g']))    + '</td>'
        html = html + '<td align="middle">' + str(int(rec['n']))    + '</td>'
        html = html + '<td align="middle">' + str(int(rec['p']))    + '</td>'
        html = html + '<td align="middle">' + str(int(rec['bp']))   + '</td>'
        html = html + '<td align="middle">' + str(int(rec['bc']))   + '</td>'
        html = html + '<td align="middle">' + str(int(rec['db']))   + '</td>'
        html = html + '<td align="middle">' + str(int(rec['pts']))  + '</td>'
        html = html + '</tr>'

    html = html + '</tbody></table>'

    return html


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
