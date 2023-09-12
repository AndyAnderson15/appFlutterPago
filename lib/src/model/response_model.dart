/* ***************************************************************
 * @author       : Gerardo Yandún
 * @model        : PagoResponseModel
 * @description  : Objeto de respuesta en pago
 * @version  : v1.0.0
 * @copyright (c)  PagoPlux 2021
 *****************************************************************/
class PagoResponseModel {
  late int code;
  late String description;
  late DetailModel detail;
  late String status;

  PagoResponseModel.fromJsonMap(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    status = json['status'];
    detail = DetailModel.fromJsonMap(json['detail']);
  }
}

class DetailModel {
  late String token;
  late String amount;
  late String cardType;
  late String cardInfo;
  late String cardIssuer;
  late String clientID;
  late String clientName;
  late String fecha;

  DetailModel.fromJsonMap(Map<String, dynamic> json) {
    token = json['token'];
    amount = json['amount'];
    cardType = json['cardType'];
    cardInfo = json['cardInfo'];
    cardIssuer = json['cardIssuer'];
    clientID = json['clientID'];
    clientName = json['clientName'];
    fecha = json['fecha'];
  }
}
