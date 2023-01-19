// extends Equtable to be able to compare the previous and the current state (for non-autoDispose providers to work)
import 'package:equatable/equatable.dart';

class SeasonDetailsArgs extends Equatable {
  final int tvShowId;
  final int seasonNumber;

  const SeasonDetailsArgs(this.tvShowId, this.seasonNumber);

  const SeasonDetailsArgs.empty()
      : tvShowId = 0,
        seasonNumber = 0;

  @override
  List<Object?> get props => [tvShowId, seasonNumber];
}
