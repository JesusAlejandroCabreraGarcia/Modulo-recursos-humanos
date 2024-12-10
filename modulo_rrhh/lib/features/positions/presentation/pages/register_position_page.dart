import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPositionPage extends StatefulWidget {
  const RegisterPositionPage({Key? key}) : super(key: key);

  @override
  _RegisterPositionPageState createState() => _RegisterPositionPageState();
}

class _RegisterPositionPageState extends State<RegisterPositionPage> {
  // Lista para almacenar los datos de posiciones
  final List<Map<String, dynamic>> positions = [];

  // Controladores para el formulario
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  // Paleta de colores
  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); // Azul oscuro
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); // Gris oscuro
  final Color buttonColor = Colors.red; // Botón verde
  final Color textColor = Colors.white; // Texto blanco

  void _addPosition() {
    // Fecha actual
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Agregar nuevo registro
    setState(() {
      positions.add({
        'ID': positions.length + 1, // ID asignado según el número de registro
        'Nombre': nameController.text,
        'Descripcion': descriptionController.text,
        'Salario': double.tryParse(salaryController.text) ?? 0.0,
        'Requisitos': requirementsController.text,
        'Estatus': true, // Por defecto activo
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
      });
    });

    // Limpiar campos después de registrar
    nameController.clear();
    descriptionController.clear();
    salaryController.clear();
    requirementsController.clear();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posición registrada')),
    );

    // Cerrar el diálogo
    Navigator.of(context).pop();
  }

  void _showPositionForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Posición'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Salario'),
              ),
              TextField(
                controller: requirementsController,
                decoration: const InputDecoration(labelText: 'Requisitos'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
            ),
            onPressed: _addPosition,
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Posición'),
        backgroundColor: Colors.black,
        foregroundColor: textColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/'); // Navegar a la HomeScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
              ),
              onPressed: _showPositionForm,
              child: const Text('Registrar Posición'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => primaryColor,
                    ),
                    headingTextStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith(
                      (states) => secondaryColor,
                    ),
                    dataTextStyle: TextStyle(
                      color: textColor,
                    ),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Descripción')),
                      DataColumn(label: Text('Salario')),
                      DataColumn(label: Text('Requisitos')),
                      DataColumn(label: Text('Estatus')),
                      DataColumn(label: Text('Fecha Registro')),
                      DataColumn(label: Text('Fecha Actualización')),
                    ],
                    rows: positions.map((position) {
                      return DataRow(
                        cells: [
                          DataCell(Text(position['ID'].toString())),
                          DataCell(Text(position['Nombre'])),
                          DataCell(Text(position['Descripcion'])),
                          DataCell(Text(position['Salario'].toStringAsFixed(2))),
                          DataCell(Text(position['Requisitos'])),
                          DataCell(Text(position['Estatus'] ? 'Activo' : 'Inactivo')),
                          DataCell(Text(position['Fecha_Registro'])),
                          DataCell(Text(position['Fecha_Actualizacion'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
