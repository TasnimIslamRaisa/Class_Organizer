class AppConstant {
  static final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  static final RegExp phoneRegExp = RegExp(
      r'^\+?(\d{1,3})?[-. \(\)]?(\d{1,4})?[-. \(\)]?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$'
  );
}
