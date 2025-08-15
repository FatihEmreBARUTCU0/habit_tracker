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

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  final List<String> habits = const [
    'Su içmek 💧',
    'Kitap okumak 📚',
    'Spor yapmak 🏃‍♂️',
  ];

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
          return ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(habits[index]),
          );
        },
      ),
    );
  }
}
