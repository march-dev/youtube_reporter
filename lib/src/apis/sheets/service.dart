import 'package:googleapis/sheets/v4.dart';
import 'package:youtube_reporter/core.dart';

const _sheetRange = 'A:A';
const _sheetMajorDimension = 'COLUMNS';

class SheetsService {
  factory SheetsService() => _instance;
  SheetsService._();
  static final _instance = SheetsService._();

  late GoogleSignInService _authService;
  late SheetsApi _sheetsApi;

  Future<bool> init(GoogleSignInService service) async {
    _authService = service;

    if (service.isLoggedIn) {
      _sheetsApi = SheetsApi(_authService.client!);
    }

    return service.isLoggedIn;
  }

  Future<void> _loginSilently() async {
    final result = await _authService.loginSilently();

    if (result) {
      _sheetsApi = SheetsApi(_authService.client!);
    }
  }

  Future<List<String>> getYouTubeVideoIds() async {
    try {
      final table = await _sheetsApi.spreadsheets.values.get(
        AppEnv.sheetId,
        _sheetRange,
        majorDimension: _sheetMajorDimension,
      );

      final column = table.values?.first ?? [];
      final ids = column
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();

      return ids;
    } catch (e, trace) {
      if (isAccessDeniedException(e)) {
        log('Login session ended. Creating new one...');
        await _loginSilently();
        log('New login session created. Retrying...');
        return await getYouTubeVideoIds();
      }

      logError(e, trace);
      return [];
    }
  }
}
