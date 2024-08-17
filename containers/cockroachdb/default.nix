{}
/*
  cockroachdb/cockroach:latest

docker run -d \
  --env COCKROACH_DATABASE={DATABASE_NAME} \
  --env COCKROACH_USER={USER_NAME} \
  --env COCKROACH_PASSWORD={PASSWORD} \
  --name=roach-single \
  --hostname=roach-single \
  -p 26257:26257 \
  -p 8080:8080 \
  -v "roach-single:/cockroach/cockroach-data"  \
  cockroachdb/cockroach:v24.2.0 start-single-node \
  --http-addr=roach-single:8080
*/

