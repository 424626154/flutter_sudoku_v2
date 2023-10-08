
class DifficultyLevels {
  // "easy": 62,
  // "medium": 53,
  // "hard": 44,
  // "very-hard": 35,
  // "insane": 26,
  // "inhuman": 17,
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';
  static const String veryHard = 'very-hard';
  static const String insane = 'insane';
  static const String inhuman = 'inhuman';

  static int getDifficultyLevel(String? difficultyStr){
    int level = 0;
    switch(difficultyStr){
      case easy:
        level = 62;
        break;
      case medium:
        level = 53;
        break;
      case hard:
        level = 44;
        break;
      case veryHard:
        level = 35;
        break;
      case insane:
        level = 26;
        break;
      case inhuman:
        level = 17;
        break;
    }
    return level;
  }

}