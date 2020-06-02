import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:straatinfoflutter/services/graph_ql_config.dart';
import 'package:straatinfoflutter/services/query_mutation.dart';

class SampleCountries extends StatefulWidget {
  @override
  _SampleCountriesState createState() => _SampleCountriesState();
}

class _SampleCountriesState extends State<SampleCountries> {
  GraphQlConfig graphQlConfig = GraphQlConfig();
  QueryMutation queryMutation = QueryMutation();
  String code = '5ec909abb0462e0017f83518';
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQlConfig.client,
      child: Container(
        child: Query(options: QueryOptions(documentNode: gql(
            queryMutation.getAllUsers()),
        ),
            builder: (
                QueryResult result, {
                  VoidCallback refetch,
                  FetchMore fetchMore
                }
                ) {
              if(result.data == null) {
                return Text('no data found!');
              }
              print(result.data);

              print(result.data['users'].length);
              return ListView.builder(itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(result.data['users'][index]['id'] +'\n'+ result.data['users'][index]['email']),
                );
              }, itemCount: result.data['users'].length,);
            }
        ),
      ),
    );
  }
}


