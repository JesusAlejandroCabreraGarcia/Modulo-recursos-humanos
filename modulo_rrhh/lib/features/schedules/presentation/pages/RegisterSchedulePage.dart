import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterSchedulePage extends StatefulWidget {
  const RegisterSchedulePage({Key? key}) : super(key: key);

  @override
  _RegisterSchedulePageState createState() => _RegisterSchedulePageState();
}

class _RegisterSchedulePageState extends State<RegisterSchedulePage> {
  // Lista para almacenar los datos de horarios
  final List<Map<String, dynamic>> schedules = [];

  // Colores personalizados
  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); 
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); 
  final Color buttonColor = Colors.red; 
  final Color textColor = Colors.white;

  void _addSchedule() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      schedules.add({
        'ID': schedules.length + 1,
        'Usuario': 'Usuario Ejemplo',
        'Tipo': 'Tipo Ejemplo',
        'Fecha_Inicio': formattedDate,
        'Fecha_Fin': formattedDate,
        'Fecha_Registro': formattedDate,
        'Estatus': true,
        'Empleado': 'Empleado Ejemplo',
        'Sucursal': 'Sucursal Ejemplo',
        'Servicio': 'Servicio Ejemplo',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario registrado')),
    );
  }

  void _showScheduleForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Horario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Usuario')),
            TextField(decoration: const InputDecoration(labelText: 'Tipo')),
            TextField(decoration: const InputDecoration(labelText: 'Fecha Inicio')),
            TextField(decoration: const InputDecoration(labelText: 'Fecha Fin')),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _addSchedule,
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
        title: const Text('Registrar Horario'),
        backgroundColor: Colors.black,
        foregroundColor: textColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showScheduleForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
              ),
              child: const Text('Registrar Horario'),
            ),
            const SizedBox(height: 20),

            // Scroll horizontal
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Tipo')),
                      DataColumn(label: Text('Fecha Inicio')),
                      DataColumn(label: Text('Fecha Fin')),
                      DataColumn(label: Text('Fecha Registro')),
                      DataColumn(label: Text('Estatus')),
                      DataColumn(label: Text('Empleado')),
                      DataColumn(label: Text('Sucursal')),
                      DataColumn(label: Text('Servicio')),
                    ],
                    rows: schedules.map((schedule) {
                      return DataRow(
                        cells: [
                          DataCell(Text(schedule['ID'].toString())),
                          DataCell(Text(schedule['Usuario'])),
                          DataCell(Text(schedule['Tipo'])),
                          DataCell(Text(schedule['Fecha_Inicio'])),
                          DataCell(Text(schedule['Fecha_Fin'])),
                          DataCell(Text(schedule['Fecha_Registro'])),
                          DataCell(Text(schedule['Estatus'] ? 'Activo' : 'Inactivo')),
                          DataCell(Text(schedule['Empleado'])),
                          DataCell(Text(schedule['Sucursal'])),
                          DataCell(Text(schedule['Servicio'])),
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
