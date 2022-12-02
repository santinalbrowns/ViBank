import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "village-banking-369511",
  "private_key_id": "8267b899e08a82ad09aae87cd92782f04637ac51",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDcusgpfGlgFen8\nsllxcPJIvSEGQshfSjXIlwuzz4E3+M1itiTP/0j8d/5/KZcJFc5n/EZO0AOd5tpI\nWbek4ENLrj2d9hzsuq9E9wdqogX4ZMk2sp1VYTRtiyzcwO+LHtokRCzQl8IdzMoZ\nTqwXEapZA2Me80H4K9Vw4yUj/5anm8UAEwF82tpr7a+UQ/lV5zi+c3vbmd57mj96\nGjsyvo1+/z+ge6rmA9mvnCQ0pP+W4Etyy36N4u9AVhMXPG3NnqFp7MD7rmqMjzpe\nLjCmUkagD9JxN7+1wfA3Tj/HN3Ajf49oa5GmiShJ+HUxCPk6Odm6dikWv/xk7NED\nWSitzC4jAgMBAAECggEATiScDz/ZyGgJrenwC166j7DRO7ex2zZZAxoiTPaV3xxo\njd1A/Bf7HVJX2Wn+a/t51stzkpxG44RiW8HTZ33zpRva+YyzYcWXnjk8OW6B4ZXA\nvGoQlDT1DCD88WwmgeCaxsMSAIjxcn5ZQAtflk0tOxUdZswk2zideDkaIXvvOIef\nHTiTw2TSsf85nttWzN9BxfuGPWYb6u0oUETxuykFriMAQbsq8/i5xB4N4NTUNSR5\nnI3ji+Obun7Wa6IRQe9pD8QZuWG+A2/4Ihg82ATZ/wHwUzmSXOFhbk5UFFaDGmcW\nIRS5L1X1AlUsiQg73zyy9htJiUmbTxDcYttd+7wErQKBgQD0rKsg9Ys46IP7Q1rG\nUwt+9jbK9lYa5S4Iy4iBmvzr1nyq8nuK3Uu6sA0SqHQf3itTWmJtP5/Trw8O/JV7\nlXkYUYkQCxASW3tg3aj2bZclTgdEPNl3kWZUpe/f13SuSchLVmOqfT7Hut3SDPPi\n/hMCBuZxOl4lifZ8ChW5zZy4nQKBgQDm8l9oqHM1VEcLxjpZ1MZvOAW9iRzBktMq\nxCjTsSipOy4TBlquyZT/e2dkIvtMjELIihue1pw4evdltCHKtn97nCzK8ltSLo0O\nBw/miHyGPgvlId8OU1p+z9Eh+ujNZIkAPncqIU5YdP8CmlQL7gPrI7jxvkInnXax\nnceWGYLlvwKBgDi7gMKXrLx5TYEJURcDUnsR5AqTq8t4sH/hkblbkqGsjiOlLfg4\n78JN5/oXjTWGck1Ve9URF6IhyUAUWSTat8Vnwnwx1HwtMiJ3wyHAr3c67HxqD5Kl\n6DBgeYpRjwCKoyK02U9C0zfEoIJ/9lz/xLCHoQ9IFWRm5PxF6lu2zUwRAoGAELwt\nd7sFJi8mOs8xeUL24iZQHCzsXYaTML0oLDbhOGoma5CBT7shxeWeV15FkYV0bW28\nlKT+iwU2GjOUY0kYMc/eWxJ21Zyz8flHCLCJPX0PhZoPvM0DeL78a5bv+bo4R0E/\nh1kEgVpxBDJEttyXghmDlFjyGEbLzBEf3luY5acCgYEAhVw62NfIC4QNJ2lAPZOG\nSyfuvNJePF6/1lg7MB+Lm3jmEIXfbLYLY+Axq0vXB0tZIterLsfi3W8HI6QQJfnn\n+jqdOOeq6xKlsRhFlYzEZ9QfvBFJ+p7t1c1A603CikDC7UAYgGNWpYdsIru7tz8g\nw8zflnwn0cDBimZHrJWczyw=\n-----END PRIVATE KEY-----\n",
  "client_email": "village-bank@village-banking-369511.iam.gserviceaccount.com",
  "client_id": "115581182324822820949",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/village-bank%40village-banking-369511.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static const _spreadsheetId = '1ikb0kODE32_q30212FsPu6pI1CQ3sT8Z1BIW32Xjb1Q';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    // ignore: avoid_print
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
