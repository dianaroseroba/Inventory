import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class IngresoPage extends StatelessWidget {
  const IngresoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Ingreso')),
      body: Obx(() {
        final items = inventoryController.items;
        if (items.isEmpty) {
          return const Center(child: Text('No hay materiales disponibles.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final cantidadController = TextEditingController();

            return Card(
              child: ListTile(
                title: Text(item.tipo == 'eje'
                    ? 'Eje: ${item.calidad}, Ø${item.diametro} x ${item.largoEje}'
                    : 'Lámina: ${item.tipoMaterial}, ${item.largoLamina}x${item.ancho}, Calibre ${item.calibre}'),
                subtitle: Text('Cantidad actual: ${item.cantidad}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Agregar ingreso',
                      content: Column(
                        children: [
                          const Text('Cantidad a ingresar:'),
                          TextField(
                            controller: cantidadController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      textConfirm: 'Registrar',
                      onConfirm: () async {
                        final ingreso = int.tryParse(cantidadController.text) ?? 0;
                        if (ingreso > 0) {
                          final nuevaCantidad = item.cantidad + ingreso;
                          await inventoryController.updateItemQuantity(item.id, nuevaCantidad);
                          Get.back();
                          Get.snackbar('Ingreso registrado', 'Cantidad actualizada');
                        } else {
                          Get.snackbar('Error', 'Cantidad inválida');
                        }
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
