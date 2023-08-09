import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as systempath;

class ImageInput extends StatefulWidget {
  final Function imagePickFn;
  ImageInput(this.imagePickFn);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    //NOTE-->App directory is a directory that is only accessible by the app itself.
    //Every App hase a directory where it can store files which is provided by the OS(both IOS and Android)
    //We can get the path to that directory using the path_provider package
    final appDirectory = await systempath.getApplicationDocumentsDirectory();
    //We can get the file name from the image path using the path package
    final fileName = path.basename(imageFile.path);
    //We can "copy" the image to the app directory using the copy method and SAVE IT inside the app directory
    final savedImage =
        await _storedImage!.copy('${appDirectory.path}/$fileName');
    widget.imagePickFn(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
          ),
        )
      ],
    );
  }
}
