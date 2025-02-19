// Digital Pet App - Flutter
// Created by: [Your Name] & [Partner's Name]

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet"; // Default pet name
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  // Timer to increase hunger automatically
  void _startHungerTimer() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          if (hungerLevel >= 100) {
            happinessLevel = (happinessLevel - 20).clamp(0, 100);
          }
        });
      }
    });
  }

  // Function to play with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to feed the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger when playing
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Get the pet's mood color
  Color _getMoodColor() {
    if (happinessLevel > 70) return Colors.green; // Happy
    if (happinessLevel >= 30) return Colors.yellow; // Neutral
    return Colors.red; // Unhappy
  }

  // Get the pet's mood status
  String _getMoodStatus() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pet Name Input Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter Pet Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName =
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : "Your Pet";
                });
              },
              child: Text("Set Pet Name"),
            ),

            SizedBox(height: 20),

            // Display Pet Name
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // Pet Image with Mood Indicator
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getMoodColor(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/pet.png', // Ensure you have an image at assets/pet.png
                    height: 150,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _getMoodStatus(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Display Happiness and Hunger Levels
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20)),

            SizedBox(height: 30),

            // Interaction Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _playWithPet, child: Text('Play')),
                ElevatedButton(onPressed: _feedPet, child: Text('Feed')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
