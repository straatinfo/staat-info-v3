import 'package:graphql/client.dart';
import 'package:straatinfoflutter/backend/services/authentication.dart';
import 'package:straatinfoflutter/backend/services/teams.dart';
import 'package:straatinfoflutter/backend/services/users.dart';
import 'package:straatinfoflutter/backend/utils/graphql_client.dart';

class Services {
  GraphqlserviceClient _serviceClient;
  TeamService teamService;
  AuthenticationService authService;
  UserService userService;

  Services({String jsonToken}) {
    _serviceClient = GraphqlserviceClient(jwt: jsonToken);
    GraphQLClient client = _serviceClient.getClient();
    teamService = TeamService(client: client);
    authService = AuthenticationService();
    userService = UserService(client: client);
  }
}
