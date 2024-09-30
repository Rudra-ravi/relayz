# Relayz: Smart Home Automation

![ic_launcher](https://github.com/user-attachments/assets/ba88557a-6145-4b63-ac8f-65608673c583)



Relayz is a DIY smart home automation system that allows you to control up to four electrical devices remotely using your smartphone. Built with an ESP32 microcontroller, Blynk IoT platform, and a custom Flutter mobile app, Relayz brings the power of IoT to your fingertips.

## Features

- Control four relays individually
- Retain relay states after power outage
- User-friendly mobile app interface
- Real-time device status monitoring
- Secure communication with Blynk server

## Hardware Setup



![b4ddb315-f604-41c9-8cfb-fc689f53070e](https://github.com/user-attachments/assets/b30659bb-8798-4b98-aa89-0d7e00f79de0)



Components used:
- ESP32 DevKit board
- 4-channel Relay Module
- 5V Power Supply
- Jumper Wires

Connections:
- Relay 1 -> ESP32 D2
- Relay 2 -> ESP32 D4
- Relay 3 -> ESP32 D5
- Relay 4 -> ESP32 D18

## Software Requirements

- Arduino IDE
- Blynk IoT account
- Flutter SDK

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/relayz.git
   ```

2. Set up the Arduino IDE:
   - Install ESP32 board support
   - Install required libraries: Blynk, ArduinoJson

3. Configure the Blynk project:
   - Create a new project in Blynk.Console
   - Note down the Auth Token

4. Update the ESP32 code:
   - Open `esp32_code/relayz_controller.ino`
   - Replace placeholder values with your WiFi credentials and Blynk Auth Token

5. Flash the ESP32:
   - Connect your ESP32 to your computer
   - Upload the code using Arduino IDE

6. Set up the Flutter app:
   - Navigate to the `relayz` directory
   - Run `flutter pub get` to install dependencies
   - Update the Blynk Auth Token in `lib/config.dart`

7. Build and run the Flutter app:
   - For Android: `flutter build apk`
   - For iOS: `flutter build ios`

## Usage





https://github.com/user-attachments/assets/677756ee-5c5d-40cf-bca1-0a986147fc50





1. Power on your ESP32 setup
2. Launch the Relayz app on your smartphone
3. The app will automatically connect to your device
4. Use the toggle switches to control your connected devices

## Troubleshooting

- Ensure your ESP32 and smartphone are connected to internet
- Check the serial monitor in Arduino IDE for any connection issues
- Verify that your Blynk Auth Token is correct in both the ESP32 code and Flutter app

## Future Enhancements

- [ ] Login Authentication
- [ ] Add scheduling functionality
- [ ] Expand to support more relays/devices

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- Blynk team for their excellent IoT platform
- ESP32 community for their extensive libraries and support
- Flutter team for making cross-platform app development a breeze
