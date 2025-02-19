// Digital Pet App - Flutter
// Created by: Hasin Rahman & Hugo Yang

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
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 80;
  TextEditingController _nameController = TextEditingController();
  String _selectedActivity = 'Play';
  late Timer _hungerTimer, _winTimer;
  int _secondsSurvived = 0;
  int _winTime = 180; // 3-minute win condition

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinTimer();
  }

  // Automatically increase hunger every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          _checkPetStatus();
        });
      }
    });
  }

  // Check if the player survives for 3 minutes while keeping the pet happy
  void _startWinTimer() {
    _winTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel > 80) {
        setState(() {
          _secondsSurvived++;
        });

        if (_secondsSurvived >= _winTime) {
          _showWinDialog();
        }
      } else {
        _secondsSurvived = 0;
      }
    });
  }

  // Activities affecting pet's state
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      _increaseHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      energyLevel = (energyLevel + 15).clamp(0, 100);
      _updateHappiness();
    });
  }

  void _letPetSleep() {
    setState(() {
      energyLevel = 100;
      happinessLevel = (happinessLevel - 5).clamp(
        0,
        100,
      ); // Slight boredom after sleeping
    });
  }

  void _walkPet() {
    setState(() {
      happinessLevel = (happinessLevel + 15).clamp(0, 100);
      hungerLevel = (hungerLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
    });
  }

  // Perform the selected activity
  void _performSelectedActivity() {
    if (_selectedActivity == 'Play') {
      _playWithPet();
    } else if (_selectedActivity == 'Feed') {
      _feedPet();
    } else if (_selectedActivity == 'Sleep') {
      _letPetSleep();
    } else if (_selectedActivity == 'Walk') {
      _walkPet();
    }
  }

  // Update happiness based on hunger
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _increaseHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel >= 100) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Get the pet's mood color
  Color _getMoodColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String _getMoodStatus() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  // Check if pet reaches critical levels
  void _checkPetStatus() {
    if (hungerLevel >= 100 || happinessLevel <= 10) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Oh no!"),
          content: Text("$petName has run away due to neglect! 😢"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win! 🎉"),
          content: Text(
            "You've successfully kept $petName happy and healthy for 3 minutes! 🏆",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 80;
      _secondsSurvived = 0;
    });
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

            // Pet Image & Mood Indicator
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getMoodColor(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/pet.png', // Ensure this file exists in assets/
                    height: 150,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Text("Pet image not found!"),
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

            // Energy Bar
            LinearProgressIndicator(
              value: energyLevel / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                energyLevel > 70
                    ? Colors.green
                    : (energyLevel > 30 ? Colors.yellow : Colors.red),
              ),
              minHeight: 15,
            ),

            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedActivity,
              items:
                  ['Play', 'Feed', 'Sleep', 'Walk']
                      .map(
                        (activity) => DropdownMenuItem(
                          value: activity,
                          child: Text(activity),
                        ),
                      )
                      .toList(),
              onChanged:
                  (String? newValue) =>
                      setState(() => _selectedActivity = newValue!),
            ),
            ElevatedButton(
              onPressed: _performSelectedActivity,
              child: Text("Perform Activity"),
            ),
          ],
        ),
      ),
    );
  }
}
