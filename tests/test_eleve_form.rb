ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

require_relative '../dossiersco_web'

class EleveFormTest < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		get '/init'
	end

	def test_accueil
		get '/'
		assert last_response.body.include? 'Inscription'
	end

	def test_entree_succes_eleve_1
		post '/accueil', identifiant: '1', date_naiss: '1995-11-19'
		assert last_response.body.include? 'Etienne'
		assert last_response.body.include? 'Georges Courteline (Paris 12è)'
	end

	def test_entree_succes_eleve_2
		post '/accueil', identifiant: '2', date_naiss: '1915-12-19'
		assert last_response.body.include? 'Edith'
		assert last_response.body.include? 'Jean Lurçat (Brive-la-Gaillarde)'
	end

	# def test_entree_echec
	# 	post '/accueil', identifiant: '3'
	# 	follow_redirect!
	# 	assert last_response.body.include? 'aucun élève'
	# end

	def test_modification_lieu_naiss_eleve
		post '/accueil', identifiant: '2', date_naiss: '1915-12-19'
		post '/eleve/2', ville_naiss: 'Beziers'
		get '/eleve/2'
		assert last_response.body.include? 'Edith'
		assert last_response.body.include? 'Beziers'
	end

	# def test_mauvaise_connexion
	# 	get '/eleve?'
	# 	follow_redirect!
	# 	assert last_response.body.include? 'Quelques clics'
	# end

	def test_accueil_et_inscription
		post '/accueil', identifiant: '2', date_naiss: '1915-12-19'
		assert last_response.body.include? 'son inscription'
	end

	def test_accueil_et_réinscription
		post '/accueil', identifiant: '1', date_naiss: '1995-11-19'
		assert last_response.body.include? 'réinscription'
	end

	def teardown
		get '/init'
	end
end
