import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

class AddPostScreen extends StatefulWidget {
  final String username;
  AddPostScreen({required this.username});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _image;
  final _captionController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _uploadPost() async {
    if (_image == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لطفاً عکس و متن را انتخاب کنید.')));
      return;
    }

    setState(() => _isUploading = true);

    // تبدیل عکس به فرمت Base64 برای ارسال راحت به API
    List<int> imageBytes = await _image!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    final success = await ApiService.createPost(
      widget.username,
      _captionController.text,
      base64Image,
    );

    setState(() => _isUploading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('پست با موفقیت منتشر شد.')));
      setState(() {
        _image = null;
        _captionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا در انتشار پست!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('پست جدید'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[200],
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600])
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(labelText: 'کپشن بنویسید...', border: OutlineInputBorder()),
              maxLines: 3,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 24),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadPost,
                    child: Text('انتشار پست'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ),
          ],
        ),
      ),
    );
  }
}
