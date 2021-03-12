import 'dart:async';

final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 0) {
        sink.add(password);
      } else {
        sink.addError('Este campo es obligatorio');
      }
    }
);
