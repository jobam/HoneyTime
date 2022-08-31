class Timer {
  static const int CYCLE_DEFAULT = 1;
  static const int exercises_NB_DEFAULT = 1;
  static const int exercises_TIME_INSEC_DEFAULT = 25;
  static const int PAUSE_BETWEEN_EXERCISES_DEFAULT = 10;
  static const int PAUSE_BETWEEN_CYCLES_DEFAULT = 30;

  static Timer DEFAULT_TIMER = Timer(
      'DEFAULT',
      CYCLE_DEFAULT,
      exercises_NB_DEFAULT,
      exercises_TIME_INSEC_DEFAULT,
      PAUSE_BETWEEN_EXERCISES_DEFAULT,
      PAUSE_BETWEEN_CYCLES_DEFAULT);

  String id = '';
  int cycles = CYCLE_DEFAULT;
  int exercisesNb = exercises_NB_DEFAULT;
  int exerciseTimeInSec = exercises_TIME_INSEC_DEFAULT;
  int pauseBetweenExercises = PAUSE_BETWEEN_EXERCISES_DEFAULT;
  int pauseBetweenCycles = PAUSE_BETWEEN_CYCLES_DEFAULT;

  Timer(this.id, this.cycles, this.exercisesNb, this.exerciseTimeInSec,
      this.pauseBetweenExercises, this.pauseBetweenCycles) {}

  Timer.fromJson(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    cycles = map['cycles'] ?? CYCLE_DEFAULT;
    exercisesNb = map['exercisesNb'] ?? exercises_NB_DEFAULT;
    exerciseTimeInSec =
        map['exerciseTimeInSec'] ?? exercises_TIME_INSEC_DEFAULT;
    pauseBetweenExercises =
        map['pauseBetweenExercises'] ?? PAUSE_BETWEEN_EXERCISES_DEFAULT;
    pauseBetweenCycles =
        map['pauseBetweenCycles'] ?? PAUSE_BETWEEN_CYCLES_DEFAULT;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cycles': cycles,
      'exercisesNb': exercisesNb,
      'exerciseTimeInSec': exerciseTimeInSec,
      'pauseBetweenExercises': pauseBetweenExercises,
      'pauseBetweenCycles': pauseBetweenCycles
    };
  }
}
