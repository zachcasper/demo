extension radius
extension radiusResources

resource test 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'test-azure'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'test'
    }
    recipes: {
      'Radius.Resources/webService': {
        default: {
          templateKind: 'bicep'
          templatePath: 'ghcr.io/zachcasper/recipes/webservice:latest'
        }
      }
      // TODO: Not implemented yet
      // 'Radius.Resources/postgreSQL': {
      //   default: {
      //     templateKind: 'terraform'
      //     templatePath: 'git::https://github.com/zachcasper/demo.git//recipes/azure/postgresql'
      //   }
      // }
      'Radius.Resources/redis': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/demo.git//recipes/azure/redis'
        }
      }
      'Radius.Resources/mySQL': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/demo.git//recipes/azure/mySQL'
        }
      }
    }
  }
}
