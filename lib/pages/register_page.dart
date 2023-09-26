import 'package:asispnia/api/authentification_api.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/utils/capitalize.dart';
import 'package:asispnia/pages/qr_reader.dart';
import 'package:asispnia/utils/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:html/dom.dart' as dom;
import 'package:random_string/random_string.dart';
import '../model/user.dart';
import '../widgets/dropdown_menu.dart';
import '../utils/responsive.dart';
import '../widgets/action_button_sized.dart';
import '../widgets/dialogs.dart';
import '../widgets/text_form.dart';
import '../data/enum_lists.dart';
import 'package:html/parser.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isChecked = false;
  final TextEditingController idController = TextEditingController();
  final TextEditingController pssController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  late bool allrequeriments;
  late Map<String, String> identificactionQRData;
  String? qRLink;

  @override
  void initState() {
    super.initState();
    allrequeriments = false;
    pssController.addListener(verifyAllRequirements);
    idController.addListener(verifyAllRequirements);
    nameController.addListener(verifyAllRequirements);
    usernameController.addListener(verifyAllRequirements);
    mailController.addListener(verifyAllRequirements);
  }

  @override
  void dispose() {
    pssController.removeListener(verifyAllRequirements);
    idController.removeListener(verifyAllRequirements);
    nameController.removeListener(verifyAllRequirements);
    usernameController.removeListener(verifyAllRequirements);
    mailController.removeListener(verifyAllRequirements);
    super.dispose();
  }

  Future<void> registerQR() async {
    final AuthentificationApi api = GetIt.instance<AuthentificationApi>();
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QRViewExample(
                callbackFn: (p0) {
                  qRLink = p0!;
                },
              )),
    );
    if (qRLink != null) {
      ProgressDialog.show(context);
      qRLink = qRLink!.replaceRange(8, 11, 'servicios');
      if (!qRLink!.contains("https://servicios.dae.ipn.mx/vcred")) return;
      HttpResponse<String> response = await api.getQRApi(qRLink!);
      ProgressDialog.dismiss(context);
      if (response.data != null) {
        dom.Document responseHTML = parse(response.data);
        dom.Element? name = responseHTML.querySelector(".nombre");
        dom.Element? idUser = responseHTML.querySelector(".boleta");
        setState(() {
          idController.text = idUser!.text;
          nameController.text = name!.text.toTitleCase();
          List<String> splittedString = name.text.toTitleCase().split(" ");
          String generatedUsername =
              '${splittedString[0]}${splittedString[splittedString.length - 2]}_${randomAlphaNumeric(2)}';
          usernameController.text = generatedUsername;
        });
        verifyAllRequirements();
        return;
      } else {
        Logs.p.e("Hubo un error al consumir la API");
      }
      return;
    }
  }

  void verifyAllRequirements() {
    setState(() {
      allrequeriments = false;
    });
    final String id = idController.value.text;
    final String pss = pssController.value.text;
    final String name = nameController.value.text;
    final String username = usernameController.value.text;
    final String mail = mailController.value.text;
    if (id.isNotEmpty &&
        pss.isNotEmpty &&
        name.isNotEmpty &&
        pss.length >= 10 &&
        id.isNumericOnly &&
        username.isNotEmpty &&
        !username.isNumericOnly &&
        username.length >= 8 &&
        !name.isNumericOnly &&
        id.length == 10 &&
        mail.isNotEmpty &&
        mail.isEmail) {
      setState(() {
        allrequeriments = true;
      });
    }
  }

  Future<void> registerUser() async {
    ProgressDialog.show(context);
    fbauth.FirebaseAuth _auth = fbauth.FirebaseAuth.instance;
    FirebaseFirestore _store = FirebaseFirestore.instance;
    final AuthentificationApi api = GetIt.instance<AuthentificationApi>();
    final String id = idController.value.text;
    final String pss = pssController.value.text;
    final String name = nameController.value.text;
    final String username = usernameController.value.text;
    final String mail = mailController.value.text;
    User user = User(
        idUser: id, name: name, username: username, type: "Alumno", mail: mail);
    HttpResponse response = await api.registerUser(user, pss);
    if (response.data != null) {
      setState(() {
        idController.clear();
        nameController.clear();
        usernameController.clear();
        pssController.clear();
        mailController.clear();
      });
      fbauth.User? user = (await _auth.createUserWithEmailAndPassword(
              email: mail, password: pss))
          .user;
      user!.updateDisplayName(name);
      await _store.collection("users").doc(_auth.currentUser!.uid).set({
        "name": name,
        "id": id,
        "username": username,
        "mail": mail,
        "status": "unavailable",
      });
      ProgressDialog.dismiss(context);
      Dialogs.alert(context,
          title: "Usuario registrado con exito", description: ":)");
    } else {
      ProgressDialog.dismiss(context);
      Dialogs.alert(context,
          title: "Error", description: "El usuario ya existe");
    }
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
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    if (context.isLandscape == true) {
      return registerPrincipalHorizontal(responsive);
    } else {
      return registerPrincipalVertical(responsive);
    }
  }

  SingleChildScrollView registerPrincipalVertical(Responsive responsive) {
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
                height: responsive.hp(17),
                color: Theme.of(context).iconTheme.color,
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
                      'Registro',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormGlobal(
                  fontSize: responsive.hp(1.65),
                  separation: responsive.wp(0),
                  width: responsive.wp(37),
                  height: responsive.hp(5),
                  controller: idController,
                  textInputType: TextInputType.number,
                  textHint: 'Matrícula',
                  obscureText: false,
                ),
                TextFormGlobal(
                  fontSize: responsive.hp(1.65),
                  separation: responsive.wp(0),
                  width: responsive.wp(37),
                  height: responsive.hp(5),
                  controller: usernameController,
                  textInputType: TextInputType.text,
                  textHint: 'Nombre de usuario',
                  obscureText: false,
                ),
              ],
            ),
            SizedBox(height: responsive.hp(1.6)),
            TextFormGlobal(
              fontSize: responsive.hp(1.65),
              separation: responsive.wp(6.5),
              width: responsive.wp(80),
              height: responsive.hp(5),
              controller: nameController,
              textInputType: TextInputType.text,
              textHint: 'Nombre',
              obscureText: false,
            ),
            SizedBox(height: responsive.hp(1.6)),
            TextFormGlobal(
              fontSize: responsive.hp(1.65),
              separation: responsive.wp(6.5),
              width: responsive.wp(80),
              height: responsive.hp(5),
              controller: mailController,
              textInputType: TextInputType.emailAddress,
              textHint: 'Correo electronico',
              obscureText: false,
            ),
            SizedBox(height: responsive.hp(1.6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormGlobal(
                  fontSize: responsive.hp(1.65),
                  separation: responsive.wp(0),
                  width: responsive.wp(37),
                  height: responsive.hp(5),
                  controller: pssController,
                  textInputType: TextInputType.text,
                  textHint: 'Contraseña',
                  obscureText: true,
                ),
                Column(
                  children: [
                    Text(
                      'Rol',
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: responsive.hp(1.65),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(5),
                      width: responsive.wp(37),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsive.hp(1.8),
                            fontWeight: FontWeight.bold),
                        initialValue: "Alumno",
                        enabled: false,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: responsive.hp(4)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        value: isChecked,
                        onChanged: (bool? value) => {
                          setState(() {
                            isChecked = value!;
                          })
                        },
                      ),
                    ),
                    SizedBox(
                      width: responsive.wp(1.5),
                    ),
                    Text(
                      'Acepto los ',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    InkWell(
                      child: Text('terminos y condiciones',
                          style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Text(
                      ' para',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      'la creación y obtención de datos',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: responsive.hp(1.6)),
            ActionButtonSized(
              function: registerUser,
              isEnable: isChecked && allrequeriments,
              fontSize: responsive.dp(1.7),
              width: responsive.wp(80),
              height: responsive.hp(6),
              buttonContent: "Registrarse",
            ),
            SizedBox(height: responsive.hp(0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: registerQR,
                  child: Text(
                    'Registrate con QR',
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: registerQR,
                    icon: Icon(
                      CupertinoIcons.qrcode,
                      size: responsive.wp(8),
                    )),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  SingleChildScrollView registerPrincipalHorizontal(Responsive responsive) {
    return SingleChildScrollView(
        child: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/logos/main_logo_white.png',
                  color: Theme.of(context).iconTheme.color,
                  height: responsive.wp(26),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(4)),
                    Text(
                      'Registro',
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormGlobal(
                          fontSize: responsive.wp(1.8),
                          separation: responsive.wp(0),
                          width: responsive.wp(28),
                          height: responsive.hp(10),
                          controller: nameController,
                          textInputType: TextInputType.text,
                          textHint: 'Nombre',
                          obscureText: false,
                        ),
                        SizedBox(
                          width: responsive.wp(4),
                        ),
                        TextFormGlobal(
                          fontSize: responsive.wp(1.8),
                          separation: responsive.wp(0),
                          width: responsive.wp(28),
                          height: responsive.hp(10),
                          controller: usernameController,
                          textInputType: TextInputType.text,
                          textHint: 'Nombre de usuario',
                          obscureText: false,
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.hp(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormGlobal(
                          fontSize: responsive.wp(1.8),
                          separation: responsive.wp(0),
                          width: responsive.wp(18),
                          height: responsive.hp(10),
                          controller: idController,
                          textInputType: TextInputType.number,
                          textHint: 'Matrícula',
                          obscureText: false,
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        TextFormGlobal(
                          fontSize: responsive.dp(1.8),
                          separation: responsive.wp(0),
                          width: responsive.wp(18),
                          height: responsive.hp(10),
                          controller: pssController,
                          textInputType: TextInputType.text,
                          textHint: 'Contraseña',
                          obscureText: true,
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Column(
                          children: [
                            Text(
                              'Rol',
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: responsive.wp(1.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(10),
                              width: responsive.wp(18),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: responsive.dp(1.8),
                                    fontWeight: FontWeight.bold),
                                initialValue: "Alumno",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.hp(8)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: responsive.wp(3),
                              width: responsive.wp(3),
                              child: Checkbox(
                                checkColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) => {
                                  setState(() {
                                    isChecked = value!;
                                  })
                                },
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(1),
                            ),
                            Text(
                              "Acepto los ",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            InkWell(
                              onTap: () async {},
                              child: Text('terminos y condiciones ',
                                  style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Text(
                              "para la creación y obtención",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: responsive.wp(4)),
                          child: Text(
                            "de datos",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(7),
                    ),
                    ActionButtonSized(
                        isEnable: isChecked && allrequeriments,
                        fontSize: responsive.dp(1.7),
                        width: responsive.wp(35),
                        height: responsive.hp(12),
                        buttonContent: 'Registrate',
                        function: registerUser),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: registerQR,
                          child: Text(
                            'Registrate con QR',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: registerQR,
                            icon: Icon(
                              CupertinoIcons.qrcode,
                              size: responsive.wp(4),
                            )),
                      ],
                    ),
                    SizedBox(height: responsive.hp(4)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
