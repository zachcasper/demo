extension radius
extension radiusResources

param environment string
param connectionString string
param credentialType string
param basicUserName string
@secure()
param basicPassword string
@secure()
param apiKey string
@secure()
param jwt string

// Application representing the external service

// Shared resource for all applications representing an external service
// Notice there is no application property. This resource is deployed into an environment.
// This functions similarly to a Kubernetes ConfigMap, but is Radius environment-specific.
resource twilio 'Radius.Resources/externalService@2023-10-01-preview' = {
  name: 'twilio'
  properties:{
    environment: environment
    connectionString: connectionString
    credentials: {
      type: credentialType
      basicUserName: basicUserName
      basicPassword: basicPassword
      apiKey: apiKey
      jwt: jwt
    }
  }
}
