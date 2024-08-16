#include <ESP8266WiFi.h>
#include <WiFiManager.h>
#include <FirebaseESP8266.h>
#include <DHT.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>

// Firestore credentials
#define FIREBASE_PROJECT_ID "all-in-agri"
#define FIREBASE_API_KEY "AIzaSyCskTPMKHMATcjJ5OXh4j_kLa-pNrxoaBo"
#define FIREBASE_HOST "https://firestore.googleapis.com/v1/projects/" FIREBASE_PROJECT_ID "/databases/(default)/documents"

// OpenWeatherMap API credentials
const char* apiKey = "5505e4995e00f1755c61da65f6e74231";
const char* cityID = "2294768";

// Define the pins
#define DHTPIN 4  // DHT11 pin
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200);
  dht.begin();
  
  // Initialize WiFiManager
  WiFiManager wifiManager;
  
  // Automatically connect to saved WiFi, or start the configuration portal
  if (!wifiManager.autoConnect("WeatherMonitoringAP")) {
    Serial.println("Failed to connect and hit timeout");
    ESP.restart();
  }

  Serial.println("Connected to WiFi");
}

void loop() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  float pressure = 0.0;
  float windSpeed = 0.0;

  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String("http://api.openweathermap.org/data/2.5/weather?id=") + cityID + "&appid=" + apiKey + "&units=metric";
    http.begin(url);
    int httpCode = http.GET();

    if (httpCode > 0) {
      String payload = http.getString();
      DynamicJsonDocument doc(1024);
      deserializeJson(doc, payload);

      pressure = doc["main"]["pressure"].as<float>();
      windSpeed = doc["wind"]["speed"].as<float>();
      
      Serial.print("Pressure: ");
      Serial.print(pressure);
      Serial.println(" hPa");

      Serial.print("Wind Speed: ");
      Serial.print(windSpeed);
      Serial.println(" m/s");
    } else {
      Serial.println("Error on HTTP request");
    }

    http.end();
  }

  // Prepare Firestore document data as a JSON object
  DynamicJsonDocument json(1024);
  json["fields"]["temperature"]["doubleValue"] = temperature;
  json["fields"]["humidity"]["doubleValue"] = humidity;
  json["fields"]["pressure"]["doubleValue"] = pressure;
  json["fields"]["windSpeed"]["doubleValue"] = windSpeed;

  // Send data to Firestore using HTTP
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String(FIREBASE_HOST) + "/weatherData?key=" + FIREBASE_API_KEY;
    http.begin(url);
    http.addHeader("Content-Type", "application/json");

    String jsonStr;
    serializeJson(json, jsonStr);
    
    int httpCode = http.POST(jsonStr);

    if (httpCode > 0) {
      Serial.println("Data sent successfully to Firestore");
      Serial.println(http.getString());
    } else {
      Serial.print("Error sending data: ");
      Serial.println(http.errorToString(httpCode));
    }

    http.end();
  }

  delay(60000);  // Delay before sending the next data (1 minute)
}
