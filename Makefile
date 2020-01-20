.PHONY: start_local
start_local:
	RAILS_ENV=development HOST="0.0.0.0" PORT=3000 DB_HOST="localhost" APP_NAME="pet-tracker" rails s
