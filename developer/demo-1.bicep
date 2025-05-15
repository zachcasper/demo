extension radius
extension radiusResources

param environment string

resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: todolist.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      env: {
        CONNECTION_POSTGRES_HOST: {
          value: postgresql.properties.host
        }
        CONNECTION_POSTGRES_PORT: {
          value: string(postgresql.properties.port)
        }
        CONNECTION_POSTGRES_USERNAME: {
          value: postgresql.properties.username
        }
        CONNECTION_POSTGRES_DATABASE: {
          value: postgresql.properties.database
        }
        CONNECTION_POSTGRES_PASSWORD: {
          value: postgresql.properties.password
        }   
      }
    }
    connections: {
      postgresql: {
        source: postgresql.id
      }
    }
  }
}

resource postgresql 'Radius.Resources/postgreSQL@2023-10-01-preview' = {
  name: 'postgresql'
  location: 'global'
  properties: {
    application: todolist.id
    environment: environment
    size: 'S'
  }
}
