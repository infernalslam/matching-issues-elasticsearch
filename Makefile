build:
	docker build -t my-es .
run:
	docker-compose up --build
	# docker run -p 9200:9200 -p 9300:9300 -p 5601:5601 my-es

