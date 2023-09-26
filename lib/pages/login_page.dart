import 'package:asispnia/api/authentification_api.dart';
import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/helpers/authentication_response.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/action_button_sized.dart';
import '../widgets/dialogs.dart';
import '../widgets/text_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pssController = TextEditingController();
  bool keepSession = GetIt.instance<bool>();
  late bool allrequeriments;
  @override
  void initState() {
    super.initState();
    allrequeriments = false;
    pssController.addListener(verifyAllRequirements);
    idController.addListener(verifyAllRequirements);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void verifyAllRequirements() {
    setState(() {
      allrequeriments = false;
    });
    final String id = idController.value.text;
    final String pss = pssController.value.text;
    if (id.isNotEmpty && pss.isNotEmpty && id.isEmail) {
      setState(() {
        allrequeriments = true;
      });
    }
  }

  void loginUser() async {
    ProgressDialog.show(context);
    final AuthentificationApi api = GetIt.instance<AuthentificationApi>();
    final AuthenticationClient apiClient =
        GetIt.instance<AuthenticationClient>();
    final String id = idController.value.text;
    final String pss = pssController.value.text;
    HttpResponse<bool> response = await api.verifyPassword(id, pss);
    ProgressDialog.dismiss(context);
    if (response.data == null) {
      await Dialogs.alert(context,
          title: "Error", description: "Hubo un problema con tu conexión");
      return;
    }
    if (response.data == false) {
      await Dialogs.alert(context,
          title: "Error",
          description: "Los datos que ingresaste son incorrectos");
      return;
    }
    HttpResponse<AuthenticationResponse> responseToken = await api.getToken(id);
    if (responseToken.data != null) {
      Logs.p.i("usuario loggeado correctamente");
      await apiClient.saveSession(responseToken.data!);
    }
    GetIt.instance.registerFactory<bool>(
      () => keepSession,
    );
    fbauth.UserCredential userCredential = await fbauth.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: id, password: pss);
    await Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).iconTheme.color!;
    }
    return Theme.of(context).iconTheme.color!;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    if (context.isLandscape == true) {
      return loginPrincipalHorizontal(responsive);
    } else {
      return loginPrincipalVertical(responsive);
    }
  }

  SingleChildScrollView loginPrincipalVertical(Responsive responsive) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsive.hp(1)),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logos/main_logo_white.png',
                  color: Theme.of(context).iconTheme.color,
                  height: responsive.hp(17),
                ),
              ),
              SizedBox(height: responsive.hp(1)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: responsive.wp(7)),
                      Text(
                        'Inicio de sesión',
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(3)),
              TextFormGlobal(
                fontSize: responsive.hp(1.65),
                separation: responsive.wp(6.5),
                width: responsive.wp(80),
                height: responsive.hp(5),
                controller: idController,
                textInputType: TextInputType.emailAddress,
                textHint: 'Correo electrónico',
                obscureText: false,
              ),
              SizedBox(height: responsive.hp(2)),
              TextFormGlobal(
                fontSize: responsive.hp(1.65),
                separation: responsive.wp(6.5),
                width: responsive.wp(80),
                height: responsive.hp(5),
                controller: pssController,
                textInputType: TextInputType.text,
                textHint: 'Contraseña',
                obscureText: true,
              ),
              SizedBox(height: responsive.hp(2)),
              Row(
                children: [
                  SizedBox(
                    width: responsive.wp(9),
                  ),
                  SizedBox(
                    height: responsive.wp(4.5),
                    width: responsive.wp(4.5),
                    child: Checkbox(
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: keepSession,
                      onChanged: (bool? value) => {
                        setState(() {
                          keepSession = value!;
                        })
                      },
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                  Text(
                    'Mantener sesión iniciada ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: responsive.dp(1.4),
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.wp(3),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: responsive.wp(8),
                      ),
                      Text(
                        'Al iniciar sesión aceptas el procesamiento y \nobtención de los datos de tu cuenta',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(2)),
              ActionButtonSized(
                function: loginUser,
                isEnable: allrequeriments,
                fontSize: responsive.hp(1.65),
                width: responsive.wp(80),
                height: responsive.hp(6),
                buttonContent: "Iniciar sesión",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView loginPrincipalHorizontal(Responsive responsive) {
    return SingleChildScrollView(
        child: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/logos/main_logo_white.png',
                    height: responsive.wp(30),
                    color: Theme.of(context).iconTheme.color),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(4)),
                    Text(
                      'Inicio de sesión',
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormGlobal(
                          fontSize: responsive.wp(1.8),
                          separation: responsive.wp(0),
                          width: responsive.wp(55),
                          height: responsive.hp(8),
                          controller: idController,
                          textInputType: TextInputType.emailAddress,
                          textHint: 'Correo electrónico',
                          obscureText: false,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: responsive.wp(5),
                      height: responsive.hp(8),
                    ),
                    TextFormGlobal(
                      fontSize: responsive.wp(1.8),
                      separation: responsive.wp(0),
                      width: responsive.wp(55),
                      height: responsive.hp(8),
                      controller: pssController,
                      textInputType: TextInputType.text,
                      textHint: 'Contraseña',
                      obscureText: true,
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: responsive.wp(0),
                        ),
                        SizedBox(
                          height: responsive.wp(4.5),
                          width: responsive.wp(4.5),
                          child: Checkbox(
                            checkColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: keepSession,
                            onChanged: (bool? value) => {
                              setState(() {
                                keepSession = value!;
                              })
                            },
                          ),
                        ),
                        Text(
                          'Mantener sesión iniciada ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: responsive.dp(1.4),
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Al iniciar sesión aceptas el procesamiento y\n obtención de los datos de tu cuenta',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(7),
                    ),
                    ActionButtonSized(
                        isEnable: allrequeriments,
                        fontSize: responsive.wp(1.8),
                        width: responsive.wp(35),
                        height: responsive.hp(12),
                        buttonContent: 'Iniciar sesión',
                        function: loginUser),
                    SizedBox(
                      height: responsive.hp(7),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
          ],
        ),
      ),
    ));
  }
}
