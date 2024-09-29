import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relayz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Colors.white),
            SizedBox(width: 10),
            Text('Relayz'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RelayControlPage()),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, size: 100, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                        "Ravi's Home",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelayControlPage extends StatefulWidget {
  const RelayControlPage({super.key});

  @override
  _RelayControlPageState createState() => _RelayControlPageState();
}

class _RelayControlPageState extends State<RelayControlPage> {
  final String blynkToken = "55Nf12-EwePY4NRqUP5pE10ggzKlbxmZ";
  final String blynkServer = "blynk.cloud";
  List<bool> relayStates = [false, false, false, false];
  bool isDeviceOnline = false;

  @override
  void initState() {
    super.initState();
    checkDeviceStatus();
    getRelayStates();
  }

  Future<void> checkDeviceStatus() async {
    try {
      final response = await http.get(
        Uri.https(blynkServer, '/external/api/isHardwareConnected', {
          'token': blynkToken,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          isDeviceOnline = response.body == 'true';
        });
      }
    } catch (e) {
      print('Error checking device status: $e');
    }
  }

  Future<void> getRelayStates() async {
    try {
      for (int i = 0; i < 4; i++) {
        final response = await http.get(
          Uri.https(blynkServer, '/external/api/get', {
            'token': blynkToken,
            'v$i': '',
          }),
        );
        if (response.statusCode == 200) {
          setState(() {
            relayStates[i] = response.body == '1';
          });
        }
      }
    } catch (e) {
      print('Error getting relay states: $e');
    }
  }

  Future<void> toggleRelay(int index) async {
    final newState = !relayStates[index];
    try {
      final response = await http.get(
        Uri.https(blynkServer, '/external/api/update', {
          'token': blynkToken,
          'v$index': newState ? '1' : '0',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          relayStates[index] = newState;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update relay state')),
        );
      }
    } catch (e) {
      print('Error toggling relay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error: Failed to update relay state')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ravi's Home"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDeviceOnline ? Colors.green : Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDeviceOnline ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  isDeviceOnline ? 'Device Online' : 'Device Offline',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Relay ${index + 1}'),
                    trailing: Switch(
                      value: relayStates[index],
                      onChanged: (value) => toggleRelay(index),
                      activeColor: Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}