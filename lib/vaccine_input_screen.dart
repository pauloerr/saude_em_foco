import 'package:flutter/material.dart';
import 'package:saude_em_foco_v2/vaccine.dart';
import 'package:saude_em_foco_v2/database_helper.dart';

class VaccineInputScreen extends StatefulWidget {
  const VaccineInputScreen({super.key});

  @override
  _VaccineInputScreenState createState() => _VaccineInputScreenState();
}

class _VaccineInputScreenState extends State<VaccineInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageMinController = TextEditingController();
  final _ageMaxController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    super.dispose();
  }

  void _saveVaccine() async {
    if (_formKey.currentState!.validate()) {
      final vaccine = Vaccine(
        name: _nameController.text,
        ageMin: int.parse(_ageMinController.text),
        ageMax: int.parse(_ageMaxController.text),
      );

      await DatabaseHelper.instance.insertVaccine(vaccine);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        backgroundColor: const Color(0xFF1ae0ed),
        content: Container(
          child: const Text(
            'Vacina salva com sucesso!',
            style: TextStyle(color: Colors.black),
          ),
          color: const Color(0xFF1ae0ed),
        ),
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Vacina',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),  
          ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Vacina',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome da vacina.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ageMinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade Mínima (anos)',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a idade mínima.';
                  }
                  final parsedAge = int.tryParse(value);
                  if (parsedAge == null || parsedAge <= 0) {
                    return 'Idade mínima inválida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ageMaxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade Máxima (anos)',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),                
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a idade máxima.';
                  }
                  final parsedAge = int.tryParse(value);
                  if (parsedAge == null || parsedAge <= 0) {
                    return 'Idade máxima inválida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveVaccine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ae0ed),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),      
                ),
                child: const Text('Salvar'),          
              ),
            ],
          ),
        ),
      ),
    );
  }
}
