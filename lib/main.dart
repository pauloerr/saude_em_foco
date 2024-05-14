import 'package:flutter/material.dart';
import 'package:saude_em_foco_v2/vaccine_input_screen.dart';
import 'package:saude_em_foco_v2/vaccine_list_screen.dart';
import 'package:saude_em_foco_v2/vaccine_query_screen.dart';
import 'package:saude_em_foco_v2/vaccine_about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde em Foco',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1ae0ed),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
        ),        
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
   final List<Widget> _screens = const [
    VaccineQueryScreen(), 
    VaccineInputScreen(),
    VaccineListScreen(),
    VaccineAboutScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ae0ed),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/caduceus.jpg',
              width: 50.0,
              height: 50.0,
            ),
            const SizedBox(width: 10.0),
            const Text(
              'Saúde em Foco',
              style: TextStyle(fontSize: 26, color: Colors.black), 
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1ae0ed),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Consulta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova Vacina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ver Vacinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
        currentIndex: _currentIndex, 
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
