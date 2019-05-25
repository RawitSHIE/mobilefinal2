class LoginUser {
  static int ID;
  static String USERID;
  static String NAME;
  static String AGE;
  static String PASS;
  static String QUOTE;

  static String who() {
    return "$USERID // $NAME // $PASS";
  }
}