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
  late Timer _hungerTimer;
  late Timer _winTimer;
  int _secondsSurvived = 0;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinTimer(); // Start the win timer
  }

  @override
  void dispose() {
    _hungerTimer.cancel();
    _winTimer.cancel(); // Cancel the win timer when the game ends
    super.dispose();
  }

  // Timer to increase hunger automatically
  void _startHungerTimer() {
    Timer.periodic(Duration(seconds: 15), (timer) {
      if (mounted) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          _checkPetStatus();
        });
      }
    });
  }

  void _startWinTimer() {
    _winTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel > 70 && hungerLevel < 30) {
        setState(() {
          _secondsSurvived++;
        });

        if (_secondsSurvived >= 60) {
          _showWinDialog();
        }
      } else {
        _secondsSurvived = 0; // Reset win timer if conditions are not met
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

  // Function to check if the pet is too hungry or unhappy
  void _checkPetStatus() {
    if (hungerLevel >= 100 || happinessLevel <= 0) {
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
          content: Text("You've successfully kept $petName happy and healthy for a whole minute! 🏆"),
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

  // Function to reset game after pet runs away
  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      _secondsSurvived = 0; // Reset win timer counter
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
