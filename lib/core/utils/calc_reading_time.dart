int calcReadingTime(String content) {
  final wordsCount = content.split(RegExp(r'\s+'));
  return (wordsCount.length / 200).ceil();
}
