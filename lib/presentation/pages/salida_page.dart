import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class SalidaPage extends StatelessWidget {
  const SalidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Salida')),
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
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Registrar salida',
                      content: Column(
                        children: [
                          const Text('Cantidad a retirar:'),
                          TextField(
                            controller: cantidadController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      textConfirm: 'Confirmar',
                      onConfirm: () async {
                        final salida = int.tryParse(cantidadController.text) ?? 0;
                        if (salida > 0 && salida <= item.cantidad) {
                          final nuevaCantidad = item.cantidad - salida;
                          await inventoryController.updateItemQuantity(item.id, nuevaCantidad);
                          Get.back();
                          Get.snackbar('Salida registrada', 'Cantidad actualizada');
                        } else {
                          Get.snackbar('Error', 'Cantidad inválida o insuficiente');
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
