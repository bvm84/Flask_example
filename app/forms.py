from flask_wtf import FlaskForm
from wtforms import validators, StringField, SelectField, IntegerField, PasswordField, BooleanField, SubmitField

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[validators.DataRequired()])
    password = PasswordField('Password', validators=[validators.DataRequired()])
    remember_me = BooleanField('Remember Me')
    submit = SubmitField('Sign In')