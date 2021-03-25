import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:wastegram_extended/screens/listpage.dart';
import 'package:wastegram_extended/services/auth_provider.dart';

class LoginSignupPage extends StatefulWidget {
  static const String routeName = 'LoginSignupEmail';
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static const int passwordLen = 6;
  bool _isLoginPage = true;
  String _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isLoginPage ? const Text('Login') : const Text('Create Account'),
      ),
      body: SingleChildScrollView (
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15.0, vertical: MediaQuery.of(context).size.width / 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: showInputs() + showButtons(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logInEmailPassword(
      {@required String email, @required String password}) async {
    try {
      await AuthProvider.of(context)
          .auth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  // Need to return this?
  Future<void> signUp(
      {@required String email,
      @required String password,
      @required String role}) async {
    try {
      await AuthProvider.of(context).auth.signUpWithEmail(
            email: email,
            password: password,
            role: role,
          );
    } catch (e) {
      print(e);
    }
    return null;
  }

  List<Widget> showInputs() {
    return <Widget>[
      TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (String val) =>
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)
                  ? null
                  : 'Enter a valid email'),
      TextFormField(
        obscureText: true,
        controller: _passwordController,
        decoration: const InputDecoration(labelText: 'Password'),
        keyboardType: TextInputType.text,
        autocorrect: false,
        validator: (val) => val.isEmpty || val.length < passwordLen
            ? 'Enter a password with more than 6 characters'
            : null,
      ),
    ];
  }

  List<Widget> showButtons() {
    if (_isLoginPage) {
      return <Widget>[
        ElevatedButton(
          onPressed: validateSubmit,
          child: const Text('Login'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: GestureDetector(
            child: const Text('Not Registered? Create Account'),
            onTap: () {
              _formKey.currentState.reset();
              setState(() {
                _isLoginPage = false;
              });
            },
          ),
        ),
      ];
    }
    return <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: DropDownFormField(
          filled: false,
          titleText: 'Role',
          hintText: 'Please choose one',
          value: _selectedRole,
          onSaved: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
          dataSource: [
            {
              "display": "Admin",
              "value": "Admin",
            },
            {
              "display": "User",
              "value": "User",
            },
          ],
          textField: 'display',
          valueField: 'value',
        ),
      ),
      ElevatedButton(
        onPressed: () {
          validateSubmit().then((val) {
            return ListPage();
          });
        },
        child: const Text('Submit'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: GestureDetector(
          child: const Text('Already Registered? Login'),
          onTap: () {
            _formKey.currentState.reset();
            setState(() {
              _isLoginPage = true;
            });
          },
        ),
      ),
    ];
  }

  Future<void> validateSubmit() async {
    // Validate all form fields, then either sign in or sign up with credentials
    if (_formKey.currentState.validate()) {
      try {
        if (_isLoginPage) {
          await AuthProvider.of(context).auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
        } else {
          await signUp(
              email: _emailController.text,
              password: _passwordController.text,
              role: _selectedRole);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully registered ${_emailController.text}',
              ),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
