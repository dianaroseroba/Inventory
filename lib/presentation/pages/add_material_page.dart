import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class AddMaterialPage extends StatefulWidget {
  const AddMaterialPage({super.key});

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  String tipoSeleccionado = 'Eje';
  int cantidad = 1;

  // Campos eje
  String calidad = '';
  double diametro = 0;
  double largoEje = 0;

  // Campos lámina
  String tipoMaterial = '';
  double largoLamina = 0;
  double ancho = 0;
  double calibre = 0;

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Material')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: const [
                  DropdownMenuItem(value: 'Eje', child: Text('Eje')),
                  DropdownMenuItem(value: 'Lámina', child: Text('Lámina')),
                ],
                onChanged: (value) {
                  setState(() {
                    tipoSeleccionado = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de material'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator: (value) {
                  final cantidadVal = int.tryParse(value ?? '');
                  if (cantidadVal == null || cantidadVal < 1) {
                    return 'Cantidad inválida';
                  }
                  return null;
                },
                onChanged: (v) => cantidad = int.tryParse(v) ?? 1,
              ),
              const SizedBox(height: 10),

              if (tipoSeleccionado == 'Eje') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Calidad'),
                  onChanged: (v) => calidad = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Diámetro (Pulgadas)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => diametro = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Largo (cm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => largoEje = double.tryParse(v) ?? 0,
                ),
              ] else ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tipo de Material'),
                  onChanged: (v) => tipoMaterial = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Largo (cm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => largoLamina = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ancho (cm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => ancho = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Calibre (mm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => calibre = double.tryParse(v) ?? 0,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final item = InventoryItemModel(
                      id: '',
                      userId: '',
                      tipo: tipoSeleccionado,
                      fecha: DateTime.now(),
                      cantidad: cantidad,
                      calidad: tipoSeleccionado == 'Eje' ? calidad : null,
                      diametro: tipoSeleccionado == 'Eje' ? diametro : null,
                      largoEje: tipoSeleccionado == 'Eje' ? largoEje : null,
                      tipoMaterial: tipoSeleccionado == 'Lámina' ? tipoMaterial : null,
                      largoLamina: tipoSeleccionado == 'Lámina' ? largoLamina : null,
                      ancho: tipoSeleccionado == 'Lámina' ? ancho : null,
                      calibre: tipoSeleccionado == 'Lámina' ? calibre : null,
                    );

                    await inventoryController.addNewItem(item);
                    Get.back();
                    Get.snackbar('Material Registrado', 'El nuevo material fue agregado correctamente');
                  }
                },
                child: const Text('Registrar Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
