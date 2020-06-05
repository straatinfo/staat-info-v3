import 'package:graphql/client.dart';

class GraphqlserviceClient {
  GraphQLClient _client;

  GraphqlserviceClient({String jwt}) {
    HttpLink _httpLink = HttpLink(
      uri:
          'https://straat-backend-v3.herokuapp.com/graphql', // should be an env var
    );

    AuthLink _authLink = AuthLink(
      getToken: () async => 'Bearer $jwt',
    );

    Link _link = _authLink.concat(_httpLink);

    _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
  }

  GraphQLClient getClient() {
    return _client;
  }
}
