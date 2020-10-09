import 'package:flutter/material.dart';

class FormSubmitPage extends StatefulWidget {
  @override
  State createState() => _FormSubmitPageState();
}

class _ProfileData {
  String name = '';
  String thema = '';
}

// 必須チェック
FormFieldValidator _requiredValidator(BuildContext context) =>
    (val) => val.isEmpty ? "必須" : null;

class _FormSubmitPageState extends State {
  final GlobalKey _formKey = GlobalKey();
  _ProfileData _data = _ProfileData();

  FocusNode _nameFocusNode;
  FocusNode _themaFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _themaFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _themaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ブログ作成'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: this._formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'タイトル', border: OutlineInputBorder()),
                  validator: _requiredValidator(context),
                  maxLength: 12,
                  maxLengthEnforced: true,
                  focusNode: _nameFocusNode,
                  onSaved: (String value) => this._data.name = value,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_themaFocusNode),
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'テーマ', border: OutlineInputBorder()),
                  validator: _requiredValidator(context),
                  maxLength: 12,
                  maxLengthEnforced: true,
                  focusNode: _themaFocusNode,
                  onSaved: (String value) => this._data.thema = value,

                  // // 複数行対応
                  // keyboardType: TextInputType.multiline,
                  // maxLines: null,
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                    child: Text(
                      "作成",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.amber,
                    onPressed: () {})
              ],
            ),
          )),
    );
  }
}
