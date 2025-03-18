import 'package:kiwi/kiwi.dart';

final injector = Injector._internal();

class Injector {
  final KiwiContainer container = KiwiContainer();

  Injector._internal();

  T resolve<T>([String? name]) => container.resolve(name);

  unregister<T>([String? name]) => container.unregister(name);
}
