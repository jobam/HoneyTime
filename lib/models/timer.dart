class Timer
{
static const int CYCLE_DEFAULT = 1;
static const int EXERCICES_NB_DEFAULT = 1;
static const int EXERCICES_TIME_INSEC_DEFAULT = 25;
static const int PAUSE_BETWEEN_EXERCICES_DEFAULT = 10;
static const int PAUSE_BETWEEN_CYCLES_DEFAULT = 30;

  int cycles = CYCLE_DEFAULT;
  int exercicesNb = EXERCICES_NB_DEFAULT;
  int exerciceTimeInSec = EXERCICES_TIME_INSEC_DEFAULT;
  int pauseBetweenExercices = PAUSE_BETWEEN_EXERCICES_DEFAULT;
  int pauseBetweenCycles = PAUSE_BETWEEN_CYCLES_DEFAULT;

  Timer(this.cycles, this.exercicesNb, this.exerciceTimeInSec,
      this.pauseBetweenExercices, this.pauseBetweenCycles) {}

  Timer.fromJson(Map<String, dynamic> map){
    cycles = map['cycles'] ?? CYCLE_DEFAULT;
    exercicesNb = map['exercicesNb'] ?? EXERCICES_NB_DEFAULT;
    exerciceTimeInSec = map['exerciceTimeInSec'] ?? EXERCICES_TIME_INSEC_DEFAULT;
    pauseBetweenExercices = map['pauseBetweenExercices'] ?? PAUSE_BETWEEN_EXERCICES_DEFAULT;
    pauseBetweenCycles = map['pauseBetweenCycles'] ?? PAUSE_BETWEEN_CYCLES_DEFAULT;
  }
}
