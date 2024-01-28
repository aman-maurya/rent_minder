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
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> amenitiesDataList() {
    return databases.listDocuments(
        collectionId: AMENITIES_COLLECTION,
        databaseId: APPWRITE_DATABASE_ID
    );
  }

  Future<Document> addAmenity({required String name}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: AMENITIES_COLLECTION,
        documentId: ID.unique(),
        data: {
          'name': name,
          'img': 'default.png',
        });
  }
}