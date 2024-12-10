import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({Key? key}) : super(key: key);

  @override
  _RegisterEmployeePageState createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  // Lista para almacenar los datos de empleados
  final List<Map<String, dynamic>> employees = [];

  // Controladores para el formulario
  final TextEditingController areaController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController personaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  // Paleta de colores
  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); // Azul oscuro
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); // Gris oscuro
  final Color buttonColor = Colors.red; // Botón rojo
  final Color textColor = Colors.white; // Texto blanco

  void _addEmployee() {
    // Fecha actual
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Agregar nuevo registro
    setState(() {
      employees.add({
        'ID': employees.length + 1, // ID asignado según el número de registro
        'Area_ID': areaController.text,
        'Fecha_Contratacion': formattedDate,
        'Puesto_ID': puestoController.text,
        'Persona_ID': personaController.text,
        'Numero_Empleado': numeroController.text,
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
        'Estatus': true, // Por defecto activo
      });
    });

    // Limpiar campos después de registrar
    areaController.clear();
    puestoController.clear();
    personaController.clear();
    numeroController.clear();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Empleado registrado')),
    );

    // Cerrar el diálogo
    Navigator.of(context).pop();
  }

  void _showEmployeeForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área del Empleado (Area_ID)'),
              ),
              TextField(
                controller: puestoController,
                decoration: const InputDecoration(labelText: 'Puesto (Puesto_ID)'),
              ),
              TextField(
                controller: personaController,
                decoration: const InputDecoration(labelText: 'Persona (Persona_ID)'),
              ),
              TextField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Número de Empleado'),
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
            onPressed: _addEmployee,
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
        title: const Text('Registrar Empleado'),
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
              onPressed: _showEmployeeForm,
              child: const Text('Registrar Empleado'),
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
                      DataColumn(label: Text('Área ID')),
                      DataColumn(label: Text('Fecha Contratación')),
                      DataColumn(label: Text('Puesto')),
                      DataColumn(label: Text('Persona ID')),
                      DataColumn(label: Text('Núm. Empleado')),
                      DataColumn(label: Text('Fecha Registro')),
                      DataColumn(label: Text('Fecha Actualización')),
                      DataColumn(label: Text('Estatus')),
                    ],
                    rows: employees.map((employee) {
                      return DataRow(
                        cells: [
                          DataCell(Text(employee['ID'].toString())),
                          DataCell(Text(employee['Area_ID']!)),
                          DataCell(Text(employee['Fecha_Contratacion']!)),
                          DataCell(Text(employee['Puesto_ID']!)),
                          DataCell(Text(employee['Persona_ID']!)),
                          DataCell(Text(employee['Numero_Empleado']!)),
                          DataCell(Text(employee['Fecha_Registro']!)),
                          DataCell(Text(employee['Fecha_Actualizacion']!)),
                          DataCell(Text(employee['Estatus']! ? 'Activo' : 'Inactivo')),
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

