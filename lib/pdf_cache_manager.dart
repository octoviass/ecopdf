import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class PdfCacheManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> savePdf(Uint8List pdfData, String fileName) async {
    final path = await _localPath;
    final file = File('$path/$fileName.pdf');
    return file.writeAsBytes(pdfData);
  }

  Future<File?> loadPdf(String fileName) async {
    try {
      final path = await _localPath;
      final file = File('$path/$fileName.pdf');
      if (await file.exists()) {
        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCache() async {
    final path = await _localPath;
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}