import 'dart:io';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pilgrimage_map_flutter_app/extended_text_field.dart';
import 'package:pilgrimage_map_flutter_app/file_helper.dart';

import 'image_span_builder.dart';


class FormSubmitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormSubmitPageState();
  }

}
class FormSubmitPageState extends State {
  List<PickedFile> _images = <PickedFile>[];
  final ImagePicker _picker = ImagePicker();
  final FocusNode _focusNode = FocusNode();
  final FileHelper _fileHelper = FileHelper.fileHelper;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ブログ作成'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: TextFormField(
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'タイトル'),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: TextFormField(
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'テーマ'),
              ),
            ),
            Divider(),
            // ExtendedTextField(
            //   keyboardType: TextInputType.multiline,
            //   autofocus: true,
            //   maxLines: 100,
            //   controller: _controller,
            //   focusNode: _focusNode,
            //   specialTextSpanBuilder: ImageSpanBuilder( // <- タグの有無をチェックして、変換する
            //     showAtBackground: true,
            //   ),
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final PickedFile pickedFile =
    await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // キーボードを表示する処理
      SystemChannels.textInput.invokeMethod('TextInput.show');
      return;
    }

    setState(() {
      insertText(
          '<img src=\'${pickedFile.path}\' width=\'300\' height=\'300\'/>\n');
      _images.add(pickedFile);
    });
  }

  void insertText(String text) {
    final TextEditingValue value = _controller.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      _controller.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
    }
  }

  String _replaceRelativePathWithAbsolutePath(String text) {
    String newText = text;
    List<String> relativeImageNames = _fileHelper.findImageNames(text);

    for (int i = 0; i < relativeImageNames.length; i++) {
      final String absoluteImageName =
      _fileHelper.relativePathToAbsolutePath(relativeImageNames[i]);
      newText = newText.replaceAll(relativeImageNames[i], absoluteImageName);
    }
    return newText;
  }

  String _replateAbsolutePathWithRelativePath(String text) {
    String newText = text;
    List<String> absoluteImageNames = _fileHelper.findImageNames(text);

    for (int i = 0; i < absoluteImageNames.length; i++) {
      final String relativePath =
      _fileHelper.absolutePathToRelativePath(absoluteImageNames[i]);
      newText = newText.replaceAll(absoluteImageNames[i], relativePath);
    }
    return newText;
  }

  Future<void> _saveNote() async {
    String _currentText = _controller.text;

    // 現在 指定している画像パスは一時的な領域にあるものなのでアプリ領域に画像を保存する
    for (int i = 0; i < _images.length; i++) {
      if (_currentText.contains(_images[i].path)) {
        await _fileHelper.saveImage(File(_images[i].path));
      }
    }

    _currentText = _replateAbsolutePathWithRelativePath(_currentText);

    Navigator.pop(context);
  }
}
