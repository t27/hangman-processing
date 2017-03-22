import javax.swing.JOptionPane; 

String[] wordList = {"hello", "world", "computer", "program", "love", "systems", "process", "games", "wordsearch", "code"};
char[] correctChars = new char[10]; // Change this number to increase the maximum length of the word
char[] wrongChars = new char[6];
String selectedWord;
boolean isWordComplete;
boolean isGameOver;
int correctCount = 0;
int wrongCount = 0;

void showDialog(String message) {
  JOptionPane.showMessageDialog(null, message, "Message", JOptionPane.INFORMATION_MESSAGE); 
}

int indexGenerator() {
  // return random number between 0 and wordList.length
  return int(random(wordList.length));
}

String getWord() {
  return wordList[indexGenerator()];
}

void drawBase() {
  // Draw the hangman's base
  line(60, 320, 120, 320);
  line(90, 320, 90, 50);
  line(90, 100, 140, 50);
  line(90,50, 220, 50);
  line(220, 50, 220, 100);
}

void drawCharLines() {
 // draw the black lines for the letters in the selected word
 for(int i =0;i<selectedWord.length();i++) {
   line(i*50 + 120, 340, i*50 + 150, 340);
 }
}

boolean checkExistChar(char input, char[] arr) {
  // return true if the given array has input
  // else return false
  for(int i = 0;i< arr.length;i++){
    if(arr[i] == input) { // If the character exists, then return true
      return true;
    }
  }
  return false;
}

void checkWin() {
 // check if a player guesses all characters correctly
 if(correctCount == selectedWord.length()){
   // Player has won
   showDialog("You have won the game!");
   exit();
 }
}

void checkLost() {
 // Check if a player has lost the game(6 strikes) 
 if(wrongCount == 6){
   // Player has lost
   // show joptionpane dialog box
   showDialog("You have lost! Exiting the game! The word was - "+ selectedWord);
   exit();
 }
}

void fillLetters(char ch, int[] index) {
// This method receives a character that was guessed correct and an array of
// indexes that the character appears in the word.
// Then it will draw the character on the provided space on the canvas.
  for(int i =0;i<index.length;i++) {
    fill(0);
    text(ch, index[i]*50 +135, 330);
  }
}

void drawHead() {
  ellipse(220, 125, 50,50);
}
void drawBody(){
  line(220, 150, 220, 250);
}
void drawLeftLeg(){
  line(220,250, 180, 290);
}
void drawRightLeg(){
  line(220,250, 260, 290);
}
void drawLeftArm(){
 line(220, 200, 180, 180);
}
void drawRightArm(){
   line(220, 200, 260, 180);
}

void decisionMaker() {
// check number of mistakes and draw the appropriate parts of the hangman
  if(wrongCount > 0) { drawHead();}
  if(wrongCount > 1) { drawBody();}
  if(wrongCount > 2) { drawLeftLeg();}
  if(wrongCount > 3) { drawRightLeg();}
  if(wrongCount > 4) { drawRightArm();}
  if(wrongCount > 5) { drawLeftArm();}
}

void getUserInput() {
  String input = JOptionPane.showInputDialog("Please Enter a Character:"); 
  if(input.equals("")) { // If input is blank, return
    return;
  }
  char ch = input.charAt(0);
  boolean previouslyEntered =  (checkExistChar(ch, correctChars) || checkExistChar(ch, wrongChars));
  if(!previouslyEntered) { // If the character is not previously entered
    if(selectedWord.indexOf(ch) > -1) { // The character exists in the word
      // Creating the index array
      int index = selectedWord.indexOf(ch);
      ArrayList<Integer> indexList = new ArrayList<Integer>(); // Create a new array to store the 
      while(index >= 0) {
        correctChars[correctCount] = ch; // The character was found, so add it to the correct Array
        correctCount++; // Increase the correct counter
        indexList.add(index); // The character was found at index so add that index to the array used by fillLetters()
        index = selectedWord.indexOf(ch, index+1); // check if the character is found again in the word
      }
      // Calling function to display the letter on the screen
      fillLetters(ch, getIntArrayFromArraylist(indexList));
    } else { // Does not exist
      wrongChars[wrongCount] = ch; // Add the wrong character to the array
      wrongCount ++;
      decisionMaker(); // Draw the hangman
    }
  } else { // If the character is previously entered
    showDialog("You have repeated the letter "+ ch+ " ! Please Try Again");
  }
}

int[] getIntArrayFromArraylist(ArrayList<Integer> list) { // Convert an array list to a normal int array
  int[] arr = new int[list.size()];
  for(int i = 0; i < list.size(); i++) {
      arr[i] = list.get(i);
  }
  return arr;
}

void printWrongGuesses() {
  println("Number of Mistakes:" + wrongCount);
  for(int i =0; i < wrongCount; i++) {
    print(wrongChars[i] + " ");
  }
  println("");
}

void setup() {
  size(640,360);
  stroke(0);
  strokeWeight(4);
  drawBase();
  selectedWord = getWord();
  drawCharLines();
}

void draw() {
  process();
}

void process() {
  getUserInput();
  printWrongGuesses();
  checkLost();
  checkWin();
}
