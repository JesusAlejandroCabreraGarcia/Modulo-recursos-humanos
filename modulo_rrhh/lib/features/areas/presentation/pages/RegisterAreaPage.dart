import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterAreaPage extends StatefulWidget {
  const RegisterAreaPage({Key? key}) : super(key: key);

  @override
  _RegisterAreaPageState createState() => _RegisterAreaPageState();
}

class _RegisterAreaPageState extends State<RegisterAreaPage> {
  // Lista para almacenar los datos de áreas
  final List<Map<String, dynamic>> areas = [];

  // Controladores para el formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController sucursalController = TextEditingController();

  // Paleta de colores
  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); // Azul oscuro
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); // Gris oscuro
  final Color buttonColor = Colors.red; // Botón rojo
  final Color textColor = Colors.white; // Texto blanco

  void _addArea() {
    // Fecha actual
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Agregar nuevo registro
    setState(() {
      areas.add({
        'ID': areas.length + 1, // ID asignado según el número de registro
        'Nombre': nombreController.text,
        'Descripcion': descripcionController.text,
        'Sucursal': sucursalController.text,
        'Estatus': true, // Por defecto activo
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
      });
    });

    // Limpiar campos después de registrar
    nombreController.clear();
    descripcionController.clear();
    sucursalController.clear();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Área registrada')),
    );

    // Cerrar el diálogo
    Navigator.of(context).pop();
  }

  void _showAreaForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Área'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: sucursalController,
                decoration: const InputDecoration(labelText: 'Sucursal'),
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
            onPressed: _addArea,
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
        title: const Text('Registrar Área'),
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
              onPressed: _showAreaForm,
              child: const Text('Registrar Área'),
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
                      DataColumn(label: Text('Sucursal')),
                      DataColumn(label: Text('Estatus')),
                      DataColumn(label: Text('Fecha Registro')),
                      DataColumn(label: Text('Fecha Actualización')),
                    ],
                    rows: areas.map((area) {
                      return DataRow(
                        cells: [
                          DataCell(Text(area['ID'].toString())),
                          DataCell(Text(area['Nombre']!)),
                          DataCell(Text(area['Descripcion']!)),
                          DataCell(Text(area['Sucursal']!)),
                          DataCell(Text(area['Estatus']! ? 'Activo' : 'Inactivo')),
                          DataCell(Text(area['Fecha_Registro']!)),
                          DataCell(Text(area['Fecha_Actualizacion']!)),
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
