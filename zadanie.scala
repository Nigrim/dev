object ScalaPractice extends App {

  // Вывод фразы "Hello, Scala!" справа налево
  val phrase = "Hello, Scala!"
  val reversedPhrase = phrase.reverse
  println(s"1. Reversed Phrase: $reversedPhrase")

  // Перевод всей фразы в нижний регистр
  val lowercasePhrase = phrase.toLowerCase
  println(s"2. Lowercase Phrase: $lowercasePhrase")

  // Удаление символа "!"
  val phraseWithoutExclamation = phrase.replace("!", "")
  println(s"3. Phrase without '!': $phraseWithoutExclamation")

  // Добавление в конец фразы "and goodbye python!"
  val finalPhrase = phrase + " and goodbye python!"
  println(s"4. Final Phrase: $finalPhrase")
}
