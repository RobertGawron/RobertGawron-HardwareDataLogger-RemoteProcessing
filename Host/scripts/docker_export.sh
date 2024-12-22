# Extract image names from docker-compose.yml
images=$(docker compose config | grep 'image:' | awk '{print $2}')

# Save each image for ARM
for image in $images; do
  image_name=$(echo $image | tr '/' '_' | tr ':' '_')
  echo "Saving $image as ${image_name}.tar"
  docker save $image -o "./ansible/files/${image_name}.tar"
done
