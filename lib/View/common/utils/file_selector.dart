import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

Future<List<String?>> pickFiles() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.image);
  if (result != null) {
    return result.paths.toList();
  } else {
    return [];
  }
}

String getFileName(String filePath) {
  return path.basename(filePath);
}
