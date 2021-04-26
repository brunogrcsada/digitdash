
import 'dart:math';
import 'dart:async';

void main() {
  var questions = [];
  var repeated = 0;
  var roundRepeated = 0;
  var previousQuestion = "";
  var roundNumber = 1000000000;
  List<int> occurrence = [];

  for (var x = 0; x < roundNumber; x++){
      var question = createQuestion();

      if(question.toString() == previousQuestion.toString()){
          repeated++;
          roundRepeated++;
      }

      previousQuestion = question;
      questions.add(question);

      if(x % 10 == 0){
        occurrence.add(roundRepeated);
        roundRepeated = 0;
        questions.clear();
      }
  }

  var maxRepeated = occurrence.reduce(max);
  print("Maximum number of repeated questions: " + maxRepeated.toString());
  var occurrenceCount = 0;

  for (var y = 0; y < occurrence.length; y++){
      if(occurrence[y] == maxRepeated){
        occurrenceCount++;
      }
  }
  print("Number of times max number was encountered: " 
        + occurrenceCount.toString());
  print("Percentage of rounds with a lot of repeated questions: "
        + ((occurrenceCount/(roundNumber/10))*100).toString() + "%");
  print("Total number of repeated questions: " 
        + repeated.toString());
}

createQuestion() {
    Random random = new Random();


    String question = "";

    int firstNumber = 1 + random.nextInt(12 - 1);
    int questionOperator = random.nextInt(3);
    int secondNumber = 1 + random.nextInt(12 - 1);

    if (questionOperator == 2) {
      if (firstNumber == 1) {
        secondNumber = 1;
      } else {
        secondNumber = 1 + random.nextInt(firstNumber - 1);
      }
    } else if (questionOperator == 1) {
      var numberList = [];
      for (var i = 1; i <= 12; i++) {
        if (firstNumber % i == 0) {
          numberList.add(i);
        }
      }

      secondNumber = numberList[random.nextInt(numberList.length)];
    }

    if (questionOperator == 0) {
      question = firstNumber.toString() + " x " + secondNumber.toString();
    } else if (questionOperator == 1) {
      question = firstNumber.toString() + " ÷ " + secondNumber.toString();
    } else if (questionOperator == 2) {
      question = firstNumber.toString() + " - " + secondNumber.toString();
    } else {
      question = firstNumber.toString() + " + " + secondNumber.toString();
    }

    return question;
  }