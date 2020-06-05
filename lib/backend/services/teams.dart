import 'package:graphql/client.dart';

class TeamService {
  GraphQLClient _client;
  TeamService({GraphQLClient client}) {
    _client = client;
  }

  String _teamsQuery = r'''
    query getTeams () {
      teams {
        id
        teamName
        description
        isVolunteer
        isApproved
        host {
          id
          hostName
          houseNumber
          email
        }
      }
    }
  ''';

  String _teamQuery = r'''
    query getTeam ($teamId: String) {
      team (teamId: $teamId) {
        id
        teamName
        description
        isVolunteer
        isApproved
        host {
          id
          hostName
          houseNumber
          email
        }
      }
    }
  ''';

  Future<List<dynamic>> getTeams({String query}) async {
    String queryToUse;

    if (query == null || query == '') {
      queryToUse = _teamsQuery;
    } else {
      queryToUse = query;
    }

    QueryOptions options = QueryOptions(documentNode: gql(queryToUse));

    QueryResult result = await _client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    List<dynamic> data = result.data['teams'] as List<dynamic>;
    return data;
  }

  Future<dynamic> getTeam({String query, String teamId}) async {
    String queryToUse;
    QueryOptions optionToUse;

    if (query == null || query == '') {
      queryToUse = _teamQuery;
      optionToUse = QueryOptions(
        documentNode: gql(queryToUse),
        variables: <String, dynamic>{
          'teamId': teamId,
        },
      );
    } else {
      queryToUse = query;
      optionToUse = QueryOptions(
        documentNode: gql(queryToUse),
      );
    }

    QueryResult result = await _client.query(optionToUse);
    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    List<dynamic> data = result.data['team'] as List<dynamic>;
    return data;
  }
}
