import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import 'package:users_auth/data/repositories/inventory_repository.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class InventoryController extends GetxController {
  final InventoryRepository repository;

  RxList<InventoryItemModel> items = <InventoryItemModel>[].obs;
  RxBool isLoading = false.obs;

  InventoryController({required this.repository});

  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      final account = Get.find<Account>();
      final user = await account.get();

      final result = await repository.getItemsByUser(user.$id);
      items.assignAll(result);
    } catch (e) {
      print('❌ Error al cargar inventario: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNewItem(InventoryItemModel item) async {
    try {
      final account = Get.find<Account>();
      final user = await account.get();

      final updatedItem = InventoryItemModel(
        id: '',
        userId: user.$id,
        tipo: item.tipo,
        fecha: item.fecha,
        cantidad: item.cantidad,
        calidad: item.calidad,
        diametro: item.diametro,
        largoEje: item.largoEje,
        tipoMaterial: item.tipoMaterial,
        largoLamina: item.largoLamina,
        ancho: item.ancho,
        calibre: item.calibre,
      );

      await repository.addItem(updatedItem);
      await fetchItems(); // Refresca la lista
    } catch (e) {
      print('❌ Error al registrar nuevo material: $e');
    }
  }

  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    try {
      await repository.updateItem(itemId, {'cantidad': newQuantity});
      await fetchItems(); // Actualiza el estado
    } catch (e) {
      print('❌ Error al actualizar cantidad: $e');
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await repository.deleteItem(itemId);
      await fetchItems();
    } catch (e) {
      print('❌ Error al eliminar material: $e');
    }
  }
  Future<void> updateItem(String itemId, Map<String, dynamic> updatedData) async {
  try {
    await repository.updateItem(itemId, updatedData);
    await fetchItems(); // Para refrescar la lista
  } catch (e) {
    print('❌ Error al actualizar material: $e');
  }
}
}
