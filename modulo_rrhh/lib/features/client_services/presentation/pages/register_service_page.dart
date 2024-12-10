import 'dart:convert'; // Para convertir la lista a JSON
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterServicePage extends StatefulWidget {
  const RegisterServicePage({Key? key}) : super(key: key);

  @override
  _RegisterServicePageState createState() => _RegisterServicePageState();
}

class _RegisterServicePageState extends State<RegisterServicePage> {
  // Lista para almacenar los datos de servicios
  final List<Map<String, dynamic>> services = [];

  // Controladores para el formulario
  final TextEditingController personaIdController = TextEditingController();
  final TextEditingController tipoServicioController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController comentariosController = TextEditingController();

  // Paleta de colores
  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); // Azul oscuro
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); // Gris oscuro
  final Color buttonColor = Colors.red; // Botón rojo
  final Color textColor = Colors.white; // Texto blanco

  @override
  void initState() {
    super.initState();
    _loadServices(); // Cargar los servicios al iniciar
  }

  // Función para cargar los servicios desde SharedPreferences
  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? servicesData = prefs.getString('services'); // Obtener los datos

    if (servicesData != null) {
      final List<dynamic> decodedData = jsonDecode(servicesData); // Decodificar JSON
      setState(() {
        services.clear();
        services.addAll(decodedData.map((item) => Map<String, dynamic>.from(item)));
      });
    }
  }

  // Función para guardar los servicios en SharedPreferences
  Future<void> _saveServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(services); // Convertir la lista a JSON
    await prefs.setString('services', encodedData); // Guardar los datos
  }

  void _addService() {
    // Fecha actual
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Agregar nuevo registro
    setState(() {
      services.add({
        'ID': services.length + 1, // ID asignado según el número de registro
        'Persona_ID': personaIdController.text,
        'Tipo_Servicio': tipoServicioController.text,
        'Descripcion': descripcionController.text,
        'Comentarios': comentariosController.text,
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
        'Estatus': true, // Por defecto activo
      });
    });

    // Guardar los servicios en SharedPreferences
    _saveServices();

    // Limpiar campos después de registrar
    personaIdController.clear();
    tipoServicioController.clear();
    descripcionController.clear();
    comentariosController.clear();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Servicio registrado')),
    );

    // Cerrar el diálogo
    Navigator.of(context).pop();
  }

  void _showServiceForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Servicio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: personaIdController,
                decoration: const InputDecoration(labelText: 'ID Persona'),
              ),
              TextField(
                controller: tipoServicioController,
                decoration: const InputDecoration(labelText: 'Tipo de Servicio'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: comentariosController,
                decoration: const InputDecoration(labelText: 'Comentarios'),
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
            onPressed: _addService,
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
        title: const Text('Registrar Servicio'),
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
              onPressed: _showServiceForm,
              child: const Text('Registrar Servicio'),
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
                      DataColumn(label: Text('Persona ID')),
                      DataColumn(label: Text('Tipo de Servicio')),
                      DataColumn(label: Text('Descripción')),
                      DataColumn(label: Text('Comentarios')),
                      DataColumn(label: Text('Fecha Registro')),
                      DataColumn(label: Text('Fecha Actualización')),
                      DataColumn(label: Text('Estatus')),
                    ],
                    rows: services.map((service) {
                      return DataRow(
                        cells: [
                          DataCell(Text(service['ID'].toString())),
                          DataCell(Text(service['Persona_ID']!)),
                          DataCell(Text(service['Tipo_Servicio']!)),
                          DataCell(Text(service['Descripcion']!)),
                          DataCell(Text(service['Comentarios']!)),
                          DataCell(Text(service['Fecha_Registro']!)),
                          DataCell(Text(service['Fecha_Actualizacion']!)),
                          DataCell(Text(service['Estatus']! ? 'Activo' : 'Inactivo')),
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
