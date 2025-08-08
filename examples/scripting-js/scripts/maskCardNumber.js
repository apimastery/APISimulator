function maskCardNumber(parmName, maskChar, countPlainChars)
{
  var cardNumber = '' + _context.getValue(parmName);
  if (cardNumber == null || cardNumber.trim().length <= countPlainChars)
  {
    return maskChar;
  }

  var trimmedNumber = cardNumber.trim();
  var cardNumberLen = trimmedNumber.length;
  
  var countMaskedChars = cardNumberLen - countPlainChars;
  var maskedNumber = '';
  for (var i = 0; i < countMaskedChars; i++) 
  {
    maskedNumber = maskedNumber + maskChar;
  }

  var unmaskedChars = trimmedNumber.substring(countMaskedChars);
  maskedNumber = maskedNumber + unmaskedChars;
  return maskedNumber;
}
