import 'package:flutter/material.dart';
import 'package:saude_em_foco_v2/vaccine.dart';
import 'package:saude_em_foco_v2/database_helper.dart';

class VaccineListScreen extends StatefulWidget {
  const VaccineListScreen({super.key});

  @override
  _VaccineListScreenState createState() => _VaccineListScreenState();
}

class _VaccineListScreenState extends State<VaccineListScreen> {
  Future<List<Vaccine>>? _futureVaccines;

  @override
  void initState() {
    super.initState();
    _futureVaccines = DatabaseHelper.instance.getAllVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vacinas Registradas',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),  
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Vaccine>>(
          future: _futureVaccines,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final vaccines = snapshot.data!;
              if (vaccines.isEmpty) {
                return const Text('Nenhuma vacina cadastrada.');
              }
              return ListView.builder(
                itemCount: vaccines.length,
                itemBuilder: (context, index) {
                  final vaccine = vaccines[index];
                  return ListTile(
                    title: Text(vaccine.name),
                    subtitle: Text('${vaccine.ageMin} - ${vaccine.ageMax} anos'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            //Editar registros
                            final updatedVaccine = await _showEditVaccineDialog(context, vaccine);
                            if (updatedVaccine != null) {
                              await DatabaseHelper.instance.updateVaccine(updatedVaccine);
                              setState(() {
                                _futureVaccines = DatabaseHelper.instance.getAllVaccines();
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            //Excluir registros
                            final confirmation = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: Colors.white,
                                title: Text('Confirmar Exclusão', style: TextStyle(color: Colors.black)),
                                content: Text('Deseja realmente excluir a vacina de ${vaccine.name}?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar', style: TextStyle(color: Colors.black)),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                  TextButton(
                                    child: Text('Excluir', style: TextStyle(color: Colors.black)),
                                    onPressed: () => Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );
                            if (confirmation ?? false) {
                              await DatabaseHelper.instance.deleteVaccine(vaccine.id!);
                              setState(() {
                                _futureVaccines = DatabaseHelper.instance.getAllVaccines();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar vacinas.');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }


  //Editar vacinas já cadastradas
  Future<Vaccine?> _showEditVaccineDialog(BuildContext context, Vaccine vaccine) async {
    final nameController = TextEditingController(text: vaccine.name);
    final ageMinController = TextEditingController(text: vaccine.ageMin.toString());
    final ageMaxController = TextEditingController(text: vaccine.ageMax.toString());
    return await showDialog<Vaccine>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        backgroundColor: Colors.white,        
        title: Text('Editar Vacina', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),                
              ),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: ageMinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Idade Mínima (anos)',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),    
              ),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: ageMaxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Idade Máxima (anos)',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),                    
              ),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context, null),
          ),
          TextButton(
            child: Text('Salvar', style: TextStyle(color: Colors.black)),
            onPressed: () {
              final updatedName = nameController.text;
              final updatedAgeMin = int.tryParse(ageMinController.text) ?? 0;
              final updatedAgeMax = int.tryParse(ageMaxController.text) ?? 0;
              if (updatedName.isNotEmpty && updatedAgeMin > 0 && updatedAgeMax > 0) {
                final updatedVaccine = Vaccine(
                  id: vaccine.id,
                  name: updatedName,
                  ageMin: updatedAgeMin,
                  ageMax: updatedAgeMax,
                );
                Navigator.pop(context, updatedVaccine);
              }
            },
          ),
        ],
      ),
    );
  }
}