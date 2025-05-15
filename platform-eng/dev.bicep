extension radius
extension radiusResources

resource dev 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'dev'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'dev'
    }
    recipes: {
      'Radius.Resources/webService': {
        default: {
          templateKind: 'bicep'
          templatePath: 'ghcr.io/zachcasper/recipes/webservice:latest'
        }
      }
      'Radius.Resources/postgreSQL': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/demo.git//platform-eng/recipes/kubernetes/postgresql'
        }
      }
      'Radius.Resources/redis': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/demo.git//platform-eng/recipes/kubernetes/redis'
        }
      }
      'Radius.Resources/mySQL': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/demo.git//platform-eng/recipes/kubernetes/mySQL'
        }
     }
    }
  }
}
