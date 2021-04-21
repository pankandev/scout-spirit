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
              "PoolId": "us-west-2:90ba3bdf-3c3e-4bea-853b-11f11344deec",
              "Region": "us-west-2"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-2_vbPmGbURK",
            "AppClientId": "6j4lha55h4agpjlgdck0hbdtse",
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
          "appId": "ff90b7d6185047dc8bd8533f0854e5d2",
          "region": "us-west-2"
        },
        "pinpointTargeting": {"region": "us-west-2"}
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "scout-spirit-gallery",
        "region": "us-west-2"
      }
    }
  }
};

final String amplifyconfig = jsonEncode(amplifyConfigMap);
