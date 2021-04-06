import 'dart:convert';

final amplifyConfigMap = {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "us-west-2:160f7faf-21f1-4611-9f73-bcb1849fe4be",
              "Region": "us-west-2"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-2_SwOlCeGN1",
            "AppClientId": "12np1gn5jf4dcgfi6ub47e6oeq",
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
  }
};

final String amplifyconfig = jsonEncode(amplifyConfigMap);
