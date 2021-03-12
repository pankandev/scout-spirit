import 'dart:convert';

final _config = {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "us-west-2:b6535368-12b8-45a3-9308-1c30cec20964",
              "Region": "us-west-2"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-2_Tau9d2K6B",
            "AppClientId": "1i9t2btpfetg45a8d1cg3r5qgs",
            "Region": "us-west-2"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    },
  },
  "analytics": {
    "plugins": {
      "awsPinpointAnalyticsPlugin": {
        "pinpointAnalytics": {
          "appId": "d6dceb728fe2406dac16bc26d2e495b1",
          "region": "us-west-2"
        },
        "pinpointTargeting": {"region": "us-west-2"}
      }
    }
  },
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "PPSAPI": {
          "endpointType": "REST",
          "endpoint": "https://5ls6ka1vg1.execute-api.us-west-2.amazonaws.com/Prod/",
          "region": "us-west-2",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS",
        }
      }
    }
  }
};

final String amplifyconfig = jsonEncode(_config);
