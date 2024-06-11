import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../functions/functions.dart';

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
Future<String> storeFileToFirebase(
    {required String serverFilePath, required File file}) async {
  UploadTask uploadTask = firebaseStorage
      .ref()
      .child('Profile_Images/$serverFilePath')
      .putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

String extractFileName(String path) {
  String fileName;

  // Find the last occurrence of '/' in the path
  int lastIndex = path.lastIndexOf('/');

  // Extract the substring after the last '/'
  if (lastIndex != -1 && lastIndex < path.length - 1) {
    fileName = path.substring(lastIndex + 1);
  } else {
    // If there's no '/' or it's the last character, use the whole path
    fileName = path;
  }

  return fileName;
}

Future<List<String>> storeMultipleFilesToFirebase(
    {required String serverFilePath, required List<String> paths}) async {
  List<String> downloadUrls = [];
  for (int i = 0; i < paths.length; i++) {
    String fileName = extractFileName(paths[i]);
    String filePath = paths[i];
    var downloadUrl = await storeFileToFirebase(
        serverFilePath: 'Shoe_Images/$serverFilePath/$fileName',
        file: File(filePath));
    downloadUrls.add(downloadUrl);
  }

  return downloadUrls;
}

Future<void> deleteFile({required String serverFilePath}) async {
  try {
    await firebaseStorage.ref().child(serverFilePath).delete();
  } catch (e) {
    showCustomSnackBar(message: e.toString());
  }
}
