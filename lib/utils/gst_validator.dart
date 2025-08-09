class GSTValidator {
  // Indian GST number format: 2 digits (state code) + 10 characters (PAN) + 1 digit (entity number) + 1 character (Z) + 1 check digit
  // Total: 15 characters
  // Format: NNAAAAAAAAANAZ where N = numbers, A = alphanumeric

  static bool isValidGST(String gstNumber) {
    if (gstNumber.isEmpty) return false;

    // Remove spaces and convert to uppercase
    final cleanGST = gstNumber.replaceAll(' ', '').toUpperCase();

    // Check length
    if (cleanGST.length != 15) return false;

    // Check format using regex
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}[Z]{1}[0-9A-Z]{1}$',
    );

    return gstRegex.hasMatch(cleanGST);
  }

  static String? validateGSTNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GST number is required';
    }

    final cleanValue = value.trim().toUpperCase();

    if (!isValidGST(cleanValue)) {
      return 'Invalid GST number format (15 characters: 2 digits + 10 alphanumeric + 1 digit + 1 letter + 1 digit)';
    }

    return null;
  }

  static String formatGST(String gstNumber) {
    final cleanGST = gstNumber.replaceAll(' ', '').toUpperCase();
    if (cleanGST.length == 15) {
      // Format as: 12ABCDE1234F1Z5
      return '${cleanGST.substring(0, 2)} ${cleanGST.substring(2, 7)} ${cleanGST.substring(7, 11)} ${cleanGST.substring(11, 12)} ${cleanGST.substring(12, 13)} ${cleanGST.substring(13, 14)} ${cleanGST.substring(14, 15)}';
    }
    return gstNumber;
  }
}
