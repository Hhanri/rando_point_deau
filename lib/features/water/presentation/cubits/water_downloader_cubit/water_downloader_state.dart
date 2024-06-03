part of 'water_downloader_cubit.dart';

sealed class WaterDownloaderState extends Equatable {}

final class WaterDownloaderInitial extends WaterDownloaderState {
  @override
  List<Object?> get props => [];
}

final class WaterDownloaderLoading extends WaterDownloaderState {
  @override
  List<Object?> get props => [];
}

final class WaterDownloaderDownloading extends WaterDownloaderLoading {
  final Progress progress;

  WaterDownloaderDownloading(this.progress);

  @override
  List<Object?> get props => [
        progress,
      ];
}

final class WaterDownloaderError extends WaterDownloaderState {
  final String message;

  WaterDownloaderError(this.message);

  @override
  List<Object?> get props => [
        message,
      ];
}

final class WaterDownloaderSuccess extends WaterDownloaderState {
  @override
  List<Object?> get props => [];
}
