import 'dart:io';

import 'package:postgres/postgres.dart';

//trackID will be taken from the results of the API Search, along with trackName and artistName
Future<void> InsertIntoSongsTable(String trackID, String trackName, String artistName) async{

  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath,
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );

  String query = '''INSERT INTO songs VALUES('$trackID', '$trackName', '$artistName') ON CONFLICT (song_id) do nothing;''';
  await conn.execute(query);

  await conn.close();

}

//userID will be the UUID that we get from Firebase Auth
Future<void> InsertIntoUsersTable(String userID, String displayName) async{
  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath,
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );

  String query = '''INSERT INTO users VALUES('$userID', '$displayName') ON CONFLICT (user_id) do nothing;''';
  await conn.execute(query);

  await conn.close();

}

Future<void> InsertIntoReviewsTable(String reviewContent, String trackID, String userID) async{
  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath,
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );

  String query = '''INSERT INTO reviews VALUES(DEFAULT, '$reviewContent', '$trackID', '$userID', now());''';
  await conn.execute(query);

  await conn.close();
}

Future<List> getSongReviews(String trackID) async{
  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath, //Postgres public IP
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,//get rid for public access
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );


  final result = await conn.execute("SELECT * FROM reviews INNER JOIN songs USING (song_id) INNER JOIN users USING(user_id) WHERE song_id = '$trackID';");
  /*
  format of the result is as follows:

  [[user_id, song_id, review_id, review content, created(timestamp), song title, artist_name, user displayname], ...repeats for all database entries retrieved]
  */
  var holder = result.toList();

  await conn.close();

  return holder;
}

Future<List> getOwnReviews(String userID) async{
  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath,
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );


  final result = await conn.execute("SELECT * FROM reviews INNER JOIN songs USING (song_id) INNER JOIN users USING(user_id) WHERE user_id = '$userID';");
  /*
  format of the result is as follows:

  [[user_id, song_id, review_id, review content, created(timestamp), song title, artist_name, user displayname], ...repeats for all database entries retrieved]
  */
  var holder = result.toList();

  await conn.close();

  return holder;
}

Future<void> DeleteUserReviews(String userID) async {
  final String connectionName = Platform.environment['CLOUD_SQL_CONNECTION_NAME']!;
  final String databaseName = Platform.environment['DB_NAME']!;
  final String user = Platform.environment['DB_USER']!;
  final String password = Platform.environment['DB_PASS']!;
  final String socketPath = '/cloudsql/$connectionName/.s.PGSQL.5432';


  Connection conn = await Connection.open(
    Endpoint( 
      host: socketPath,
      database: databaseName,
      username: user,
      password: password,
      //password: 'CgetsDegrees',
      isUnixSocket: true,
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable),
  );

  String query = '''DELETE FROM reviews WHERE user_id = '$userID';''';
  await conn.execute(query);

  await conn.close();
}