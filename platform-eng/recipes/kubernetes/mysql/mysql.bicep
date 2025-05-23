@description('Information about what resource is calling this Recipe. Generated by Radius.')
param context object

@description('Name of the PostgreSQL database. Defaults to the name of the Radius resource.')
param database string = context.resource.name

@description('MySQL username')
param user string = 'mysql'

@description('MySQL password')
@secure()
#disable-next-line secure-parameter-default
param password string = 'WU9VUl9QQVNTV09SRA=='

extension kubernetes with {
  kubeConfig: ''
  namespace: context.runtime.kubernetes.namespace
} as kubernetes

var uniqueName = 'mysql-${uniqueString(context.resource.id)}'
var port = 3306

resource mysql 'apps/Deployment@v1' = {
  metadata: {
    name: uniqueName
  }
  spec: {
    selector: {
      matchLabels: {
        app: context.application.name
        tier: 'mysql'
      }
    }
    template: {
      metadata: {
        labels: {
          app: context.application.name
          tier: 'mysql'
          // Label pods with the application name so `rad run` can find the logs.
          'radapp.io/application': context.application == null ? '' : context.application.name
        }
      }
      spec: {
        containers: [
          {
            name: 'mysql'
            image: 'mysql:8.0'
            ports: [
              {
                containerPort: port 
              }
            ]
            env: [
              {
                name: 'MYSQL_ROOT_PASSWORD'
                value: password
              }
              {
                name: 'MYSQL_DATABASE'
                value: context.application.name
              }
              {
                name: 'MYSQL_USER'
                value: context.application.name
              }
              {
                name: 'MYSQL_PASSWORD'
                value: password
              }
            ]
          }
        ]
      }
    }
  }
}

resource svc 'core/Service@v1' = {
  metadata: {
    name: 'mysql'
    labels: {
      app: context.application.name
    }
  }
  spec: {
    type: 'ClusterIP'
    selector: {
      app: context.application.name
      tier: 'mysql'
    }
    ports: [
      {
        port: port 
      }
    ]
  }
}

output result object = {
  resources: [
    '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    '/planes/kubernetes/local/namespaces/${mysql.metadata.namespace}/providers/apps/Deployment/${mysql.metadata.name}'
  ]
  values: {
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: port
    database: database
    username: user
  }
  secrets: {
    #disable-next-line secure-parameter-default
    password: password
  } 
}
