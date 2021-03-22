import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode, //not required anymore
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  // textInputAction: TextInputAction.next,//remove for multiline input
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8, right: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: _imageUrlController.text.isEmpty
                          ? Text(
                              "Enter a URL",
                              softWrap: true,
                            )
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Image.network(_imageUrlController.text)),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          if (_imageUrlController.text.isNotEmpty)
                            setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    super.dispose();
  }

  void _updateImagePreview() {
    //update image preview container with the image from url on focus change
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }
}
