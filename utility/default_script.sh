docker-compose down

git restore .
git pull

docker-compose up --build -d

docker-compose logs
docker-compose ps
