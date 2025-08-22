import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class MessageHistory {
  /// Exporte l'historique dans un fichier choisi par l'utilisateur (ou dans Documents si indisponible)
  static Future<void> exportHistory() async {
    final file = await _getLocalFile();
    if (!(await file.exists())) return;
    final contents = await file.readAsString(encoding: utf8);

    Directory? exportDir;
    if (Platform.isAndroid) {
      // Dossier public Download sur Android
      exportDir = Directory('/storage/emulated/0/Download');
    } else {
      // Dossier Documents sur iOS
      exportDir = await getApplicationDocumentsDirectory();
    }
    final exportFile = File(
        '${exportDir.path}/chatbot_history_${DateTime.now().millisecondsSinceEpoch}.json');
    await exportFile.writeAsString(contents, encoding: utf8);
    print('Historique exporté : ${exportFile.path}');
  }

  /// Importe un historique depuis un fichier JSON choisi par l'utilisateur
  static Future<void> importHistory() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final importFile = File(result.files.single.path!);
      final contents = await importFile.readAsString(encoding: utf8);
      final List<dynamic> jsonResult = jsonDecode(contents);
      if (jsonResult is List) {
        final file = await _getLocalFile();
        await file.writeAsString(jsonEncode(jsonResult), encoding: utf8);
      }
    }
  }

  /// Supprime l'historique de la conversation (fichier messages.json)
  static Future<void> clearHistory() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/messages.json');
  }

  static Future<List<Map<String, String>>> loadMessages() async {
    try {
      final file = await _getLocalFile();
      if (!(await file.exists())) return [];
      final contents = await file.readAsString(encoding: utf8);
      if (contents.trim().isEmpty) return [];
      final List<dynamic> jsonResult = jsonDecode(contents);
      return List<Map<String, String>>.from(
        jsonResult.map((e) => Map<String, String>.from(e.map((key, value) =>
            MapEntry(key.toString(), value?.toString() ?? "")))),
      );
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveMessages(List<Map<String, String>> messages) async {
    final file = await _getLocalFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(messages), encoding: utf8);
  }

  static Future<void> addMessage(Map<String, String> message) async {
    final messages = await loadMessages();
    messages.add(message);
    await saveMessages(messages);
  }
}
