import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlConfig {
  static final HttpLink httpLink = HttpLink(
      uri: 'https://straat-backend-v3.herokuapp.com/graphql'
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    ),
  );



}