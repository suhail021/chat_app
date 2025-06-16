import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: event.email,
                password: event.password,
              );
          emit(LoginSuccess());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(LoginFailure(errorMessage: 'user-not-found'));
          } else if (e.code == 'wrong-password') {
            emit(LoginFailure(errorMessage: 'wrong-password'));
          }
        } catch (e) {
          emit(
            LoginFailure(errorMessage: 'there was an error please try again'),
          );
        }
      }else if(event is RegisterEvent){
emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: event.email, password: event.password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errorMessage: "weak-password"));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMessage: "email-already-in-use"));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: "there was an error please try again"));
    }
      }
    });
  }
}
