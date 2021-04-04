import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline6!
                              .color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
            begin: const Size(double.infinity, 260),
            end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.bounceInOut));
    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
      Navigator.of(context)
          .pushReplacementNamed(ProductsOverviewScreen.routeName);
    } on HttpException catch (error) {
      String errorMessage = 'Authentication Failed';

      if (error.message == 'EMAIL_NOT_FOUND' ||
          error.message == 'INVALID_PASSWORD') {
        errorMessage = "Please check you Email/Password";
      } else if (error.message == "USER_DISABLED") {
        errorMessage = "Account Disabled, contact support.";
      } else if (error.message == "EMAIL_EXISTS") {
        errorMessage = "EMAIL already in use";
      } else if (error.message.contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        errorMessage = "Login Temporarily blocked. Try again after some time";
      } else if (error.message == "OPERATION_NOT_ALLOWED") {
        errorMessage = "Wrong SignIn Method";
      } else if (error.message.contains("WEAK_PASSWORD")) {
        errorMessage = "Weak Password";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (error) {
      // ignore: prefer_interpolation_to_compose_strings
      // ignore: avoid_print
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("failed to authenticate, try again later.")));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (BuildContext context, Widget? builderChild) {
          return Container(
            height: _heightAnimation.value.height,
            constraints:
                BoxConstraints(minHeight: _heightAnimation.value.height),
            width: deviceSize.width * 0.75,
            padding: const EdgeInsets.all(16.0),
            child: builderChild,
          );
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  MaterialButton(
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                MaterialButton(
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text(
                    '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
