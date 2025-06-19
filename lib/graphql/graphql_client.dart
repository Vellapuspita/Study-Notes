import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/auth_services.dart';

Future<GraphQLClient> getGraphQLClient() async {
  // Dynamically set the URI based on the platform
  final String uri = kIsWeb
      ? 'http://localhost:8080/query' // For web
      : 'http://10.0.2.2:8080/query'; // For Android emulator

  final httpLink = HttpLink(uri);

  final authToken = await AuthServices.getToken();
  print('Auth Token: $authToken'); // Debugging log

  final AuthLink authLink = AuthLink(
    getToken: () async => authToken != null ? 'Bearer $authToken' : null,
  );

  final link = authLink.concat(httpLink);

  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()), // Use InMemoryStore for caching
    link: link,
  );
}
