class JumpRegistetBean {
  String _phone="";
  var callBack;

  JumpRegistetBean(String phone) {
    this._phone = phone;
  }

  set phone(value) => this._phone = value;

  get phone => this._phone;


}
