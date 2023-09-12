import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterppx/src/component/paybox.dart';
import 'package:flutterppx/src/controller/firebase_controller.dart';
import 'package:flutterppx/src/model/pagoplux_model.dart';
import 'package:flutterppx/src/model/response_model.dart';
import 'package:flutterppx/src/pages/transaction/historyPage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/*
 * Clase demo para uso de botón de pagos flutter
 * Widget con estado
 */
class PayboxDemoPage extends StatefulWidget {
  @override
  _PayboxDemoPageState createState() => _PayboxDemoPageState();
}

class _PayboxDemoPageState extends State<PayboxDemoPage> {
  final FirebaseController _firebaseController = FirebaseController();
  final user = FirebaseAuth.instance.currentUser;
  late PagoPluxModel _paymentModelExample;
  String voucher = 'Pendiente Pago ';
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  String phoneNumber = '';
  TextEditingController _locationController = new TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _identificationController = TextEditingController();

  // Se construiye el view<
  Widget build(BuildContext context) {
    openPpx();
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin Flutter PPX'),
        actions: [
          IconButton(
            onPressed: _firebaseController.signUserOut,
            icon: Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: Column(
          children: [
            Image(
              //width: double.infinity,
              width: 250,
              image: AssetImage('assets/images/logo2.png'),
            ),
            Container(
              margin: EdgeInsets.all(60.0),
              child: Form(
                key: _formKey,
                child: formUI(),
              ),
            ),
          ],
        ),
      ),
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.payments_rounded),
  onPressed: () {
    // Validar el formulario antes de continuar
    if (_formKey.currentState!.validate() &&
        validatePhoneNumber(phoneNumber) == null ) {
      // El formulario es válido, puedes realizar la acción deseada
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModalPagoPluxView(
            pagoPluxModel: _paymentModelExample,
            onClose: obtenerDatos,
          ),
        ),
      );
    } else {
      // Mostrar un mensaje de error o realizar alguna acción adicional
      // para indicar al usuario que debe corregir los campos incorrectos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos correctamente.'),
        ),
      );
    }
  },
  backgroundColor: Theme.of(context).primaryColor,
),
    );
  }

  //Formulario

  Widget formUI() {
    return Column(children: <Widget>[
      Text("Complete el Fomulario",
          style: TextStyle(
            color: Color.fromARGB(255, 3, 3, 3),
            fontWeight: FontWeight.normal,
            fontSize: 22.0,
          )),
      SizedBox(height: 10),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xFF18544B),
            ),
            contentPadding: EdgeInsets.all(15.0),
            filled: true,
            fillColor: Color.fromRGBO(142, 142, 147, 1.2),
            labelText: 'Nombres',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            labelStyle: new TextStyle(
                color: Color(0xFF18544B),
                fontSize: 15.0,
                fontWeight: FontWeight.normal),
          ),
          validator: validateName,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: _phoneInput(context),
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.location_on,
              color: Color(0xFF18544B),
            ),
            contentPadding: EdgeInsets.all(15.0),
            filled: true,
            fillColor: Color.fromRGBO(142, 142, 147, 1.2),
            labelText: 'Dirección',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            labelStyle: new TextStyle(
                color: Color(0xFF18544B),
                fontSize: 15.0,
                fontWeight: FontWeight.normal),
          ),
          validator: validateName,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: Color(0xFF18544B)),
              contentPadding: EdgeInsets.all(15.0),
              filled: true,
              fillColor: Color.fromRGBO(142, 142, 147, 1.2),
              labelText: "Correo electrónico",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40.0),
              ),
              labelStyle: new TextStyle(
                  color: Color(0xFF18544B),
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal)),
          controller: _emailController,
          validator: (value) =>
              !validateEmail(value!) ? "El email es obligatorio*" : null,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(
              decimal: true), // Permite números decimales
          inputFormatters: [
            DecimalTextInputFormatter(), // Usa el TextInputFormatter personalizado
          ],
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.request_page_outlined, color: Color(0xFF18544B)),
            contentPadding: EdgeInsets.all(15.0),
            filled: true,
            fillColor: Color.fromRGBO(142, 142, 147, 1.2),
            labelText: "Valor de pago",
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            labelStyle: new TextStyle(
              color: Color(0xFF18544B),
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          controller: _paymentController,
          validator: (value) =>
              value!.isEmpty ? "El valor de pago es obligatorio*" : null,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(), // Cambia el tipo de teclado
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // Limita la entrada a 10 caracteres
                  CedulaTextInputFormatter(), // Usa el TextInputFormatter personalizado
                ],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.credit_card, color: Colors.blue),
            contentPadding: EdgeInsets.all(15.0),
            filled: true,
            fillColor: Color.fromRGBO(142, 142, 147, 1.2),
            labelText: "Número de Cédula",
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          controller: _identificationController,
          validator: (value) =>
              value!.isEmpty ? "El número de cédula es obligatorio*" : null,
        ),
      ),
    ]);
  }

  /*
   * Se encarga de iniciar los datos para el proceso de pago
   */
  openPpx() {
    print('Se habre el botón de pagos');
    this._paymentModelExample = new PagoPluxModel();
    this._paymentModelExample.payboxRemail = 'contactanos@pagoplux.com';
    this._paymentModelExample.payboxEnvironment = 'sandbox';
    this._paymentModelExample.payboxProduction = true;
    this._paymentModelExample.payboxBase0 = 4.00;
    this._paymentModelExample.payboxBase12 = 8;
    this._paymentModelExample.payboxSendname = 'Gerardo';
    this._paymentModelExample.payboxSendmail = 'cristian.bastidas@aol.com';
    this._paymentModelExample.payboxRename = 'KrugerShop';
    this._paymentModelExample.PayboxDirection = 'Bolivar';
    this._paymentModelExample.payboxDescription = 'Pago desde Flutter';

    this._paymentModelExample.payboxClientName = nameController.text;
    this._paymentModelExample.payboxClientPhone = phoneNumber;
    this._paymentModelExample.payboxDirection = _locationController.text;
    this._paymentModelExample.payboxSendEmail = _emailController.text;
    this._paymentModelExample.payboxPaymentValue = _paymentController.text;

    this._paymentModelExample.payboxClientIdentification = _identificationController.text;






  }

  Widget crearTop(BuildContext context) {
    return Container(height: 0);
  }

  obtenerDatos(PagoResponseModel datos) {
    this.voucher = 'Voucher: ' + datos.detail.token;
    setState(() {});
    print('LLego ' + datos.detail.token);

    setState(() {});

  // Después de obtener los datos del pago exitoso, navega a la pantalla de historial de cobros
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HistorialCobrosPage(),
    ),
  );

  
  }

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  String? validateName(String? value) {
    String pattern = r'(^[a-zA-ZñÑ ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return "El nombre es obligatorio*";
    } else if (!regExp.hasMatch(value!)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String? validatePasswordM(String? value) {
    String pattern =
        r'(^(?=(?:.*\d){1})(?=(?:.*[A-Z]){1})(?=(?:.*[a-z]){2})\S{8,}$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length <= 8) {
      return "Debe tener minimo 8 caracteres";
    } else if (!regExp.hasMatch(value)) {
      return "La Password Mayusculas, Minusculas y Numeros";
    }
    return null;
  }

  bool validatePayment(String email) {
    return RegExp("").hasMatch(email);
  }

  String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "El número de teléfono es obligatorio*";
  }
  return null;
}


  Widget _phoneInput(BuildContext context) {
    return IntlPhoneField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          filled: true,
          fillColor: Color.fromRGBO(142, 142, 147, 1.2),
          labelText: 'Ingresar celular',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
          labelStyle: new TextStyle(
              color: Color(0xFF18544B),
              fontSize: 15.0,
              fontWeight: FontWeight.normal),
        ),
        initialCountryCode: 'EC',
        disableLengthCheck: true,
        searchText: 'Buscar país',
        onChanged: (phone) {
          phoneNumber = phone.completeNumber;
        });
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Utiliza una expresión regular para permitir solo números y un punto
    final regExp = RegExp(r'^\d*\.?\d{0,2}');
    String newText = regExp.stringMatch(newValue.text) ?? '';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CedulaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Utiliza una expresión regular para permitir solo números
    final regExp = RegExp(r'^\d*$');
    String newText = regExp.stringMatch(newValue.text) ?? '';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
