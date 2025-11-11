import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> pickAndSaveAvatar() async {
  final picker = ImagePicker();

  // 1️⃣ Выбираем фото из галереи
  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );

  if (pickedFile == null) return null;

  File imageFile = File(pickedFile.path);

  // 2️⃣ Получаем путь к локальному хранилищу
  final appDir = await getApplicationDocumentsDirectory();
  final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
  final savedImage = await imageFile.copy('${appDir.path}/$fileName');

  // 3️⃣ Возвращаем путь к сохранённой картинке
  return savedImage.path;
}
