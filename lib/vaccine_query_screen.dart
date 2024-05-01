import 'package:flutter/material.dart';
import 'package:saude_em_foco_v2/database_helper.dart';
import 'package:saude_em_foco_v2/vaccine.dart';

class VaccineQueryScreen extends StatefulWidget {
  const VaccineQueryScreen({super.key});

  @override
  _VaccineQueryScreenState createState() => _VaccineQueryScreenState();
}

class _VaccineQueryScreenState extends State<VaccineQueryScreen> {
  final _ageController = TextEditingController();
  List<Vaccine>? _filteredVaccines;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consulta por Idade',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  color: const Color(0xFF1ae0ed),
                  width: 16.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Idade (anos)',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            final age = int.tryParse(_ageController.text) ?? 0;
                            _queryVaccines(age);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: _filteredVaccines == null
                  ? const Text('Insira a idade e clique em "Buscar Vacinas"')
                  : ListView.builder(
                      itemCount: _filteredVaccines!.length,
                      itemBuilder: (context, index) {
                        final vaccine = _filteredVaccines![index];
                        return ListTile(
                          title: Text(vaccine.name),
                          subtitle: Text('${vaccine.ageMin} anos'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
//Lógica da busca por idade mínima e idade máxima
void _queryVaccines(int age) async {
  final allVaccines = await DatabaseHelper.instance.getAllVaccines();
  setState(() {
    _filteredVaccines = allVaccines
        .where((vaccine) => vaccine.ageMin <= age && vaccine.ageMax >= age)
        .toList()..sort((a, b) => a.ageMin.compareTo(b.ageMax));
  });
}
}
