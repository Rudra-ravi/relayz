#define BLYNK_TEMPLATE_ID "TMPL3bhkwrfbhk"
#define BLYNK_TEMPLATE_NAME "TEMPLATE_NAME"
#define BLYNK_AUTH_TOKEN "BLYNL_TOKEN"

#include <WiFi.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include <EEPROM.h>

#define BLYNK_PRINT Serial

char ssid[] = "friday";
char pass[] = "password";

const int relayPins[4] = {2, 4, 5, 18};

#define V1_PIN V0
#define V2_PIN V1
#define V3_PIN V2
#define V4_PIN V3

BlynkTimer timer;
bool relayState[4] = {false, false, false, false};  // Initialize all relays to OFF

#define EEPROM_SIZE 4

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < 4; i++) {
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], LOW);  // Ensure all relays are OFF at startup
    relayState[i] = false;  // Set all relay states to OFF
  }

  EEPROM.begin(EEPROM_SIZE);

  // Initialize Blynk
  Blynk.begin(BLYNK_AUTH_TOKEN, ssid, pass);
  Serial.println("Connecting to Internet...");

  // Update Blynk app with initial OFF states
  for (int i = 0; i < 4; i++) {
    Blynk.virtualWrite(V0 + i, LOW);
  }

  timer.setInterval(60000L, saveRelayStates);
}

BLYNK_CONNECTED() {
  // When connected, sync the app with current relay states
  for (int i = 0; i < 4; i++) {
    Blynk.virtualWrite(V0 + i, relayState[i]);
  }
}

BLYNK_WRITE(V1_PIN) {
  updateRelay(0, param.asInt());
}

BLYNK_WRITE(V2_PIN) {
  updateRelay(1, param.asInt());
}

BLYNK_WRITE(V3_PIN) {
  updateRelay(2, param.asInt());
}

BLYNK_WRITE(V4_PIN) {
  updateRelay(3, param.asInt());
}

void updateRelay(int index, int state) {
  relayState[index] = state;
  digitalWrite(relayPins[index], state);
  Serial.print("Relay ");
  Serial.print(index + 1);
  Serial.println(state ? " ON" : " OFF");
  saveRelayStates();
}

void saveRelayStates() {
  for (int i = 0; i < 4; i++) {
    EEPROM.write(i, relayState[i]);
  }
  EEPROM.commit();
  Serial.println("Relay states saved to EEPROM");
}

void loop() {
  Blynk.run();
  timer.run();

  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi Disconnected. Reconnecting...");
    WiFi.begin(ssid, pass);
  }

  if (!Blynk.connected()) {
    Serial.println("Internet disconnected. Reconnecting...");
    Blynk.connect();
  }
}
