extension StringUtils on String {
  String? get capitalizeFirst => _StringUtils.capitalizeFirst(this);

  String? get capitalize => _StringUtils.capitalize(this);
}

class _StringUtils {
  _StringUtils._();

  static bool isNull(dynamic value) => value == null;

  static String? capitalize(String s) {
    if (isNull(s)) return null;
    if (isBlank(s)) return s;
    return s.split(" ").map(capitalizeFirst).join(" ");
  }

  static String? capitalizeFirst(String s) {
    if (isNull(s)) return null;
    if (isBlank(s)) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static bool isBlank(dynamic value) {
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is Iterable || value is Map) {
      return value.isEmpty as bool;
    }
    return false;
  }
}
