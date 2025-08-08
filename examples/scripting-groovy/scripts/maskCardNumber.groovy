def maskCardNumber(parmName, maskChar, countPlainChars)
{
  String cardNumber = _context.getValue(parmName)
  if (cardNumber == null || cardNumber.trim().length() <= countPlainChars)
  {
    return maskChar;
  }

  String trimmedNumber = cardNumber.trim()
  final int cardNumberLen = trimmedNumber.length()
  
  int countMaskedChars = cardNumberLen - countPlainChars
  char[] chars = new char[countMaskedChars]
  for (int i = 0; i < chars.length; i++) 
  {
    chars[i] = maskChar
  }

  String unmaskedChars = trimmedNumber.substring(countMaskedChars)
  
  String maskedNumber = new String(chars) + unmaskedChars
  return maskedNumber
}
