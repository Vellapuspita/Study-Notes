const String registerMutation = r'''
mutation RegisterMutation($input: RegisterInput!) {
  register(input: $input) {
    token
    user {
      id
      email
      name
    }
  }
}
''';
