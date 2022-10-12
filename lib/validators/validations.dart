class Validations{
  static bool isValidMoney(String money){
    if(money == null || money == ''){
      return false;
    }
    return true;
  }
}