import 'package:flutter/material.dart';

class VaccineAboutScreen extends StatefulWidget {
  const VaccineAboutScreen({super.key});

  @override
  _VaccineAboutScreen createState() => _VaccineAboutScreen();
}

class _VaccineAboutScreen extends State<VaccineAboutScreen> {
  final List<String> _creators = [
    "Guilherme Batista Pereira dos Santos",
    "Natalia Barbara Soares",
    "Olívia Rodrigues Baptista",
    "Paulo Eduardo da Rosa Riccardi",
    "Rachel Emily de Souza Damasceno",
    "Roberto Barreto de Gouveia Filho",
    "Wilson da Gloria Nunes",
  ];
  final String _university = "SENAC";
  final String _degree = "Análise e Desenvolvimento de Sistemas";
  final String _course = "Projeto Integrador Desenvolvimento de Sistemas Orientado a Dispositivos Móveis e Baseados na Web";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o Aplicativo',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text('Desenvolvedores:'),
            const SizedBox(height: 8.0),
            ..._creators.map((creator) => Text(creator)).toList(),
            const SizedBox(height: 90.0),
            Text('Cadeira: $_course'),
            const SizedBox(height: 16.0),
            Text('Curso: $_degree'),
            const SizedBox(height: 16.0),
            Text('Faculdade: $_university'),
            const SizedBox(height: 100.0),
            Center(
              child: Text(
                'Este aplicativo foi desenvolvido com propósito unicamente acadêmico.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
