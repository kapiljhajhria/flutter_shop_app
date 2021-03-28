import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
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
  var _isInit =
      true; //to prevent re run of didChangeDependcies. we need to run it just once before first build
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null) {
        String productId = args as String;
        // if(productId!=null)
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
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _intiValues["title"],
                  decoration: InputDecoration(labelText: "Title"),
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
                  // onChanged: _updateFormData("title"),
                  validator: _formValidator("title"),
                ),
                TextFormField(
                  initialValue: _intiValues["price"],
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode, //not required anymore
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
                  // onChanged: _updateFormData("price"),
                  validator: _formValidator("price"),
                ),
                TextFormField(
                  initialValue: _intiValues["description"],
                  decoration: InputDecoration(labelText: "Description"),
                  // textInputAction: TextInputAction.next,//remove for multiline input
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
                  // onChanged: _updateFormData("description"),
                  validator: _formValidator("description"),
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
                              // fit: BoxFit.contain,
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _intiValues["imageUrl"],
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          if (_imageUrlController.text.isNotEmpty)
                            setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
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
                        // onChanged: _updateFormData("imageUrl"),
                        validator: _formValidator("imageUrl"),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text("Save"),
                )
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

  void _saveForm() {
    //validate form
    bool isValidForm = _formKey.currentState!.validate();
    if (!isValidForm) return;

    _formKey.currentState!.save();

    //check if the product is being added or edited
    Products products = Provider.of<Products>(context, listen: false);
    if (_editedProduct.id == "newProduct") {
      //save new product to products list

      _formKey.currentState?.save();
      products.addProduct(
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
          price: _editedProduct.price.toString(),
          title: _editedProduct.title);
    } else {
      //edit the current product
      //find the current product index and
      //replace that with the edited product
      products.updateProduct(_editedProduct.id, _editedProduct);
    }

    //leave screen after saving
    Navigator.of(context).pop();
  }

  // void Function(String?) _updateFormData(String keyToUpdate) {
  //   return (String? value) {
  //     _formData[keyToUpdate] = value!;
  //   };
  // }

  String? Function(String?) _formValidator(String validateThis) {
    return (String? value) {
      // if (value == null) return "Required Field";
      if (value!.isEmpty) return "Required Field";
      //else use switch case or if else and show other types
      ///
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
      //of error based on the input, for now we are just checking
      //if its empty or not
      return null;
    };
  }
}
