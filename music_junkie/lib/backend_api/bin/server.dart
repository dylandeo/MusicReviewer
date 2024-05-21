import 'dart:io';
import 'package:alfred/alfred.dart';
import 'postgres_helper.dart';

void main() async {
  final app = Alfred();

  //Get CURRENT USERS reviews
  app.get('/users/:userid', (req, res) async {
    List result = await getOwnReviews(req.params['userid']);
    return result.toString();
  });

  //Get Song reviews
  app.get('/songs/:trackid', (req, res) async {
    List result = await getSongReviews(req.params['trackid']);
    return result.toString();
  });

  //Delete current user's reviews
  app.delete('/users/:userid', (req, res) async {
    await DeleteUserReviews(req.params['userid']);
  });

  //Insert new user into database
  app.post('/users/:userid/:displayName', (req, res) async {
    await InsertIntoUsersTable(req.params['userid'], req.params['displayName']);
  });

  //Insert new song into database
  app.post('/songs/:trackid/:trackName/:artistName', (req, res) async {
    await InsertIntoSongsTable(req.params['trackid'], req.params['trackName'], req.params['artistName']);
  });

  //Insert new review into database
  app.post('/reviews/:trackid/:userID', (req, res) async {
    final content = await req.body as Map;
    InsertIntoReviewsTable(content['review'], req.params['trackid'], req.params['userID']);
  });

  final envPort = Platform.environment['PORT'];

  await app.listen(envPort != null ? int.parse(envPort) : 8080);
}