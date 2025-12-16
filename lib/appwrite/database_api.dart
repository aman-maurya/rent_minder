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
}