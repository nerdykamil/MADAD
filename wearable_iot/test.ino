#include "ThingSpeak.h"
#include <ESP8266WiFi.h>

#include <LiquidCrystal_I2C.h>


LiquidCrystal_I2C lcd(0x3F, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE); // Set the LCD I2C address


//Replace your wifi credentials here
const char* ssid     = "Code_Camp_103";
const char* password = "103@2019";

unsigned long channel = 894198;


//IONERFZ1GCL847FW


unsigned int led1 = 1;
//unsigned int led2 = 1;
//unsigned int led3 = 1;


WiFiClient  client;


void setup() {

  lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.home();
  lcd.print("   madad"); // Start Print text to Line 1
  lcd.setCursor(0, 1);
  lcd.print("     alert"); 
  Serial.begin(115200);
  delay(100);
  
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  digitalWrite(D1, 0);
  digitalWrite(D2, 0);
  digitalWrite(D3, 0);
  // We start by connecting to a WiFi network
 
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.print("Netmask: ");
  Serial.println(WiFi.subnetMask());
  Serial.print("Gateway: ");
  Serial.println(WiFi.gatewayIP());
  ThingSpeak.begin(client);

}

void loop() {

  //get the last data of the fields
  int led_1 = ThingSpeak.readFloatField(channel, led1);
 // int led_2 = ThingSpeak.readFloatField(channel, led2);
 // int led_3 = ThingSpeak.readFloatField(channel, led3);
  
  
  if(led_1 == 1){
    //digitalWrite(D1, 1);
    Serial.println("1 value is On..!");

    lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.home();
  lcd.print("   DANGER"); // Start Print text to Line 1
  lcd.setCursor(0, 1);
  lcd.print("     RUN RUN"); 

  
  }
  else if(led_1 == 0){
    //digitalWrite(D1, 0);
    Serial.println("2 is on..!");


        lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.home();
  lcd.print("      CHECK"); // Start Print text to Line 1
  lcd.setCursor(0, 1);
  lcd.print("   ANNOUNCEMENT"); 

    
  }

 
  else {
    //digitalWrite(D3, 0);
    Serial.println("Good day");
  }
    
  Serial.println(led_1);
//  Serial.println(led_2);
//  Serial.println(led_3);
  delay(5000);

}
