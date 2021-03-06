import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Product _editedProduct = Product(
      id: "newProduct", title: "", description: "", price: 0, imageUrl: "");
  Map<String, String> _intiValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };
  var _isInit = true;

  bool _showLoadingIndicator = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null) {
        final String productId = args as String;

        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _intiValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": _editedProduct.imageUrl
        };
        _imageUrlController =
            TextEditingController(text: _intiValues["imageUrl"]);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveForm(context);
            },
          )
        ],
      ),
      body: LoadingOverlay(
        isLoading: _showLoadingIndicator,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _intiValues["title"],
                      decoration: const InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: _formValidator("title"),
                    ),
                    TextFormField(
                      initialValue: _intiValues["price"],
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: _formValidator("price"),
                    ),
                    TextFormField(
                      initialValue: _intiValues["description"],
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 5,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: _formValidator("description"),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  "Enter a URL",
                                  softWrap: true,
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              if (_imageUrlController.text.isNotEmpty) {
                                setState(() {});
                              }
                            },
                            onFieldSubmitted: (_) {
                              _saveForm(context);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: _formValidator("imageUrl"),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveForm(context);
                      },
                      child: const Text("Save"),
                    )
                  ],
                ),
              ),
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
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm(BuildContext context) async {
    final bool isValidForm = _formKey.currentState!.validate();
    if (!isValidForm) return;

    _formKey.currentState!.save();
    setState(() {
      _showLoadingIndicator = true;
    });

    final Products products = Provider.of<Products>(context, listen: false);
    try {
      if (_editedProduct.id == "newProduct") {
        _formKey.currentState?.save();
        await products.addProduct(
            description: _editedProduct.description,
            imageUrl: _editedProduct.imageUrl,
            price: _editedProduct.price.toString(),
            title: _editedProduct.title);
      } else {
        await products.updateProduct(_editedProduct.id, _editedProduct);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error Saving, Try Again after some time")));
      setState(() {
        _showLoadingIndicator = false;
      });
      return;
    }
    setState(() {
      _showLoadingIndicator = false;
    });

    Navigator.of(context).pop();
  }

  String? Function(String?) _formValidator(String validateThis) {
    return (String? value) {
      if (value!.isEmpty) return "Required Field";

      switch (validateThis) {
        case "title":
          {
            if (value.isEmpty) return "Title is required";
            if (value.length < 3) return "Title is too short";
            break;
          }
        case "description":
          {
            if (value.isEmpty) return "Description is required";
            if (value.length < 20) return "Description is too short";
            break;
          }
        case "price":
          {
            if (value.isEmpty) return "Price is required";
            if (value == "0") return "Price can't be zero";
            break;
          }
        case "imageUrl":
          {
            if (value.isEmpty) return "Image URL is required";
            if (value.length < 5) return "Invalid URL";
            if (!value.contains("jpg") &&
                !value.contains("jpeg") &&
                !value.contains("png")) return "Invalid URL";
            break;
          }

        default:
          return null;
      }

      return null;
    };
  }
}
