import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class EditMaterialPage extends StatefulWidget {
  const EditMaterialPage({super.key});

  @override
  State<EditMaterialPage> createState() => _EditMaterialPageState();
}

class _EditMaterialPageState extends State<EditMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  late InventoryItemModel item;

  late String tipoSeleccionado;
  late int cantidad;

  String calidad = '';
  double diametro = 0;
  double largoEje = 0;

  String tipoMaterial = '';
  double largoLamina = 0;
  double ancho = 0;
  double calibre = 0;

  @override
  void initState() {
    super.initState();
    item = Get.arguments as InventoryItemModel;

    tipoSeleccionado = item.tipo;
    cantidad = item.cantidad;

    calidad = item.calidad ?? '';
    diametro = item.diametro ?? 0;
    largoEje = item.largoEje ?? 0;

    tipoMaterial = item.tipoMaterial ?? '';
    largoLamina = item.largoLamina ?? 0;
    ancho = item.ancho ?? 0;
    calibre = item.calibre ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Material')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Tipo: $tipoSeleccionado', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                initialValue: cantidad.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => cantidad = int.tryParse(v) ?? 1,
              ),
              const SizedBox(height: 10),

              if (tipoSeleccionado == 'Eje') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Calidad'),
                  initialValue: calidad,
                  onChanged: (v) => calidad = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Diámetro (Pulgadas)'),
                  initialValue: diametro.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => diametro = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Largo (cm)'),
                  initialValue: largoEje.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => largoEje = double.tryParse(v) ?? 0,
                ),
              ] else ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tipo de Material'),
                  initialValue: tipoMaterial,
                  onChanged: (v) => tipoMaterial = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Largo (cm)'),
                  initialValue: largoLamina.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => largoLamina = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ancho (cm)'),
                  initialValue: ancho.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => ancho = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Calibre (mm)'),
                  initialValue: calibre.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => calibre = double.tryParse(v) ?? 0,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedData = {
                      'cantidad': cantidad,
                      'calidad': tipoSeleccionado == 'Eje' ? calidad : null,
                      'diametro': tipoSeleccionado == 'Eje' ? diametro : null,
                      'largoEje': tipoSeleccionado == 'Eje' ? largoEje : null,
                      'tipoMaterial': tipoSeleccionado == 'Lámina' ? tipoMaterial : null,
                      'largoLamina': tipoSeleccionado == 'Lámina' ? largoLamina : null,
                      'ancho': tipoSeleccionado == 'Lámina' ? ancho : null,
                      'calibre': tipoSeleccionado == 'Lámina' ? calibre : null,
                    };

                    await inventoryController.updateItem(item.id, updatedData);
                    Get.back();
                    Get.snackbar('Actualizado', 'Material modificado correctamente');
                  }
                },
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
