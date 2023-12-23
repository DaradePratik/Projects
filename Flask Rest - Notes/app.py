from flask import Flask , request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] ='sqlite:///db.sqlite'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
app.app_context().push()
ma = Marshmallow(app)

class Notes(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100),nullable=False)
    content = db.Column(db.Text, nullable=False)
    date = db.Column(db.String(20), nullable=False)

    def __init__(self, title, content, date):
        self.title = title
        self.content = content
        self.date = date

class NotesSchema(ma.Schema):
    class Meta:
        fields = ('id','title', 'content', 'date')

note_schema = NotesSchema()
notes_schema = NotesSchema(many = True)

@app.route('/notes', methods=['POST'])
def post_notes():
    title = request.json['title']
    content = request.json['content']
    date = request.json['date']
    new_note = Notes(title, content, date)
    db.session.add(new_note)
    db.session.commit()
    return note_schema.jsonify(new_note)

@app.route('/notes',methods=['POST'])
def add_note():
    title = request.json['title']
    content = request.json['content']
    date = request.json['date']

    new_note = Notes(title,content,date)
    db.session.add(new_note)
    db.session.commit

    return notes_schema.jsonify(new_note)



@app.route('/notes',methods=['GET'])
def get_notes():
    all_notes = Notes.query.all()
    result = notes_schema.dump(all_notes)

    return notes_schema.jsonify(result)

@app.route('/notes/<id>',methods=['GET'])
def get_note(id):
    note = Notes.query.get(id)
    return note_schema.jsonify(note)


@app.route('/notes/<id>',methods=['PUT'])
def update_note(id):
    note = Notes.query.get(id)
    note.title = request.json['title']
    note.content = request.json['content']
    note.date = request.json['date']
     
    db.session.commit()
    return note_schema.jsonify(note)

@app.route('/notes/<id>',methods = ['DELETE'])
def delete_note(id):
    note = Notes.query.get(id)
    db.session.delete(note)
    db.session.commit()

    return note_schema.jsonify(note)


    



@app.route('/')
def home():
    return "Welcome"

if __name__ == '__main__':
    app.run(debug=True)