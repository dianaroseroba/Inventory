import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:users_auth/controllers/auth_controller.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => inventoryController.fetchItems(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (inventoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = inventoryController.items;
        if (items.isEmpty) {
          return const Center(child: Text('No hay materiales registrados.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            final isEje = item.tipo == 'Eje';
            final descripcion = isEje
                ? 'Eje: ${item.calidad ?? '-'}, Ø${item.diametro?.toStringAsFixed(1) ?? '-'}" x ${item.largoEje?.toStringAsFixed(1) ?? '-'} cm'
                : 'Lámina: ${item.tipoMaterial ?? '-'}, ${item.largoLamina?.toStringAsFixed(1) ?? '-'}x${item.ancho?.toStringAsFixed(1) ?? '-'} cm, Calibre ${item.calibre?.toStringAsFixed(1) ?? '-'} mm';

            return Card(
              child: ListTile(
                title: Text(descripcion),
                subtitle: Text(
                  'Cantidad: ${item.cantidad} · Fecha: ${DateFormat('yyyy-MM-dd').format(item.fecha)}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: 'Ver historial',
                      onPressed: () {
                        Get.snackbar('Historial', 'Aquí se mostrará el historial del material');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar',
                      onPressed: () {
                        Get.toNamed('/EditMaterialPage', arguments: item);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed: () {
                        Get.defaultDialog(
                          title: '¿Eliminar?',
                          middleText: '¿Deseas eliminar este material?',
                          textConfirm: 'Sí',
                          textCancel: 'Cancelar',
                          confirmTextColor: Colors.white,
                          onConfirm: () async {
                            await inventoryController.deleteItem(item.id);
                            Get.back();
                            Get.snackbar('Eliminado', 'Material eliminado correctamente');
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'nuevo',
            onPressed: () {
              Get.toNamed('/AddMaterialPage');
            },
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Material'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'ingreso',
            onPressed: () {
              Get.toNamed('/IngresoPage');
            },
            icon: const Icon(Icons.add_box),
            label: const Text('Registrar Ingreso'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'salida',
            onPressed: () {
              Get.toNamed('/SalidaPage');
            },
            icon: const Icon(Icons.outbox),
            label: const Text('Registrar Salida'),
          ),
        ],
      ),
    );
  }
}
