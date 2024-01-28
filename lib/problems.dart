// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'map.dart';

class ProblemListScreen extends StatelessWidget {
  const ProblemListScreen({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('raisedProblems').get();
    return snapshot.docs;
  }


  // Function to display document details in an alert dialog
  void _showDocumentDetails(BuildContext context, Map<String, dynamic> documentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Problem Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${documentData['Name']}'),
              Text('Number: ${documentData['Number']}'),
              Text('Problem: ${documentData['Problem']}'),
              Text('Discription: ${documentData['Discription']}'),
              Text('Severity: ${documentData['Severity']}'),
              Text('Location: ${documentData['Location']}'),
              Text('GeoTag: ${documentData['GeoTag']}'),
              Text('Image: ${documentData['Image']}'),
              Text('Time: ${documentData['TimeStamp']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _copyToClipboard(documentData['Image']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text copied to clipboard'),
                  ),
                );
              },
              child: const Text('Copy Image link'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.buslist ?? 'Bus List'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(
                title: 'Bus PV 117',
                icon: Icons.directions_bus_rounded,
                onPressed: () {
                  _showBusInformationDialog(context,'Bus PV 117','Railway Station','Benz Circle');
                },
              ),
              const SizedBox(height: 10),
              CustomCard(
                title: 'Bus CB 7C',
                icon: Icons.directions_bus_rounded,
                onPressed: () {
                  _showBusInformationDialog(context,'Bus CB 7C','K R Market','Autonagar');
                },
              ),
              const SizedBox(height: 10),
              CustomCard(
                title: 'Bus CB 9C',
                icon: Icons.directions_bus_rounded,
                onPressed: () {
                  _showBusInformationDialog(context,'Bus CB 9C','Bus Station','Kanuru');
                },
              ),
              const SizedBox(height: 10),
              CustomCard(
                title: 'Bus PV 85',
                icon: Icons.directions_bus_rounded,
                onPressed: () {
                  _showBusInformationDialog(context,'Bus PV 85','K R market','Guntur');
                },
              ),
          ],

        ),
      )
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon,size:35,color: Colors.green,),
              Text(
                title,
                style: const TextStyle(fontSize: 25),
              ),
              const Divider(
                thickness: 1,  // Adjust thickness as needed
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void _showBusInformationDialog(BuildContext context, String busNo, String source, String destination) {
  // Simulating random data for demonstration purposes
  Random random = Random();
  int crowdPercentage = random.nextInt(101);
  TimeOfDay randomTime = generateRandomTime();


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Bus Number- $busNo'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bus No: $busNo'),
            Text('Source: $source'),
            Text('Destination: $destination'),
            Text('Time: ${randomTime.hour}:${randomTime.minute}'),
            const SizedBox(height: 16),
            Text('crowd percentage: $crowdPercentage%', style: TextStyle(color: _getCrowdColor(crowdPercentage))),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: crowdPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getCrowdColor(crowdPercentage)),
            ),
            const Text('நேரடி இடம்: சந்தை'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('நெருக்கமான'),
          ),
        ],
      );
    },
  );
}

Color _getCrowdColor(int crowdPercentage) {
  if (crowdPercentage < 50) {
    return Colors.green;
  } else if (crowdPercentage < 80) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
TimeOfDay generateRandomTime() {
  // Create a Random object
  Random random = Random();

  // Generate random values for hours and minutes
  int randomHour = random.nextInt(24); // 0 to 23
  int randomMinute = random.nextInt(60); // 0 to 59

  // Create a TimeOfDay object with the generated random values
  TimeOfDay randomTime = TimeOfDay(hour: randomHour, minute: randomMinute);

  return randomTime;
}