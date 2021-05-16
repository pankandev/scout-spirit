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
              "PoolId": "us-west-2:e136debc-28bb-4221-b17e-4a75036d81c1",
              "Region": "us-west-2"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-2_hCEYOTuPN",
            "AppClientId": "449fe3r1v64qrjg559el1l95bn",
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
          "appId": "068ec224eb0c49968b6518d91bfccac3",
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
