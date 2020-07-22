import 'package:graphql/client.dart';
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';
import 'package:straatinfoflutter/backend/model/team.dart';

final HttpLink httpLink = HttpLink(
    uri: graphqlUrl
);

final GraphQLClient client = GraphQLClient(
  cache: InMemoryCache(),
  link: httpLink,
);

class TeamService {
  Future<List<dynamic>> getTeams(bool teamVolunteer) async {
    List<Team> teamList = [];
    const String getTeamsQuery = r'''
      query GetTeams($isVolunteer: Boolean) {
        teams(isVolunteer: $isVolunteer) {
          id
          teamName      
        }
      }
      ''';

    final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.noCache, // for verification, without this you cant fetch new data
      documentNode: gql(getTeamsQuery),
        variables: <String, dynamic>{
          'isVolunteer': teamVolunteer,
        },
    );
    print(teamVolunteer);
    QueryResult result = await client.query(options);
    if(result.hasException) {
      print(result.exception.toString());
      return [];
    }
    print('querying...');
    final List<dynamic> teamsResult = result.data['teams'] as List<dynamic>;
    for(dynamic team in teamsResult) {
      teamList.add(Team(name: team['teamName'], id: team['id']));
    }
    return teamList;
  }
}