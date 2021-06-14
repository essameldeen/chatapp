import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedImage extends StatefulWidget {
  final Function selectedImage;

  PickedImage(this.selectedImage);

  @override
  _PickedImageState createState() => _PickedImageState();
}

class _PickedImageState extends State<PickedImage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.selectedImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _image != null
              ? FileImage(
                  _image,
                )
              : null,
          radius: 40,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: getImage,
            icon: Icon(Icons.image),
            label: Text('Add Image')),
      ],
    );
  }
}
