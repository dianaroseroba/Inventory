import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:users_auth/core/constants/appwrite_constants.dart';
import 'package:users_auth/model/inventory_item_model.dart';

class InventoryRepository {
  final Databases databases;

  InventoryRepository(this.databases);

  Future<void> addItem(InventoryItemModel item) async {
    await databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.inventoryCollectionId,
      documentId: ID.unique(),
      data: item.toJson(),
    );
  }

  Future<List<InventoryItemModel>> getItemsByUser(String userId) async {
    final result = await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.inventoryCollectionId,
      queries: [Query.equal('userId', userId)],
    );

    return result.documents.map((doc) => InventoryItemModel.fromJson(doc.data)).toList();
  }

  Future<void> updateItem(String documentId, Map<String, dynamic> updatedData) async {
    await databases.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.inventoryCollectionId,
      documentId: documentId,
      data: updatedData,
    );
  }

  Future<void> deleteItem(String documentId) async {
    await databases.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.inventoryCollectionId,
      documentId: documentId,
    );
  }

  Future<List<InventoryItemModel>> findSimilarItems(String userId, InventoryItemModel item) async {
    final List<String> queries = [
      Query.equal('userId', userId),
      Query.equal('tipo', item.tipo),
    ];

    if (item.tipo == 'Eje') {
      queries.add(Query.equal('calidad', item.calidad));
      queries.add(Query.equal('diametro', item.diametro));
    } else if (item.tipo == 'Lámina') {
      queries.add(Query.equal('tipoMaterial', item.tipoMaterial));
      queries.add(Query.equal('calibre', item.calibre));
    }

    final response = await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.inventoryCollectionId,
      queries: queries,
    );

    return response.documents.map((doc) => InventoryItemModel.fromJson(doc.data)).toList();
  }
}
