from flask import render_template, current_app, flash, redirect, url_for, make_response
from app.forms import LoginForm


@current_app.before_request
def before_request():
    user='wewe'


# No caching at all for API endpoints.
@current_app.after_request
def add_header(response):
    response.cache_control.no_store = True
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    return response


@current_app.route('/')
@current_app.route('/index')
def index():
    user = "Nobody"
    form = LoginForm()
    r = make_response(render_template('index.html', title='Home', user=user, form=form))
    r.headers.set('Content-Security-Policy', "default-src 'self'")
    r = add_header(r)
    return r

@current_app.route('/testroute')
def test_route():
    user = "Test user"
    form = LoginForm()
    r = make_response(render_template('index.html', title='Test', user=user, form=form))
    r.headers.set('Content-Security-Policy', "default-src 'self'")
    r = add_header(r)
    return r


@current_app.route('/test_redir')
def test_redir():
    return redirect(url_for('test_route'))
