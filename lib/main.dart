import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alışkanlık Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HabitListScreen(),
    );
  }
}

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final List<String> habits = [
    'Su içmek 💧',
    'Kitap okumak 📚',
    'Spor yapmak 🏃‍♂️',
  ];

  // Her alışkanlık için tamamlanma durumu
  final List<bool> completed = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlıklarım'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(habits[index]),
            value: completed[index],
            onChanged: (bool? value) {
              setState(() {
                completed[index] = value ?? false;
              });
            },
          );
        },
      ),
    );
  }
}
