import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/app/cubit/app_state.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/service/preferences/preferences.dart';


class AppCubit extends Cubit<GenericState> {
  AppCubit() : super(Initial()) {
    check();
  }

  bool _isDialogOpen = false;
  bool get isDialogOpen => _isDialogOpen;

  toggleDialog(bool isOpen) {
    _isDialogOpen = isOpen;
  }

  check() async {
    emit(SplashScreen());
    final prefs = await PreferencesService.instance;

    try {
      if (!prefs.wasAuthorizationPassed) {
        emit(Unauthorized());
        return;
      }
    } on HttpException {
      await prefs.clear();
      emit(Unauthorized());
    }
  }
}
