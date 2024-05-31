import 'package:equatable/equatable.dart';

typedef StepProgress = ({
  int current,
  int total,
});

final class Progress extends Equatable {
  final String title;
  final num progress;
  final num total;

  const Progress({
    required this.title,
    required this.progress,
    required this.total,
  });

  factory Progress.httpDownload({
    required num progress,
    required num total,
    StepProgress? stepProgress,
  }) {
    String title = "Downloading...";
    if (stepProgress != null) {
      title += " (${stepProgress.current}/${stepProgress.total})";
    }
    return Progress(
      title: title,
      progress: progress,
      total: total,
    );
  }

  factory Progress.dbInsert({
    required int progress,
    required int total,
    StepProgress? stepProgress,
  }) {
    String title = "Saving locally...";
    if (stepProgress != null) {
      title += " (${stepProgress.current}/${stepProgress.total})";
    }
    return Progress(
      title: title,
      progress: progress,
      total: total,
    );
  }

  @override
  List<Object?> get props => [
        title,
        progress,
        total,
      ];
}

typedef ProgressCallback = void Function(Progress progress);
