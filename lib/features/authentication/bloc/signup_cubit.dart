import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<bool> {
  SignUpCubit() : super(false);

  void setFirstSignedUp({required final bool firstSignedUp}) async {
    emit(firstSignedUp);
  }
}
