import 'package:logger/logger.dart';

class CLogger {
  final Logger _logger = Logger();

  void info(String message) => _logger.i(message);

  void error(String message) => _logger.e(message);

  void debug(String message) => _logger.d(message);

  void warn(String message) => _logger.w(message);
}
