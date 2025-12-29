import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rent_minder/appwrite/auth_api.dart';
import 'package:rent_minder/constants/constants.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(appwriteUrl)
        .setProject(appwriteProjectId)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> amenitiesDataList({int limit = 25, int offset = 0}) {
      final documentList = databases.listDocuments(
        collectionId: amenitiesCollection,
        databaseId: appwriteDatabaseId,
        queries: [
          Query.limit(limit),  // Limit the number of documents to fetch
          Query.offset(offset),  // Skip the first 'offset' number of records
        ],
      );

      return documentList;  // Return the list of documents
  }

  Future<Document> addAmenity({required String name, required double price}) {
    return databases.createDocument(
        databaseId: appwriteDatabaseId,
        collectionId: amenitiesCollection,
        documentId: ID.unique(),
        data: {
          'name': name,
          'img': 'default.png',
          'price': price,
        });
  }

  // Method to delete an amenity by its document ID
  Future<bool> deleteAmenity({required String documentId}) async {
    try {
      await databases.deleteDocument(
        databaseId: appwriteDatabaseId,
        collectionId: amenitiesCollection,
        documentId: documentId,
      );

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Document?> getAmenityById({required String documentId}) async {
    try {
      final document = await databases.getDocument(
        databaseId: appwriteDatabaseId,
        collectionId: amenitiesCollection,
        documentId: documentId,
      );

      return document;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Buildings: similar to amenities but using buildingCollection
  Future<DocumentList> buildingsDataList({int limit = 25, int offset = 0}) {
    final documentList = databases.listDocuments(
      collectionId: buildingCollection,
      databaseId: appwriteDatabaseId,
      queries: [
        Query.limit(limit),
        Query.offset(offset),
      ],
    );

    return documentList;
  }

  Future<Document> addBuilding({required String name, required String address, String? alias}) {
    final data = {
      'name': name,
      'address': address,
    };
    if (alias != null) data['alias'] = alias;

    return databases.createDocument(
      databaseId: appwriteDatabaseId,
      collectionId: buildingCollection,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<bool> deleteBuilding({required String documentId}) async {
    try {
      await databases.deleteDocument(
        databaseId: appwriteDatabaseId,
        collectionId: buildingCollection,
        documentId: documentId,
      );

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Document?> getBuildingById({required String documentId}) async {
    try {
      final document = await databases.getDocument(
        databaseId: appwriteDatabaseId,
        collectionId: buildingCollection,
        documentId: documentId,
      );

      return document;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Check if a building with the given name already exists.
  /// If [excludeId] is provided, that document id will be ignored (useful for updates).
  Future<bool> buildingExistsByName({required String name, String? excludeId}) async {
    try {
      final queries = <dynamic>[Query.equal('name', name), Query.limit(1)];
      if (excludeId != null && excludeId.isNotEmpty) {
        queries.insert(0, Query.notEqual(r'$id', excludeId));
      }

      final list = await databases.listDocuments(
        databaseId: appwriteDatabaseId,
        collectionId: buildingCollection,
        queries: queries.cast(),
      );

      return (list.total > 0) || (list.documents.isNotEmpty);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Update an existing building document by id.
  Future<Document> updateBuilding({required String documentId, required Map<String, dynamic> data}) {
    return databases.updateDocument(
      databaseId: appwriteDatabaseId,
      collectionId: buildingCollection,
      documentId: documentId,
      data: data,
    );
  }
}