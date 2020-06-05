import 'package:graphql/client.dart';

class UserService {
  GraphQLClient _client;
  UserService({GraphQLClient client}) {
    _client = client;
  }

  String _usersQuery = r'''
    query getUsers ($hostId: String) {
      users (hostId: $hostId, softRemoved: false) {
        id
        email
        username
        fname
        lname
        isVolunteer
        gender
        _host
        host {
          id
          hostName
          houseNumber
          email
        }
        teamMembers {
          id
          _team
          team {
            id
             teamName
          }
        }
      }
    }
  ''';

  String _userQuery = r'''
    query getUser ($userId: String) {
      user (id: $userId) {
        id
        email
        username
        fname
        lname
        isVolunteer
        gender
        _host
        host {
          id
          hostName
          houseNumber
          email
        }
        teamMembers {
          id
          _team
          team {
            id
             teamName
          }
        }
      }
    }
  ''';

  Future<List<dynamic>> getUsers({String query, String hostId}) async {
    String queryToUse;
    QueryOptions optionToUse;

    if (query == null || query == '') {
      queryToUse = _usersQuery;
      optionToUse = QueryOptions(documentNode: gql(queryToUse));
    } else {
      queryToUse = query;
      optionToUse = QueryOptions(
        documentNode: gql(queryToUse),
        variables: <String, dynamic>{
          'hostId': hostId,
        },
      );
    }

    QueryResult result = await _client.query(optionToUse);
    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    List<dynamic> data = result.data['users'] as List<dynamic>;
    return data;
  }

  Future<dynamic> getUser({String query, String userId}) async {
    String queryToUse;
    QueryOptions optionToUse;

    if (query == null || query == '') {
      queryToUse = _userQuery;
      optionToUse = QueryOptions(
        documentNode: gql(queryToUse),
        variables: <String, dynamic>{
          'userId': userId,
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

    List<dynamic> data = result.data['user'] as List<dynamic>;
    return data;
  }
}
