import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../constant/image_constant.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication auth = LocalAuthentication();

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true, useErrorDialogs: true));

      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

//flutterant - Biometric Authentication
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric Authentication'),
        ),
        body: Stack(
          children: [
            Image.asset("assest/bk1.png",
                height: MediaQuery.of(context).size.height, fit: BoxFit.cover),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      //height: 80,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Image.asset(ImageConstant.marvelLogo),
                    ),
                  ),
                  //Text('Current State: $_authorized\n'),
                  Expanded(child: Container()),
                  _authorized == "Authorized"
                      ? Container(
                          child: Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateTime.now().hour.toString() +
                                  ":" +
                                  DateTime.now().minute.toString(),
                              style: TextStyle(
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              DateTime.now().day.toString() +
                                  "-" +
                                  DateTime.now().month.toString() +
                                  "-" +
                                  DateTime.now().year.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                  Expanded(child: Container()),

                  _authorized == "Authorized"
                      ? InkWell(
                          child: Image.asset(
                            "assest/unlocked.png",
                            height: 50,
                            color: Colors.black,
                          ),
                          onTap: () {
                            _authorized = "lock";
                            setState(() {});
                          },
                        )
                      : InkWell(
                          child: Image.asset(
                            "assest/lock.png",
                            height: 50,
                            color: Colors.black,
                          ),
                          onTap: _authenticate,
                        ),
                  _authorized == "Authorized"
                      ? Text(
                          "Press To lock",
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          "Press To unlock",
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
