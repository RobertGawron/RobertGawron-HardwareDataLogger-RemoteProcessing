
docker buildx bake --platform linux/arm64


docker-compose run hwlogger-arm-builder \
  docker hwlogger-arm-builder \
  --platform linux/arm/v7,linux/arm64 \
  --tag your_image_name:latest \
  --push .









docker buildx bake --set *.platform=linux/arm64






# Setup

All commands will be executed from the host machine unless stated otherwise.

## Setting Up Docker Images Using Docker Compose

1. **Build the Docker Images:**
   Before starting the containers, ensure the Docker images are built:

   ```bash
   docker-compose build
   ```

2. **Build and Start the Docker Containers:**

   ```bash
   docker-compose up -d
   ```

   Example output:

   ```
   [+] Running 5/5
   ✔ Container hardwaredatalogger-remoteprocessing-influxdb-1        Running
   ✔ Container hardwaredatalogger-remoteprocessing-hw-mock-1         Running
   ✔ Container hardwaredatalogger-remoteprocessing-mqtt-broker-1     Running
   ✔ Container hardwaredatalogger-remoteprocessing-grafana-1         Running
   ✔ Container hardwaredatalogger-remoteprocessing-telegraf-1        Started
   ```

3. **Note Container Names:**
   After starting the containers, note their names (e.g., `hardwaredatalogger-remoteprocessing-influxdb-1`). These names will be used later to log into specific containers for configuration and troubleshooting.

---

## Setting Up InfluxDB

Note that all commands are executed on the host machine.

1. **Initialize InfluxDB:**
   Set up InfluxDB for the first time:

   ```bash
   docker exec -it hardwaredatalogger-remoteprocessing-influxdb-1 influx setup
   ```

   Follow the prompts to configure:

   - **Username:** Example: hwlogger
   - **Password:** Example: securepassword
   - **Organization Name:** Example: hworg
   - **Bucket Name:** Example: hwbucket
   - **Retention Period:** Enter `0` for infinite or a specific duration in hours.

   Example Output:

   ```
   User            Organization    Bucket
   hwlogger        hworg           hwbucket
   ```

2. **Create a Token for Grafana:**

   ```bash
   docker exec -it hardwaredatalogger-remoteprocessing-influxdb-1 influx auth create \
     --read-buckets \
     --write-buckets \
     --description "Grafana Token" \
     --org hworg
   ```

   Save the generated token securely.

3. **Verify Data in InfluxDB:**
   Run the following query to verify data:

   ```bash
   docker exec -it hardwaredatalogger-remoteprocessing-influxdb-1 influx query '
   from(bucket: "hwbucket")
     |> range(start: 1970-01-01T00:00:00Z)
     |> filter(fn: (r) => r._measurement == "test_measurement")'
   ```

4. **Write Test Data to InfluxDB:**
   Manually write test data to InfluxDB:

   ```bash
   docker exec -it hardwaredatalogger-remoteprocessing-influxdb-1 influx write \
     --bucket hwbucket \
     --org hworg \
     --precision s \
     "test_measurement field=123 $(date +%s)"
   ```

---

## Setting Up MQTT

No additional configuration is required for MQTT as the default setup is used.

###

---

## Setting Up Telegraf

1. **Configure Telegraf:**

   On the host machine, modify `DevOps/PiDev/Telegraf/telegraf.conf` to include the same bucket, organization, and token as specified during the InfluxDB setup:


2. **Restart Telegraf:**
   Restart the Telegraf container to apply changes:

   ```bash
   docker restart hardwaredatalogger-remoteprocessing-telegraf-1
   ```

3. **Check Telegraf Logs:**

   ```bash
   docker logs hardwaredatalogger-remoteprocessing-telegraf-1
   ```

---

## Setting Up Grafana

1. **Add InfluxDB as a Data Source:**
   Open Grafana in your browser: `http://localhost:3000`.

   - Log in (default credentials: admin/admin).
   - Navigate to **Configuration > Data Sources > Add data source**.
   - Select **InfluxDB**.

2. **Configure the Data Source:**

   - **Query Language:** Flux
   - **URL:** `http://influxdb:8086`
   - **Token:** Paste the InfluxDB token.
   - **Organization:** the same as specified during the creation of the token in InfluxDB
   - **Default Bucket:** same as during creation of token in influxdb
   - **Save and Test:**
     Click **Save & Test** to verify the connection.

3. **Visualize Data:**

   - Go to the **Explore** tab.
   - Use the following Flux query to fetch data:
     ```flux
     from(bucket: "hwbucket")
       |> range(start: -1h)
       |> filter(fn: (r) => r._measurement == "test_measurement")
     ```
   - Create a dashboard to visualize the data.
