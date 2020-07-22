import 'package:graphql/client.dart';
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';
import 'package:straatinfoflutter/backend/model/map_pin_data.dart';
import 'package:intl/intl.dart';

final HttpLink _httpLink = HttpLink(
    uri: graphqlUrl
);
final AuthLink _authLink = AuthLink(
  getToken: () async => 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1ZWM4ZmVmZWIwNDYyZTAwMTdmODM1MGYiLCJpYXQiOjE1OTM3NzM3Njk1MTl9.d4j5yyuLH-uLp2nf0vbeL3tMWY6ecMNeXDcNhkNMdsc',
);

final Link _link = _authLink.concat(_httpLink);

final GraphQLClient _client = GraphQLClient(
  cache: InMemoryCache(),
  link: _link,
);



class ReportService {

  Future<List<dynamic>> getMainCategories() async {
    const String getMainCategoriesQuery = r'''
      query GetMainCategories() {
        mainCategories {
            id
            name
          }
      }
      ''';

    final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.noCache, // for verification, without this you cant fetch new data
      documentNode: gql(getMainCategoriesQuery),
    );

    QueryResult result = await _client.query(options);
    if(result.hasException) {
      print(result.exception.toString());
      return [];
    }
    print('querying...');
    final List<dynamic> mainCategories = result.data['mainCategories'] as List<dynamic>;
    return mainCategories;
  }

  Future<List<dynamic>> getSubCategories() async {
    const String getSubCategoriesQuery = r'''
      query GetSubCategories() {
        subCategories {
            id
            name
          }
      }
      ''';

    final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.noCache, // for verification, without this you cant fetch new data
      documentNode: gql(getSubCategoriesQuery),
    );

    QueryResult result = await _client.query(options);
    if(result.hasException) {
      print(result.exception.toString());
      return [];
    }
    print('querying...');
    final List<dynamic> subCategories = result.data['subCategories'] as List<dynamic>;
    return subCategories;
  }

  List<String> imageIdPutToArray(String idImageOne, String idImageTwo, String idImageThree,) {
    List<String> attachmentIDList = [];
    if(idImageOne != null) {
      attachmentIDList.add(idImageOne);
    }
    if(idImageTwo != null) {
      attachmentIDList.add(idImageTwo);
    }
    if(idImageThree != null) {
      attachmentIDList.add(idImageThree);
    }

    return attachmentIDList;
  }

  Future<List<dynamic>> getAllReports() async {
    List<MapInfoWindowPinData> listOfReports = [];
    String mainCategory;
    String imageUrl;
    DateTime reportCreated;
    String formattedReportCreatedAt;
    

    const String getAllReports = r'''
      query GetAllReports() {
        reports {
            id,
            lat,
            long,
            status,
            createdAt,
            mainCategory {
              name
            },
            attachments {
              url
            }
            
          }
      }
    ''';

    final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.noCache, // for verification, without this you cant fetch new data
      documentNode: gql(getAllReports),
    );

    QueryResult result = await _client.query(options);
    if(result.hasException) {
      print(result.exception.toString());
      return [];
    }
    print('querying...');
    final List<dynamic> reportsList = result.data['reports'] as List<dynamic>;
    for(dynamic report in reportsList) {
      reportCreated = DateTime.fromMillisecondsSinceEpoch(int.parse(report['createdAt']));
      formattedReportCreatedAt = reportCreated.day.toString() + ' ' + DateFormat.LLL().format(reportCreated) + ' ' + reportCreated.year.toString();
      mainCategory = '';
      imageUrl = '';

      if(report['mainCategory'] != null && report['mainCategory'] != '') {
        mainCategory = report['mainCategory']['name'];
        if(mainCategory.length > 10) {
          mainCategory = mainCategory.substring(0, 9) + '...';
        }

      }

      if(report['attachments'] != null && report['attachments'].length > 0) {
        imageUrl = report['attachments'][0]['url'];
      }
      listOfReports.add(MapInfoWindowPinData(
        id: report['id'], lat: report['lat'], long: report['long'],
        status: report['status'], createdAt: formattedReportCreatedAt, mainCategory: mainCategory, imageUrl: imageUrl,
      ));

    }
    return listOfReports;

  }

  Future<dynamic> sendReportTypeA(String title, String description, String location,
      double lat, double long, String mainCategoryId, String subCategoryId, bool isUrgent,
      String hostId, String teamId, List<String> attachments) async {

    const String sendReportTypeA = r'''
        mutation SendReportTypeA($title: String, $description: String, $location: String, $lat: Float, 
          $long: Float, $mainCategoryId: String, $subCategoryId: String, $isUrgent: Boolean, $hostId: String, 
          $teamId: String, $attachments: [String!]!) {
            sendReportTypeA(
              title: $title,
              description: $description,
              location: $location,
              lat: $lat,
              long: $long,
              mainCategoryId: $mainCategoryId,
              subCategoryId: $subCategoryId,
              isUrgent: $isUrgent,
              hostId: $hostId,
              teamId: $teamId,
              attachments: $attachments,
          ) {
            status,
            statusCode,
            httpCode,
            message,
          }
        }
       ''';

    final MutationOptions options = MutationOptions(
      documentNode: gql(sendReportTypeA),
      variables: <String, dynamic>{
        'title': title, 'description': description, 'location': location, 'lat': lat,
        'long': long, 'mainCategoryId': mainCategoryId, 'subCategoryId': subCategoryId,
        'isUrgent': isUrgent, 'hostId': hostId, 'teamId': teamId, 'attachments': attachments,
      },
    );
    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return 500;
    } else {
      print(result.data);
      return result.data["sendReportTypeA"]["httpCode"];

    }
  }

  Future<dynamic> sendReportTypeB(String title, String description, String location,
      double lat, double long, String mainCategoryId, bool isUrgent, String hostId,
      String teamId, List<String> attachments, bool isVehicleInvolved, int vehicleInvolvedCount,
      String vehicleInvolvedDescription, bool isPeopleInvolved, int peopleInvolvedCount,
      String peopleInvolvedDescription) async {
        if(!isVehicleInvolved) {
          vehicleInvolvedCount = null;
          vehicleInvolvedDescription = null;
        }
        if(!isPeopleInvolved) {
          peopleInvolvedCount = null;
          peopleInvolvedDescription = null;
        }


       const String sendReportTypeB = r'''
        mutation SendReportTypeB($title: String, $description: String, $location: String, $lat: Float, 
          $long: Float, $mainCategoryId: String, $isUrgent: Boolean, $hostId: String, $teamId: String, 
          $attachments: [String!]!, $isVehicleInvolved: Boolean!, $vehicleInvolvedCount: Int, 
          $vehicleInvolvedDescription: String, $isPeopleInvolved: Boolean!, $peopleInvolvedCount: Int, 
          $peopleInvolvedDescription: String, 
          ) {
            sendReportTypeB(
              title: $title,
              description: $description,
              location: $location,
              lat: $lat,
              long: $long,
              mainCategoryId: $mainCategoryId,
              isUrgent: $isUrgent,
              hostId: $hostId,
              teamId: $teamId,
              attachments: $attachments,
              isVehicleInvolved: $isVehicleInvolved,
              vehicleInvolvedCount: $vehicleInvolvedCount,
              vehicleInvolvedDescription: $vehicleInvolvedDescription,
              isPeopleInvolved: $isPeopleInvolved,
              peopleInvolvedCount: $peopleInvolvedCount,
              peopleInvolvedDescription: $peopleInvolvedDescription,     
          ) {
            status,
            statusCode,
            httpCode,
            message,
          }
        }
       ''';

        final MutationOptions options = MutationOptions(
          documentNode: gql(sendReportTypeB),
          variables: <String, dynamic>{
            'title': title, 'description': description, 'location': location, 'lat': lat,
            'long': long, 'mainCategoryId': mainCategoryId, 'isUrgent': isUrgent, 'hostId': hostId,
            'teamId': teamId, 'attachments': attachments, 'isVehicleInvolved': isVehicleInvolved,
            'vehicleInvolvedCount': vehicleInvolvedCount, 'vehicleInvolvedDescription': vehicleInvolvedDescription,
            'isPeopleInvolved': isPeopleInvolved, 'peopleInvolvedCount': peopleInvolvedCount,
            'peopleInvolvedDescription': peopleInvolvedDescription,
          },
        );
        final QueryResult result = await _client.mutate(options);
        if (result.hasException) {
          print(result.exception.toString());
          return 500;
        } else {
          print(result.data);
          return result.data["sendReportTypeB"]["httpCode"];

        }

  }





}